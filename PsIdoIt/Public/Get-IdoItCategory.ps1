Function Get-IdoItCategory {
    <#
        .SYNOPSIS
        Get-IdoItCategory

        .DESCRIPTION
        With Get-IdoItCategory you can retreive detailed information for a category for a given object.

        .PARAMETER Id
        This parameter contains the id of the object you want to query a category

        .PARAMETER Category
        This parameter takes a constant name of a specific category

        .PARAMETER CatgId
        With CatgId you can pass an id of a global category from table isysgui_catg

        .PARAMETER CatsId
        With CatsId you can pass an id of a specific catgeory from table isysgui_cats

        .EXAMPLE
        PS> Get-IdoItCategory -Id 3411 -Category "C__CATG__ACCOUNTING"

        This command will return the accounting category for object 3411.

        .EXAMPLE
        PS> Get-IdoItCategory -Id 55 -CatsId 1

        This command will return the specific category with id 1 for object with id 55.

        .NOTES
        Version
        0.1.0     29.12.2017  CB  initial release
    #>
        [CmdletBinding()]
        Param (
            [Parameter(Mandatory = $True, ValueFromPipelineByPropertyName=$true, Position=0)]
            [int]$Id,

            [Parameter(Mandatory = $True, ParameterSetName="Category")]
            [string]$Category,

            [Parameter(Mandatory = $True, ParameterSetName="CatgId")]
            [int]$CatgId,

            [Parameter(Mandatory = $True, ParameterSetName="CatsId")]
            [int]$CatsId
        )


        Process {

            $Params  = @{}
            $Params.Add("objID", $Id)

            Switch ($PSCmdlet.ParameterSetName) {
                "Category" { $Params.Add("category",$Category); Break }
                "CatgId" { $Params.Add("catgID",$CatgId); Break }
                "CatsId" { $Params.Add("catsID",$CatsId); Break }
            }


            $ResultObj = Invoke-IdoIt -Method "cmdb.category.read" -Params $Params

            #We remove the property original property id and rename objID to id to be consistant and be able to pipe results to
            #other Cmdlets

            ForEach ($O in $ResultObj) {
                If (@("CatgId", "CatsId") -contains $PSCmdlet.ParameterSetName) {
                    $O | Add-Member -MemberType NoteProperty -Name $PSCmdlet.ParameterSetName.ToLower() -Value $O.Id
                }
                Else {
                    $O | Add-Member -MemberType NoteProperty -Name "category" -Value $Category
                }
                $O.Id = $O.ObjID
                $O.PSObject.Properties.Remove("objID")

            }

            $ResultObj = $ResultObj | Add-ObjectTypeName -TypeName 'Idoit.Category'

            Return $ResultObj
        }
    }
