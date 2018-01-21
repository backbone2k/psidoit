if(-not $ENV:BHProjectPath)
{
    Set-BuildEnvironment -Path $PSScriptRoot\.. -Force
}
Remove-Module $ENV:BHProjectName -ErrorAction SilentlyContinue
Import-Module (Join-Path $ENV:BHProjectPath $ENV:BHProjectName) -Force



InModuleScope $ENV:BHProjectName {
    $PSVersion = $PSVersionTable.PSVersion.Major
    #$ProjectRoot = $ENV:BHProjectPath

    $Verbose = @{}

    If ($ENV:BHBranchName -notlike "master" -or $env:BHCommitMessage -match "!verbose") {

        $Verbose.Add("Verbose", $True)

    }

    Describe -Name "New-IdoItCacheFile PS$PSVersion" {

        It -Name ''

    }

}