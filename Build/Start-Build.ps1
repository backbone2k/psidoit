Param(

    $Task = 'Default'

)

#Dependencies
Get-PackageProvider -Name NuGet -ForceBootstrap | Out-Null

If (-not (Get-Module -ListAvailable PSDepend))
{
    & (Resolve-Path "$PSScriptRoot\helpers\Install-PSDepend.ps1")
}

Import-Module PSDepend

$Null = Invoke-PSDepend -Path "$PSScriptRoot\build.requirements.psd1" -Install -Import -Force

Set-BuildEnvironment

Invoke-psake $PSScriptRoot\psake.ps1 -taskList $Task -nologo

Exit ( [int]( -not $psake.build_success ) )