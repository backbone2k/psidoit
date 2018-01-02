Function Get-IdoItLocationTree {
<#
    .SYNOPSIS
    Get-IdoItLocationTree

    .DESCRIPTION
    With Get-CmdbLOcationTree you can define a parent object and retreive all child objects that are bound to this
    location

    .PARAMETER Id
    This is the object id of the parent object

    .EXAMPLE
    PS> Get-IdoItLocationTree -Id 38

    This will return all objects assigned to the parent object location with id 38

    .NOTES
    Version
    0.1.0     29.12.2017  CB  initial release
#>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $True, ValueFromPipelineByPropertyName = $True, Position = 0)]
        [Int]$Id
    )

    Process {
        $Params = @{}
        $Params.Add("id", $Id)

        $ResultObj = Invoke-IdoIt -Method "cmdb.location_tree.read" -Params $Params

        $ResultObj = $ResultObj | Add-ObjectTypeName -TypeName 'Idoit.Object'

        Return $ResultObj
    }
}
