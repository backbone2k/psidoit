function New-IdoItObject {
    <#
        .SYNOPSIS
        New-IdoItObject

        .DESCRIPTION
        New-IdoItObject lets you create a new object.

        DYNAMIC PARAMETERS
        -Category <String>
            This parameter defines the dialog category on the general category. It is a dynamic parameter
            that will pull the available values in real time.

        -Purpose <String>
            This parameter defines the dialog purpose on the general category. It is a dynamic parameter
            that will pull the available values in real time.

        .PARAMETER Type
        This parameter either the type id or the the type name of the object you wan't to create.

        .PARAMETER Title
        This the title of the object you are creating.


        .EXAMPLE
        PS> New-IdoItObject -Type 5 -Title "srv12345.domain.de" -Purpose "Production"

        This will create a new Object of type 5 (C__OBJTYPE__SERVER) with the name srv12345.domain.de
        and the purpose "Production"

        .NOTES
        Version
        0.1.0     29.12.2017  CB  initial release
    #>
        [CmdletBinding()]
        Param (
            [Parameter( Mandatory=$True,
                        Position=0 )]
            [Alias("TypeId")]
            $Type,

            [Parameter( Mandatory=$True )]
            [string]$Title
        )

        DynamicParam {
            $ParamName_Category = "Category"

            # Create the collection of attributes
            $AttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]

            # Create and set the parameters' attributes
            $ParameterAttribute = New-Object System.Management.Automation.ParameterAttribute
            $ParameterAttribute.Mandatory = $false

            # Add the attributes to the attributes collection
            $AttributeCollection.Add($ParameterAttribute)
            # Create the dictionary
            $RuntimeParameterDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
            # Generate and set the ValidateSet
            $arrSet = (Get-IdoItDialog -Category "C__CATG__GLOBAL" -Property "category").title
            $ValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($arrSet)
            # Add the ValidateSet to the attributes collection
            $AttributeCollection.Add($ValidateSetAttribute)
            # Create and return the dynamic parameter
            $RuntimeParameter = New-Object System.Management.Automation.RuntimeDefinedParameter($ParamName_Category, [string], $AttributeCollection)
            $RuntimeParameterDictionary.Add($ParamName_Category, $RuntimeParameter)

            $ParamName_Purpose = "Purpose"
            # Create the collection of attributes
            $AttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
            # Create and set the parameters' attributes
            $ParameterAttribute = New-Object System.Management.Automation.ParameterAttribute
            $ParameterAttribute.Mandatory = $false
            #$ParameterAttribute.Position = 1
            # Add the attributes to the attributes collection
            $AttributeCollection.Add($ParameterAttribute)
            # Generate and set the ValidateSet
            $arrSet = (Get-IdoItDialog -Category "C__CATG__GLOBAL" -Property "purpose").title
            $ValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($arrSet)
            # Add the ValidateSet to the attributes collection
            $AttributeCollection.Add($ValidateSetAttribute)
            # Create and return the dynamic parameter
            $RuntimeParameter = New-Object System.Management.Automation.RuntimeDefinedParameter($ParamName_Purpose, [string], $AttributeCollection)
            $RuntimeParameterDictionary.Add($ParamName_Purpose, $RuntimeParameter)

            Return $RuntimeParameterDictionary
        }

        Begin {
            $Category = $PsBoundParameters[$ParamName_Category]
            $Purpose =  $PsBoundParameters[$ParamName_Purpose]

            If ($Category) {
                $CategoryElementId = (Get-IdoItDialog -Category "C__CATG__GLOBAL" -Property "category" | Where-Object {$_.title -eq $Category }).id
            }

            If ($Purpose) {
                $PurposeElementId = (Get-IdoItDialog -Category "C__CATG__GLOBAL" -Property "purpose" | Where-Object {$_.title -eq $Purpose }).id
            }


        }

        Process {

            $Params = @{}
            $Params.Add("type", $Type)
            $Params.Add("title", $Title)

            If ($Category) {
                $Params.Add("category", $CategoryElementId)
            }

            If ($Purpose) {
                $Params.Add("purpose", $PurposeElementId)
            }
            $ResultObj = Invoke-IdoIt -Method "cmdb.object.create" -Params $Params

            If ($ResultObj.Success -eq $True) {
                $ResultNewObj = Get-IdoItObject -Id $ResultObj.id
                Return $ResultNewObj
            }
            Else {
                Return $ResultObj
            }
        }
    }