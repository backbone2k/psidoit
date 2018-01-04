$Verbose = @{}
if($env:APPVEYOR_REPO_BRANCH -and $env:APPVEYOR_REPO_BRANCH -notlike "master")
{
    $Verbose.add("Verbose",$True)
}
Function Get-Credential { Return @{UserName = 'myuser'} }

$ModuleManifestName = 'psidoit.psd1'
$ModuleManifestPath = "$PSScriptRoot\..\psidoit\$ModuleManifestName"

$PSVersion = $PSVersionTable.PSVersion.Major

Import-Module $PSScriptRoot\..\PsIdoIt -Force

. $PSScriptRoot\Ressources.ps1

<#Settings for connecting
$Settings = @{
    Username = "admin"
    Password = "admin"
    Uri = "https://demo.i-doit.com/src/jsonrpc.php"
    ApiKey = "c1ia5q"
}#>

Describe 'Module Manifest Tests' {
    It 'Passes Test-ModuleManifest' {
        Test-ModuleManifest -Path $ModuleManifestPath | Should Not BeNullOrEmpty
        $? | Should Be $true
    }
}

Describe -Name 'idoit login tests' -Fixture {

    It -Name '[Login] Valid credentials' -Test {
        #Arrange
        Mock -CommandName Invoke-WebRequest -Verifiable -MockWith {
            Return @{
                Content = $Ressources.Login.SuccessMock
                StatusCode = $Ressources.SuccessCode
            }
        } -ModuleName PSIdoIt

        Mock -CommandName Get-IdoitVersion -Verifiable -MockWith {
            Return @{Version="1.10"}
        } -ModuleName PSIdoIt

        Mock -CommandName Compare-IdoItRequestId -Verifiable -MockWith {
            Return $True
        } -ModuleName PSIdoIt
        #Act
        $Output = Connect-IdoIt -ConfigFile $PSScriptRoot\..\PsIdoIt\settings.json -Verbose
        $Output.TenantId | Should Be 1
        Assert-VerifiableMocks
    }
}

InModuleScope PSIdoIt {
    Describe 'Test-IdoitHttpSSL tests' {
        It 'Test https' {
            Test-IdoitHttpSSL -Uri "https://some.domain.de/somePath" | Should Be $True
        }

        It 'Test http' {
            Test-IdoitHttpSSL -Uri "http://some.domain.de/somePath" | Should Be $False
        }
    }
}