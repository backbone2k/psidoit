# PSake makes variables declared here available in other scriptblocks
# Init some things
Properties {
    # Find the build folder based on build system
        $ProjectRoot = $ENV:BHProjectPath
        if(-not $ProjectRoot)
        {
            $ProjectRoot = Resolve-Path "$PSScriptRoot\.."
        }

    $Timestamp = Get-Date -UFormat "%Y%m%d-%H%M%S"
    $PSVersion = $PSVersionTable.PSVersion.Major
    $TestFile = "TestResults_PS$PSVersion`_$TimeStamp.xml"
    $lines = '----------------------------------------------------------------------'

    $Verbose = @{}
    if($ENV:BHCommitMessage -match "!verbose")
    {
        $Verbose = @{Verbose = $True}
    }
}

Task Default -Depends Test

Task Init {
    $lines
    Set-Location $ProjectRoot
    "Build System Details:"
    Get-Item ENV:BH*
    "`n"
}

Task Test -Depends Init  {
    $lines
    "`n`tSTATUS: Testing with PowerShell $PSVersion"

    # Gather test results. Store them in a variable and file
    $TestResults = Invoke-Pester -Path $ProjectRoot\Tests -PassThru -OutputFormat NUnitXml -OutputFile "$ProjectRoot\$TestFile"

    # In Appveyor?  Upload our tests! #Abstract this into a function?
    If($ENV:BHBuildSystem -eq 'AppVeyor')
    {
        (New-Object 'System.Net.WebClient').UploadFile(
            "https://ci.appveyor.com/api/testresults/nunit/$($env:APPVEYOR_JOB_ID)",
            "$ProjectRoot\$TestFile" )
    }

    Remove-Item "$ProjectRoot\$TestFile" -Force -ErrorAction SilentlyContinue

    # Failed tests?
    # Need to tell psake or it will proceed to the deployment. Danger!
    if($TestResults.FailedCount -gt 0)
    {
        Write-Error "Failed '$($TestResults.FailedCount)' tests, build failed"
    }
    "`n"
}

Task Build -Depends Test {
    $lines

    # Load the module, read the exported functions, update the psd1 FunctionsToExport
    Set-ModuleFunctions

    If ( $env:BHBuildSystem -eq 'AppVeyor') {
        # Bump the module version if we didn't already
        Try
        {

            #[System.Version]$version = $manifest.Version
            #Write-Output "Old Version: $version"
            #[String]$newVersion = New-Object -TypeName System.Version -ArgumentList ($version.Major, $version.Minor, $version.Build, $env:APPVEYOR_BUILD_NUMBER)
            #Write-Output "New Version: $newVersion"

            # Update the manifest with the new version value and fix the weird string replace bug
            #$functionList = ((Get-ChildItem -Path .\PSIdoIt\Public).BaseName)
            #Update-ModuleManifest -Path $manifestPath -ModuleVersion $newVersion -FunctionsToExport $functionList
            #(Get-Content -Path $manifestPath) -replace 'PSGet_Rubrik', 'Rubrik' | Set-Content -Path $manifestPath
            #(Get-Content -Path $manifestPath) -replace 'NewManifest', 'Rubrik' | Set-Content -Path $manifestPath
            #(Get-Content -Path $manifestPath) -replace 'FunctionsToExport = ', 'FunctionsToExport = @(' | Set-Content -Path $manifestPath -Force
            #(Get-Content -Path $manifestPath) -replace "$($functionList[-1])'", "$($functionList[-1])')" | Set-Content -Path $manifestPath -Force

            [version]$GithubVersion = Get-MetaData -Path $env:BHPSModuleManifest -PropertyName ModuleVersion -ErrorAction Stop
            Write-Output "Old Version: $GithubVersion"

            [version]$AppVeyorVersion = New-Object -TypeName System.Version -ArgumentList ($GithubVersion.Major, $GithubVersion.Minor, $GithubVersion.Build, $env:APPVEYOR_BUILD_NUMBER)
            #[version]$GithubVersion = Get-MetaData -Path $env:BHPSModuleManifest -PropertyName ModuleVersion -ErrorAction Stop
            if($AppVeyorVersion -ge $GithubVersion) {
                Update-Metadata -Path $env:BHPSModuleManifest -PropertyName ModuleVersion -Value $AppVeyorVersion -ErrorAction stop
                Write-Output "New Version: $AppVeyorVersion"
            }
        }
        Catch
        {
            "Failed to update version for '$env:BHProjectName': $_.`nContinuing with existing version"
        }
    }
}

Task Deploy -Depends Build {
    $lines

    $Params = @{
        Path = "$ProjectRoot\Build"
        Force = $true
        Recurse = $false # We keep psdeploy artifacts, avoid deploying those : )
    }
    Invoke-PSDeploy @Verbose @Params
}

Task Update -Depends Build {
    Try
    {
        # Set up a path to the git.exe cmd, import posh-git to give us control over git, and then push changes to GitHub
        # Note that "update version" is included in the appveyor.yml file's "skip a build" regex to avoid a loop
        $env:Path += ";$env:ProgramFiles\Git\cmd"
        Import-Module posh-git -ErrorAction Stop
        git checkout master
        git add --all
        git status
        git commit -s -m "Update version to $AppVeyorVersion"
        git push origin master
        Write-Host "PsIdoIt PowerShell Module version $AppVeyorVersion published to GitHub." -ForegroundColor Cyan
    }
    Catch
    {
        # Sad panda; it broke
        Write-Warning "Publishing update $AppVeyorVersion to GitHub failed."
        throw $_
    }
}