Function Get-IdoItVersion {
<#
    .SYNOPSIS
    Get-IdoItVersion

    .DESCRIPTION
    Retreive the i-doit version

    .NOTES
    Version
    0.1.0   29.12.2017  CB  initial release
#>
    $Params = @{}

    #CheckCmdbConnection

    $ResultObj = Invoke-IdoIt -Method "idoit.version" -Params $Params

    Return $ResultObj | Select-Object version, type, step
}