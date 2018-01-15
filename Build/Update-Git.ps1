 Try  {

    # Set up a path to the git.exe cmd, import posh-git to give us control over git, and then push changes to GitHub
    # Note that "update version" is included in the appveyor.yml file's "skip a build" regex to avoid a loop
    [version]$BuildVersion = Get-MetaData -Path $env:BHPSModuleManifest -PropertyName ModuleVersion -ErrorAction Stop
    $env:Path += ";$env:ProgramFiles\Git\cmd"
    Write-Output "Importing posh-git"
    Import-Module posh-git -ErrorAction Stop

    Write-Output "Checkout $($env:BHBranchName)"
    git checkout $env:BHBranchName #git is sometimes sending stdout to stderr - this is a pitty

    Write-Output "Git add --all"
    git add --all

    Write-Output "Git status"
    git status

    Write-Output "Git commit"
    git commit -s -m "Update version to $BuildVersion"

    Write-Output "Git push"
    git push origin $env:BHBranchName

    Write-Host "PsIdoIt PowerShell Module version $BuildVersion published to GitHub." -ForegroundColor Cyan
}
Catch {
    #Sad panda; it broke
    Write-Warning "Publishing update $BuildVersion to GitHub failed."
    Throw $_
}
