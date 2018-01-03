Function Add-IdoItCategory {
    <#
        .SYNOPSIS
        Add-IdoItCategory

        .DESCRIPTION
        With Net-CmdbCategory you can add a category object for a given object.

        .PARAMETER Id
        This parameter contains the id of the object you want to add a category

        .PARAMETER Category
        This parameter takes a constant name of a specific category

        .PARAMETER CatgId
        With CatgId you can pass an id of a global category from table isysgui_catg

        .PARAMETER CatsId
        With CatsId you can pass an id of a specific catgeory from table isysgui_cats

        .PARAMETER Data
        The data parameter takes a hashtable with all the key-value pairs of the category you want to add

        .NOTES
        Version
        0.1.0     29.12.2017  CB  initial release
    #>
        [cmdletbinding(SupportsShouldProcess=$true)]
        Param (
            [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true, Position=0)]
            [int]$Id,

            [Parameter(Mandatory = $true, ParameterSetName="Category")]
            [string]$Category,

            [Parameter(Mandatory = $true, ParameterSetName="CatgId")]
            [int]$CatgId,

            [Parameter(Mandatory = $true, ParameterSetName="CatsId")]
            [int]$CatsId,

            [Parameter(Mandatory=$true)]
            [Hashtable]$Data
        )

        $Params = @{}
        $Params.Add("objID", $Id)

        Switch ($PSCmdlet.ParameterSetName) {
            "Category" {$Params.Add("category", $Category); Break }
            "CatgId" {$Params.Add("catgID", $CatgId); Break }
            "CatsId" {$Params.Add("catsID", $CatsId); Break }
        }

        $Params.Add("data", $Data)

        If ($PSCmdlet.ShouldProcess("Adding category on object $Id")) {
            $ResultObj = Invoke-IdoIt -Method "cmdb.category.create" -Params $Params

            Return $ResultObj
        }
    }