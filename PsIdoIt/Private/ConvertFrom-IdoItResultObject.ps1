Function ConvertFrom-IdoItResultObject {
    <#
   .SYNOPSIS
   This helper function does some formatting and flattening to the original idoit result-

   .DESCRIPTION
   This helper function does some formatting and flattening to the original idoit result.

   It will Pascal-Case the property names and also removes '_' from the names.
   Idoit will also return relations within the answers. We flatten these results a little bit to make it more easy to use results without
   to much knowledge of the idoit relation model.

   .PARAMETER InputObject
   Takes one or more PSObjects and makes property names nicely and flattens the result if parameter NoFlatten is not provided

   .PARAMETER NoFlatten
   This switch will not change the original object structure of the object.

   .EXAMPLE
   PS> ConvertFrom-IdoItResultObject -InputObject (Get-IdoItCategory -Id 3411 -Category C__CATG__IP)

   This will the cache for idoit constants

   .NOTES
   Version
   0.1.0   20.01.2018 CB  initial release
   #>
    [CmdletBinding ()]
    Param (
        [Parameter (
            Mandatory = $True,
            Position = 0,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True
        )]
        [PSObject[]]$InputObject,

        [Switch]$NoFlattening
    )

    Process {

        $InputObjectProperties = $_.PSObject.Properties
        $HelperObject = [PSCustomObject]@{}


        Foreach ($Property in $InputObjectProperties)
        {

            #Idoi
            $PropertyName = ''
            $NameParts = $Property.Name.Split('_')
            ForEach ($Part in $NameParts)
            {

                $PropertyName += $Part.Substring(0,1).ToUpper() + $Part.Substring(1).ToLower()

            }



            If ($Property.TypeNameOfValue -eq 'System.Management.Automation.PSCustomObject')
            {

                If ( -not $NoFlattening)
                {

                    If ($Property.Value.PSObject.Properties.Name -contains 'ref_title')
                    {

                        $HelperObject | Add-Member -MemberType $Property.MemberType -Name $PropertyName -Value $Property.Value.ref_title

                    }
                    ElseIf ($Property.Value.PSObject.Properties.Name -contains 'title')
                    {

                        $HelperObject | Add-Member -MemberType $Property.MemberType -Name $PropertyName -Value $Property.Value.title

                    }
                    Else
                    {

                        $HelperObject | Add-Member -MemberType $Property.MemberType -Name $PropertyName -Value $Property.Value

                    }

                    If ($Property.Value.PSObject.Properties.Name -contains 'ref_id')
                    {

                        $HelperObject | Add-Member -MemberType $Property.MemberType -Name ($PropertyName+'Id') -Value $Property.Value.ref_id

                    }
                    ElseIf ($Property.Value.PSObject.Properties.Name -contains 'id')
                    {

                        $HelperObject | Add-Member -MemberType $Property.MemberType -Name ($PropertyName+'Id') -Value $Property.Value.ref_id

                    }

                }
                Else
                {
                    $tempObject = [PSCustomObject]@{}
                    ForEach ($P in $Property.Value.PSObject.Properties) {
                        $PropertyNameTemp = ''
                        $NameParts = $P.Name.Split('_')
                        ForEach ($Part in $NameParts)
                        {

                            $PropertyNameTemp += $Part.Substring(0,1).ToUpper() + $Part.Substring(1).ToLower()

                        }
                        $tempObject | Add-Member -MemberType $P.MemberType -Name $PropertyNameTemp -Value $P.Value
                    }
                    $HelperObject | Add-Member -MemberType $Property.MemberType -Name $PropertyName -Value $tempObject

                }

            }
            ElseIf ($Property.TypeNameOfValue -eq 'System.Object[]')
            {

                $tempArray = @()
                If ( -not $NoFlattening)
                {

                    ForEach ($Value in $Property.Value)
                    {


                        If ( ($Value.GetType()).Name -eq 'PSCustomObject')
                        {

                            If ($Value.PSObject.Properties.Name -contains 'title')
                            {

                                $tempArray += $Value.Title

                            }

                        }

                    }

                    $HelperObject | Add-Member -MemberType $Property.MemberType -Name $PropertyName -Value $tempArray

                }
                Else
                {
                    $HelperObject | Add-Member -MemberType $Property.MemberType -Name $PropertyName -Value $Property.Value
                }
            }

            Else {

                $HelperObject | Add-Member -MemberType $Property.MemberType -Name $PropertyName -Value $Property.Value
            }




        }

        Return $HelperObject
    }

}