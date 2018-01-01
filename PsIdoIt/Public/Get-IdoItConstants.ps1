Function Get-IdoItConstants {
    <#
        .SYNOPSIS
        Get-IdoItConstants

        .DESCRIPTION
        Get-IdoItConstants lets you retreive all available Constants in i-doit

        .NOTES
        Version
        0.1.0     30.12.2017  CB  initial release
    #>
        $Params = @{}

        $ResultObj = Invoke-IdoIt -Method "idoit.constants" -Params $Params

        #The result of this method is quite strange. Converting it back from json will result in 3 PSObjects
        #with each of them contains a Noteproperty. So we will create a new CustomObj with properties type, const and title
        #and merge everything into this. So all the cool PowerShell features for filtering and piping are possible

        #First we create a template Object with the properties we need...
        $TemplateObj = [PSCustomObject]@{
            "type" = $Null
            "const" = $Null
            "title" = $Null
        }

        #This is our final object where we will populate all values
        $CustomObj = @()

        #First we start with the objecttypes
        $TempType = $ResultObj.objectTypes

        Foreach ($O In $TempType.PSObject.Properties) {
            $TempObj = $TemplateObj | Select-Object *

            $TempObj.Type = "Object"
            $TempObj.Const = $O.Name
            $TempObj.Title = $O.Value

            $CustomObj += $TempObj
        }

        #then the global categories
        $TempType = $ResultObj.Categories.G

        Foreach ($O In $TempType.PSObject.Properties) {
            $TempObj = $TemplateObj | Select-Object *

            $TempObj.Type = "Global"
            $TempObj.Const = $O.name
            $TempObj.Title = $O.value

            $CustomObj += $TempObj
        }

         #and finally the specific categories
        $tempType = $ResultObj.Categories.S

        Foreach ($O In $TempType.PSObject.Properties) {
            $TempObj = $TemplateObj | Select-Object *

            $TempObj.Type = "Specific"
            $TempObj.Const = $O.Name
            $TempObj.Title = $O.Value

            $CustomObj += $TempObj
        }

        $CustomObj = $CustomObj | Add-ObjectTypeName -TypeName 'Idoit.Constant'

        Return $CustomObj

    }