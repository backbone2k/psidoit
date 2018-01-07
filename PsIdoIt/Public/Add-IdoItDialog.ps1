Function Add-IdoItDialog {
    <#
        .SYNOPSIS
        Add-IdoItDialog

        .DESCRIPTION
        Creates a new value for a dialog+ property

        .PARAMETER Category
        This parameter takes a constant name of a specific category

        .PARAMETER Property
        This is the name of the dialog+ property you want to add the value

        .PARAMETER Value
        This is the new value

        .EXAMPLE
        PS>Add-IdoItDialog -Category 'C__CATG__CPU' -Property 'Manufacturer' -Value 'ARM'

        Adds the Value ARM to the CPU Category in the Property Manufacturer

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
            [String]$Value
        )

        $Params = @{}
        $Params.Add("category",$Category)
        $Params.Add("property",$Property)
        $Params.Add("value",$Value)

        If ($PSCmdlet.ShouldProcess("Create new dialog entry $Category - $Property with value $Value")) {
            $ResultObj = Invoke-IdoIt -Method "cmdb.dialog.create" -Params $Params

            Return $ResultObj
        }
    }
