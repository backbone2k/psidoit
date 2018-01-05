$Verbose = @{}
if($env:APPVEYOR_REPO_BRANCH -and $env:APPVEYOR_REPO_BRANCH -notlike "master")
{
    $Verbose.add("Verbose",$True)
}

$ModuleManifestName = 'PsIdoIt.psd1'
$ModuleManifestPath = "$PSScriptRoot\..\PsIdoIt\$ModuleManifestName"

$PSVersion = $PSVersionTable.PSVersion.Major

Import-Module $PSScriptRoot\..\PsIdoIt -Force

Describe 'Module Manifest Tests' {
    It 'Passes Test-ModuleManifest' {
        Test-ModuleManifest -Path $ModuleManifestPath | Should Not BeNullOrEmpty
        $? | Should Be $true
    }
}

InModuleScope PsIdoIt {
    Describe -Name 'Invoke-IdoIt tests' -Fixture {

        Context -Name 'Invoke successfull web requests' {
            #Arrange
            . $PSScriptRoot\Ressources.ps1

            Mock -CommandName Invoke-WebRequest -Verifiable -MockWith {
                Return [PSCustomObject]@{
                    Content = $Ressources.Login.SuccessMock
                    StatusCode = $Ressources.SuccessCode
                }
            } -ModuleName PsIdoIt

            Mock -CommandName New-IdoItRequestId -Verifiable -MockWith {
                Return 1
            } -ModuleName PsIdoIt



            It -Name 'Invoke' -Test {

                $Output = Invoke-IdoIt -Params @{} -Method "some.method" -Uri "http://some.uri.de"
                $Output.result | Should Be $True
                #Assert-VerifiableMock

            }

            It -Name 'Test raw output' -Test {
                $RawOuput = ""
                $Null = Invoke-IdoIt -Params @{} -Method "some.method" -Uri "http://some.uri.de" -RawOutput ([Ref]$RawOuput)
                $RawOuput.StatusCode | Should Be $Ressources.SuccessCode
                #Assert-VerifiableMock

            }
        }

        Context -Name 'Invoke error web requests' {
            #Arrange
            . $PSScriptRoot\Ressources.ps1

            Mock -CommandName Invoke-WebRequest -Verifiable -MockWith {
                Return [PSCustomObject]@{
                    Content = $Ressources.Login.ErrorMock
                    StatusCode = $Ressources.SuccessCode
                }
            } -ModuleName PsIdoIt

            Mock -CommandName New-IdoItRequestId -Verifiable -MockWith {
                Return 1
            } -ModuleName PsIdoIt



            It -Name 'Invoke' -Test {

                { Invoke-IdoIt -Params @{} -Method "some.method" -Uri "http://some.uri.de" } | Should Throw

            }

        }
    }
}

InModuleScope PsIdoIt {
    Describe -Name 'functional test internal functions' -Fixture {

        It -Name 'ConvertFrom-IdoitJsonRespone test' -Test {
            $Output = ConvertFrom-IdoItJsonResponse -InputString 'Test string with some quoted "12345" numbers'
            $Output | Should -BeExactly 'Test string with some quoted 12345 numbers'
        }

        It -Name 'Compare-IdoItRequestId test' -Test {
            $Id = [Guid]::NewGuid()
            $Output = Compare-IdoItRequestId -RequestID $Id -ResponseId $Id
            $Output | Should Be $True
        }

        It -Name 'New-IdoItRequestId test' -Test {
            $Output = New-IdoItRequestId
            $Output | Should Not Be $null
        }
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

InModuleScope PsIdoIt {
    Describe -Name 'idoit object tests' -Fixture {

        Context -Name 'Invoke successfull web requests' {
            #Arrange
            . $PSScriptRoot\Ressources.ps1

            Mock -CommandName Invoke-WebRequest -Verifiable -MockWith {
                Return [PSCustomObject]@{
                    Content = $Ressources.getobject.SuccessMock
                    StatusCode = $Ressources.SuccessCode
                }
            } -ModuleName PsIdoIt

            Mock -CommandName New-IdoItRequestId -Verifiable -MockWith {
                Return 1
            } -ModuleName PsIdoIt



            It -Name 'get object' -Test {

                $Output = Get-IdoItObject -Id 3411
                $Output.Id | Should Be 3411

            }
        }

    }
}