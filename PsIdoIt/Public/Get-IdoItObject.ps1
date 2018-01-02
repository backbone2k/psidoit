function Get-IdoItObject {
    <#
        .SYNOPSIS
        Get-IdoItObject

        .DESCRIPTION
        Get-IdoItObject lets you retreive an an object.

        .PARAMETER Id
        The id of the object you want to get back

        .EXAMPLE
        PS> Get-IdoItObject -Id 1234

        This will get the object 1234

        .NOTES
        Version
        0.1.0     29.12.2017  CB  initial release
    #>
        param (
            [Parameter(Mandatory = $true)]
            [int]$Id
        )

        #TODO Add CheckCmdbConnection again
        #checkCmdbConnection

        $Params  = @{
            "id"     = $Id
        }

        $ResultObj = Invoke-IdoIt -Method "cmdb.object.read" -Params $Params

        $ResultObj = $ResultObj | Add-ObjectTypeName -TypeName 'Idoit.Object'
        $ResultObj = $ResultObj | Add-ObjectDefaultPropertySet -DefaultProperties 'Id', 'SysId', 'Title', 'Type_Title'

        Return $ResultObj

    }