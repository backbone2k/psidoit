Function ConvertFrom-IdoItResultObject {

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

        #$NoFlattening = $True

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