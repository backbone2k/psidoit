Function Find-IdoItObjects {
    <#
        .SYNOPSIS
        With Find-IdoItObjects you can trigger a global search over the i-doit API.

        .DESCRIPTION
        With Find-IdoItObjects you can trigger a global search over the i-doit API.

        .PARAMETER Query
        This parameter defines the query to search for.

        .EXAMPLE
        PS> Find-IdoItObjects -Query "server"

        This command will return all objects that have "server" in their name.

        .NOTES
        Version
        0.1.0     29.12.2017  CB  initial release
    #>
        Param (
            [Parameter(Mandatory = $true, Position=0)]
            [String]$Query
        )

        #TODO Add CheckCmdbConnection again
        #checkCmdbConnection

        $Params  = @{
            "q"      = $Query
        }

        #Create an empty PSObject array to store the results
        $ResultObj = @(New-Object PSObject)
        $ResultObj = Invoke-IdoIt -Method "idoit.search" -Params $Params

        #Thank synetics for being inconsistent about naming properties. We replace documentId to id, value to title
        foreach ($o in $ResultObj) {
            $o | Add-Member -MemberType NoteProperty -Name "id" -Value $o.DocumentId
            $o | Add-Member -MemberType NoteProperty -Name "title" -Value $o.Value
            $o.PSObject.Properties.Remove("documentId")
            $o.PSObject.Properties.Remove("value")
        }

        $ResultObj = $ResultObj | Add-ObjectTypeName -TypeName 'Idoit.Object.SearchResult'
        $ResultObj = $ResultObj | Set-ObjectDefaultPropertySet -DefaultProperties 'Id','Title','Link','Score'

        Return $ResultObj


    }