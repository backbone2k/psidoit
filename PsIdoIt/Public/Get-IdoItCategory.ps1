Function Get-IdoItCategory {
    <#
        .SYNOPSIS
        Get category information from the i-doit cmdb for a specific object id.

        .DESCRIPTION
        Get detailed information for a category for a given object. The resulting information depends mainly on the category you
        are requesting.

        .PARAMETER Id
        This is the  id of the object you want to query a category for. This parameter takes an integer and it should be greater than 0.

        You can also provide a value by pipline.

        .PARAMETER Category
        This parameter takes the constant name of a specific category you want to get information.

        The available constants can be retreived with Get-IdoItConstant.

        .PARAMETER CatgId
        Instead of providing a constant name for a category you can also pass an category id
        There are two types of categories available:
        - Global categories
        - Specific categories

        CatgId is for global category ids


        .PARAMETER CatsId
        Instead of providing a constant name for a category you can also pass an category id
        There are two types of categories available:
        - Global categories
        - Specific categories

        CatsId is for specific category ids

        .PARAMETER RawOutput
        You can provide a [Ref] parameter to the function to get back the raw response from the invoke to the I-doIt API.

        You have to put the parameter in parantheses like this:
        -RawOutput ([Ref]$Output)

        The return value is [Microsoft.PowerShell.Commands.HtmlWebResponseObject

        .EXAMPLE
        PS> Get-IdoItCategory -Id 3411 -Category "C__CATG__ACCOUNTING"

        This command will return the accounting category for object 3411.

        .EXAMPLE
        PS> Get-IdoItCategory -Id 55 -CatsId 1

        This command will return the specific category with id 1 for object with id 55.

        .NOTES
        Version
        0.1.0   29.12.2017  CB  initial release
        0.1.1   06.01.2018  CB  Updated inline help; Added RawOuput parameter
        0.1.2   10.01.2018  CB  Fixed pipline behavoir for the Id parameter
    #>
        [CmdletBinding()]
        Param (
            [Parameter (
                Mandatory = $True,
                ValueFromPipeline = $True,
                Position=0,
                ParameterSetName = "Category"
            )]
            [Parameter (
                Mandatory = $True,
                ValueFromPipeline = $True,
                Position=0,
                ParameterSetName = "CatgId"
            )]
            [Parameter (
                Mandatory = $True,
                ValueFromPipeline = $True,
                Position=0,
                ParameterSetName = "CatsId"
            )]
            [Int]$Id,

            [Parameter (
                Mandatory = $True,
                ParameterSetName = "Category"
            )]
            [String]$Category,

            [Parameter (
                Mandatory = $True,
                ParameterSetName = "CatgId"
            )]
            [Int]$CatgId,

            [Parameter (
                Mandatory = $True,
                ParameterSetName = "CatsId"
            )]
            [int]$CatsId,

            [Parameter (
                Mandatory = $False
            )]
            [Ref]$RawOutput
        )


        Process {

            $Params  = @{}
            $Params.Add("objID", $Id)

            Switch ($PSCmdlet.ParameterSetName) {
                "Category" { $Params.Add("category",$Category); Break }
                "CatgId" { $Params.Add("catgID",$CatgId); Break }
                "CatsId" { $Params.Add("catsID",$CatsId); Break }
            }

            $SplattingParameter = @{
                Method = "cmdb.category.read"
                Params = $Params
            }

            If ($PSBoundParameters.ContainsKey("RawOutput")) {
                $SplattingParameter.Add("RawOutput", $RawOutput)
            }

            Try {
                $ResultObj = Invoke-IdoIt @SplattingParameter
            }
            Catch {
                Throw $_
            }

            #We remove the original property id and rename objID to id to be consistant and be able to pipe results to
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
