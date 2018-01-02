Function Get-IdoItCategoryInfo {
    <#
        .SYNOPSIS
        Get-IdoItCategoryInfo

        .DESCRIPTION
        Get-IdoItCategoryInfo lets you discover all available category properties for a given category id

        .PARAMETER Category
        This parameter takes a constant name of a specific category

        .PARAMETER CatgId
        With CatgId you can pass an id of a global category from table isysgui_catg

        .PARAMETER CatsId
        With CatsId you can pass an id of a specific catgeory from table isysgui_cats

        .NOTES
        Version
        0.1.0     29.12.2017  CB  initial release
    #>
        Param (
            [Parameter(Mandatory = $True, ParameterSetName="Category")]
            [String]$Category,

            [Parameter(Mandatory = $True, ParameterSetName="CatgId")]
            [int]$CatgId,

            [Parameter(Mandatory = $True, ParameterSetName="CatsId")]
            [int]$CatsId
        )

        $Params = @{}

        Switch ($PSCmdlet.ParameterSetName) {
            "Category" { $Params.Add("category", $Category); break }
            "CatgId" { $Params.Add("catgID",$CatgId); break }
            "CatsId" { $Params.Add("catsID",$CatsId); break }
        }

        $ResultObj = Invoke-IdoIt -Method "cmdb.category_info" -Params $Params

        $ResultObj = $ResultObj | Add-ObjectTypeName -TypeName 'Idoit.Category.Info'

        Return $ResultObj
    }