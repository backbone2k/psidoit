function Get-IdoItObject {
    <#
    .SYNOPSIS
    Gets an object from the idoit cmdb and returns it as Idoit.Object object

    .DESCRIPTION
    This cmdlet will return an idoit cmbd object for a provided id. The id can be get by find-idoitobject or by inspecting the idoit url when
    using the web interface.

    Typically you will have an url like https://demo.i-doit.com/?objID=3569
    The objID parameter contains the id.

    So if you want to get the object from the above url with the Get-IdoItObject cmdlet you have to type in:
        Get-IdoitObject -Id 3569

    .PARAMETER Id
    This is the unique id of the object you want to get pulled from the idoit cmdb.

    .PARAMETER RawOutput
    You can provide a [Ref] parameter to the function to get back the raw response from the invoke to the I-doIt API.

    You have to put the parameter in parantheses like this:
    -RawOutput ([Ref]$Output)

    The return value is [Microsoft.PowerShell.Commands.HtmlWebResponseObject

    .INPUTS
    System.Int32

    You can pipe an integer that contains the id of the cmdb object.

    .OUTPUTS
    System.Object

    The cmdlet returns a System.Object with the custom type name Idoit.Object.

    .EXAMPLE
    PS> Get-IdoItObject -Id 1234

    This will get the object with the id <1234>

    .NOTES
    Version
    0.1.0   29.12.2017  CB  initial release
    0.2.0   05.01.2018  CB  Added support for RawOuput; Improved inline help
    0.2.1   07.01.2018  CB Added Try/Catch block around Invoke-IdoIt
    #>
        Param (
            [Parameter (
                Mandatory = $True
            )]
            [Int]$Id,

            [Parameter (
                Mandatory = $False
            )]
            [Ref]$RawOutput
        )

        #TODO Add CheckCmdbConnection again
        #checkCmdbConnection

        $Params  = @{
            "id"     = $Id
        }

        $SplattingParameter = @{
            Method = "cmdb.object.read"
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


        $ResultObj = $ResultObj | ConvertFrom-IdoItResultObject
        $ResultObj = $ResultObj | Add-ObjectTypeName -TypeName 'Idoit.Object'
        $ResultObj = $ResultObj | Add-ObjectDefaultPropertySet -DefaultProperties 'Id', 'SysId', 'Title', 'TypeTitle'

        Return $ResultObj

    }