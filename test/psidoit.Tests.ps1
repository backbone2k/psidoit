$Verbose = @{}
if($env:APPVEYOR_REPO_BRANCH -and $env:APPVEYOR_REPO_BRANCH -notlike "master")
{
    $Verbose.add("Verbose",$True)
}

$ModuleManifestName = 'psidoit.psd1'
$ModuleManifestPath = "$PSScriptRoot\..\psidoit\$ModuleManifestName"

$PSVersion = $PSVersionTable.PSVersion.Major
Import-Module $PSScriptRoot\..\PsIdoIt -Force

#Settings for connecting
$Settings = @{
    Username = "admin"
    Password = "admin"
    Uri = "https://demo.i-doit.com/src/jsonrpc.php"
    ApiKey = "c1ia5q"
}

Describe 'Module Manifest Tests' {
    It 'Passes Test-ModuleManifest' {
        Test-ModuleManifest -Path $ModuleManifestPath | Should Not BeNullOrEmpty
        $? | Should Be $true
    }
}

Describe 'Test-IdoitHttpSSL tests' {
    It 'Test https' {
        Test-IdoitHttpSSL -Uri "https://some.domain.de/somePath" | Should Be $True
    }
}