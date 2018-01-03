Function Set-IdoItDialog {
    <#
        .SYNOPSIS
        Set-IdoItDialog

        .DESCRIPTION
        Change the values of a dialog+ entry

        .PARAMETER Category
        This parameter takes a constant name of a specific category

        .PARAMETER Property
        This is the name of the dialog+ property you want to change the value

        .PARAMETER Value
        This is the new value

        .PARAMETER ElementId
        This is the id of the element you want to set a new value.

        .NOTES
        Version
        0.1.0     29.12.2017  CB  initial release
    #>
        [CmdletBinding( SupportsShouldProcess = $True)]
        Param (
            [Parameter( Mandatory = $True, Position = 0)]
            [String]$Category,

            [Parameter( Mandatory = $True, Position = 1)]
            [String]$Property,

            [Parameter( Mandatory = $True, Position = 2)]
            [String]$Value,

            [Parameter( Mandatory = $True, Position = 3)]
            [Int]$ElementId
        )

        $Params = @{}
        $Params.Add("category",$Category)
        $Params.Add("property",$Property)
        $Params.Add("value",$Value)
        $Params.Add("entry_id",$ElementId)

        If ($PSCmdlet.ShouldProcess("Updating dialog entry id $ElementID for $Category - $Property with value $Value")) {
            $ResultObj = Invoke-IdoIt -Method "cmdb.dialog.update" -Params $Params

            Return $ResultObj
        }
    }
