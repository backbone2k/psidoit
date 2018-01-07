Function Remove-IdoItDialog {
    <#
        .SYNOPSIS
        Remove-IdoItDialog

        .DESCRIPTION
        Removes a value from a dialog+ property

        .PARAMETER Category
        This parameter takes a constant name of a specific category

        .PARAMETER Property
        This is the name of the dialog+ property you want to remove the value

        .PARAMETER ElementId
        This is the id of the element you want remove

        .EXAMPLE
        PS> Remove-IdoItDialog -Category 'C__CATG__CPU' -Property 'Manufacturer' -ElementId 123

        Removes the element id 123 from the Dialog+ list Manufacturer

        .NOTES
        Version
        0.1.0     29.12.2017  CB  initial release
    #>
        [CmdletBinding( SupportsShouldProcess = $True, ConfirmImpact = 'High')]
        Param (
            [Parameter( Mandatory = $True, Position = 0)]
            [String]$Category,

            [Parameter( Mandatory = $True, Position = 1)]
            [String]$Property,

            [Parameter( Mandatory = $True, Position = 3)]
            [Int]$ElementId
        )

        $Params = @{}
        $Params.Add("category",$Category)
        $Params.Add("property",$Property)
        $Params.Add("entry_id",$ElementId)

        If ($PSCmdlet.ShouldProcess("Removing dialog entry id $ElementID for $Category - $Property")) {
            $ResultObj = Invoke-IdoIt -Method "cmdb.dialog.delete" -Params $Params

            Return $ResultObj
        }
    }
