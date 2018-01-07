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

    Describe -Name "Get-IdoItObject PS$PSVersion" {

        Mock Invoke-IdoIt {

            . "$ENV:BHProjectPath\Tests\Ressources.ps1"
            Return $Data.IdoitObject

        } -ModuleName $ENV:BHProjectName

        It -Name 'Method of Get-IdoItObject should be cmdb.object.read' {
            Get-IdoItObject -Id 1
            Assert-MockCalled -CommandName Invoke-IdoIt -ParameterFilter { $Method -eq "cmdb.object.read"}
        }

        It -Name 'Params.Id of Get-IdoItObject should be 1' {
            Get-IdoItObject -Id 1
            Assert-MockCalled -CommandName Invoke-IdoIt -ParameterFilter { $Params.Id -eq 1}
        }

        It -Name 'TypeName of output object should be Idoit.Object' {
            $Output = Get-IdoItObject -Id 1
            $Output | Test-IdoitHasTypeName -TypeName 'Idoit.Object' | Should Be $True
        }

    }
}