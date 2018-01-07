Function Get-IdoItDialog {
    <#
        .SYNOPSIS
        Get-IdoItDialog

        .DESCRIPTION
        Retreive the values of a dialog+ attribute

        .PARAMETER Category
        This parameter takes a constant name of a specific category

        .PARAMETER Property
        This is the name of the dialog+ property you want to get the values

        .EXAMPLE
        PS>Get-IdoItDialog -Category 'Cat' -Propertey 'Prop'

        Gets a dialog value list for a given property

        .NOTES
        Version
        0.1.0     29.12.2017  CB  initial release
    #>
        Param (
            [Parameter( Mandatory=$True,
                        Position=0)]
            [String]$Category,

            [Parameter( Mandatory=$True,
                        Position=1)]
            [String]$Property
        )

        $Params = @{}
        $Params.Add("category",$Category)
        $Params.Add("property",$Property)

        $ResultObj = Invoke-IdoIt -Method "cmdb.dialog.read" -Params $Params

        $ResultObj = $ResultObj | Add-ObjectTypeName -TypeName 'idoit.dialog'

        If ( -Not ($ResultObj) ) {
            Write-Error "Could not find category $Category or property $Property"
        }
        Else {
            Return $ResultObj
        }
    }