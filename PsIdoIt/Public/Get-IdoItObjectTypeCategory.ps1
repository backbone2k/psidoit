Function Get-IdoItObjectTypeCategory {
<#
    .SYNOPSIS
    Get-IdoItObjectTypeCategory

    .DESCRIPTION
    Calling this Cmdlet you retreive all the available Categories for this object type

    .PARAMETER TypeId
    Defines the type id you wan't to retreive the configured categories

    .NOTES
    Version
    0.1.0     29.12.2017  CB  initial release
#>
    [CmdletBinding()]
    [OutputType([System.Object[]])]
    Param (
        [Parameter( Mandatory = $True, ValueFromPipeline = $True, Position = 0)]
        [Alias("TypeId")]
        $Type
    )

    Process {
        $Params = @{}
        $Params.Add("type", $Type)

        $ResultObj = Invoke-IdoIt -Method "cmdb.object_type_categories.read" -Params $Params

        #idoit delivers two arrays, depending of global or specific categories. From a PowerShell
        #point of view this is ugly - so we flatten the result into one PSObject.

        $ModifiedResultObj = @()
        ForEach ($o In $ResultObj.PSObject.Properties) {

            ForEach ($p In $ResultObj.($o.Name)) {
                $TempObj = $p
                $TempObj | Add-Member -MemberType NoteProperty -Name "type" -Value $o.Name
                $ModifiedResultObj += $TempObj
            }

        }

        $ModifiedResultObj = $ModifiedResultObj | Add-ObjectTypeName -TypeName 'IdoIt.ObjectTypeCategory'

        Return $ModifiedResultObj
    }
}