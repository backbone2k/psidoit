Function Get-IdoItObjectTypes {
    <#
    .SYNOPSIS
    Get-IdoItObjectTypes

    .DESCRIPTION
    Get-IdoItObjectTypes returns available object types. If you provide no parameters you will get all availabke
    object types from idoit.

    .PARAMETER Id
    If provided the result will be filtered these Ids

    .PARAMETER Title
    If provided the result will be filtered by title

    .PARAMETER Enabled
    Only return object types that are enabled

    .PARAMETER Limit
    Limit the number results to the this value

    .PARAMETER Sort
    You can sort the result Ascending or Descending

    .PARAMETER OrderBy
    Define by wich attribute the result is filtered

    .PARAMETER Countobjects
    When you define this switch parameter, you will get the amount of objects per object type

    .EXAMPLE
    PS> Get-IdoItObjectTypes -Id 123,572,1349 -Enabled

    This will return the object types 123, 572 and 1349 but will filter out objects if they are not enabled.

    .NOTES
    The parameters order_by and sort are not used through the api. Instead you can use the PowerShell to sort results :-)

    Version
    0.1.0     29.12.2017  CB  initial release
    #>
    [CmdletBinding()]
    Param (
        [Parameter( Mandatory=$False )]
        [Int[]]$Id,

        [Parameter( Mandatory=$False )]
        [string]$Title,

        [Parameter( Mandatory=$False )]
        [Switch]$Enabled,

        [Parameter( Mandatory=$False )]
        [Int]$Limit,

        [Parameter( Mandatory=$False )]
        [Switch]$CountObjects
    )

    #checkCmdbConnection

    Process {
        $Params= @{}

        $Filter = @{}

        ForEach ($PSBoundParameter in $PSBoundParameters.Keys) {

            Switch ($PSBoundParameter) {
                #Synetics is not consistant... again. In this method there is a difference for a scalar id and array of ids.
                #We reduce complexity and do a little vodoo :-)
                "Id" {
                    If ($Id.Count -eq 1) {
                        #this converts the single value to a scalar - othwerise we get a nasty error because
                        #idoit is not catching type mismatch here.
                        $Filter.Add("id", $Id[0])
                    }
                    Else {
                        $Filter.Add("ids", $Id)
                    }
                    Break
                }

                "Title" {
                    $Filter.Add("title", $Title)
                    Break
                }

                "Enabled" {
                    $Filter.Add("enabled", 1)
                    Break
                }

                "Limit" {
                    $Params.Add("limit", $Limit)
                    Break
                }

                "CountObjects" {
                    $Params.Add("countobjects", $CountObjects)
                    Break
                }
            }
        }


        $Params.Add("filter", $Filter)

        $ResultObj = Invoke-IdoIt -Method "cmdb.object_types.read" -Params $Params

        $ResultObj = $ResultObj | Add-ObjectTypeName -TypeName 'Idoit.ObjectType'

        Return $ResultObj
    }
}