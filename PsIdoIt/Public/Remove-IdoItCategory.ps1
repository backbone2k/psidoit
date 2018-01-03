Function Remove-IdoItCategory {
    <#
        .SYNOPSIS
        Remove-IdoItCategory

        .DESCRIPTION
        With Remove-IdoItCategory you can remove a category object for a given object.

        .PARAMETER Id
        This parameter contains the id of the object you want to remove a category

        .PARAMETER Category
        This parameter takes a constant name of a specific category

        .PARAMETER CatgId
        With CatgId you can pass an id of a global category from table isysgui_catg

        .PARAMETER CatsId
        With CatsId you can pass an id of a specific catgeory from table isysgui_cats

        .PARAMETER ElementId
        This value is mandatory for multi value categories like CPU or hostaddress.

        .NOTES
        Version
        0.1.0     29.12.2017  CB  initial release
    #>
        [CmdletBinding(SupportsShouldProcess = $True, ConfirmImpact = 'High')]
        Param (
            [Parameter(Mandatory = $True, ValueFromPipelineByPropertyName = $True, Position = 0)]
            [Int]$Id,

            [Parameter(Mandatory = $True, ParameterSetName = "Category")]
            [String]$Category,

            [Parameter(Mandatory = $true, ParameterSetName = "CatgId")]
            [Int]$CatgId,

            [Parameter(Mandatory = $True, ParameterSetName = "CatsId")]
            [Int]$CatsId,

            [Parameter(Mandatory = $True)]
            [Int]$ElementId

        )
        $Params = @{}

        $Params.Add("id", $Id)

        Switch ($PSCmdlet.ParameterSetName) {
            "Category" {$Params.Add("category", $Category); Break }
            "CatgId" {$Params.Add("catgID", $CatgId); Break }
            "CatsId" {$Params.Add("catsID", $CatsId); Break }
        }

        If ($PSBoundParameters.ContainsKey("ElementId")) {
            $Params.Add("cateID", $ElementId)
        }

        If ($PSCmdlet.ShouldProcess("Deleting category from object $id")) {
            $ResultObj = Invoke-Cmdb -Method "cmdb.category.delete" -Params $Params
            Return $ResultObj
        }
    }