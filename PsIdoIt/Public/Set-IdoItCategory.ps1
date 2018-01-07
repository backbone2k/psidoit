Function Set-IdoItCategory {
    <#
        .SYNOPSIS
        Set-IdoItCategory

        .DESCRIPTION
        With Set-IdoItCategory you can change values for a category for a given object.

        .PARAMETER Id
        This parameter contains the id of the object you want to change a category

        .PARAMETER Category
        This parameter takes a constant name of a specific category

        .PARAMETER CatgId
        With CatgId you can pass an id of a global category from table isysgui_catg

        .PARAMETER CatsId
        With CatsId you can pass an id of a specific catgeory from table isysgui_cats

        .PARAMETER Data
        The data parameter takes a hashtable with all the key-value pairs of the category you want to change.

        .EXAMPLE
        PS> Set-IdoItCategory -Id 3411 -Category 'C__CATG__CPU' -Data @{Manufacturer='Intel'}

        Changes the Manufacturer for the CPU to Intel for object 3411

        .NOTES
        Version
        0.1.0     29.12.2017  CB  initial release
    #>
        [CmdletBinding( SupportsShouldProcess = $True )]
        Param (
            [Parameter( Mandatory = $True, ValueFromPipelineByPropertyName = $True, Position = 0)]
            [Int]$Id,

            [Parameter( Mandatory = $True, ParameterSetName = "Category")]
            [String]$Category,

            [Parameter( Mandatory = $True, ParameterSetName = "CatgId")]
            [Int]$CatgId,

            [Parameter( Mandatory = $True, ParameterSetName = "CatsId")]
            [Int]$CatsId,

            [Parameter( Mandatory = $True )]
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

        If ($PSCmdlet.ShouldProcess("Updating category on object $Id")) {
            $ResultObj = Invoke-IdoIt -Method "cmdb.category.update" -Params $Params

            Return $ResultObj
        }
    }
