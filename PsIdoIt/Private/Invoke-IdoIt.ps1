Function Invoke-IdoIt {
    <#
    .SYNOPSIS
    Invoke-IdoIt

    .DESCRIPTION
    The Invoke-IdoIt Cmdlet will call the i-doit RPC API endpoint with the provieded query parameters.

    .PARAMETER Method
    This parameter the Method we wan't to call at the RPC endpoint

    .PARAMETER Params
    This is a hashtable with all method specific parameters to pass to the RPC endpoint

    .PARAMETER Headers
    This is an optional parameter to pass specific header fields in the POST request

    .PARAMETER Uri
    The Uri parameter can be used to set the connection URI. If this optional parameter is not provided Invoke-IdoIt
    is looking in the $global:CmdbUri varibale.

    .PARAMETER RawOutput
    You can provide a [Ref] parameter to the function to get back the raw response from the invoke to the I-doIt API.

    You have to put the parameter in parantheses like this:
    -RawOutput ([Ref]$Output)

    The return value is a Microsoft.PowerShell.Commands.HtmlWebResponseObject

    .EXAMPLE
    PS> Invoke-IdoIt -Method "cmdb.location_tree.read" -Params @{"id"=1234}

    This will invoke the metho cmdb.location_tree.read for the object 1234

    .NOTES
    Version
    0.1.0   29.12.2017  CB  initial release
    0.2.0   31.12.2017  CB  redesign of the function to be more generic
    0.2.1   03.01.2018  CB  Added CmdletBinding and Verbose/Debug output; Added Ref Parameter RawOutput
    #>

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidGlobalVars", "")]
    [CmdletBinding()]
    Param (
        [Parameter( Mandatory = $True )]
        [ValidateNotNullOrEmpty()]
        [String]$Method,

        [Parameter( Mandatory = $True )]
        [ValidateNotNull()]
        [Hashtable]$Params,

        [Parameter( Mandatory = $False )]
        [Hashtable]$Headers,

        [Parameter( Mandatory = $False )]
        [String]$Uri,

        [Parameter( Mandatory = $False )]
        [Ref]$RawOutput
    )

    $RequestId = [Guid]::NewGuid()
    Write-Verbose "Request id: $RequestId"

    $RequestBody = @{
        "method" = $Method
        "version" = "2.0"
        "id" = $RequestId
        "params" = $Params
    }

    #Add the API Key to the params if it is not already defined
    If (!$RequestBody.params.ContainsKey("ApiKey")) {
        $RequestBody.params.Add("apikey", $Global:cmdbApiKey)
    }

    If (!$RequestBody.params.ContainsKey("Uri")) {
        If ($Global:CmdbUri.Length -gt 0) {
            $Uri = $Global:cmdbUri
        }
    }

    $RequestBody = ConvertTo-Json -InputObject $RequestBody -Depth 4

    Write-Verbose "Request body: $RequestBody"

    If (!$PSBoundParameters.ContainsKey("Headers")) {
        $Headers = @{"Content-Type" = "application/json"; "X-RPC-Auth-Session" = $global:cmdbSession}
    }

    Write-Verbose "Request headers: $Headers"

    #define higher tls version - otherwise tls1.0 will fail on more secure web sockets
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

    Try {

        Write-Verbose "Trying to innvoke WebRequest to I-doIt"
        $InvokeResult = Invoke-WebRequest -Uri $Uri -Method Post -Body $RequestBody -Headers $Headers

    }
    Catch {

        Throw $_

    }

    If ($PSBoundParameters.ContainsKey("RawOutput")) {
        Write-Verbose "RawOuput parameter provided. Saving raw data to ref variable"
        $RawOutput.Value = $InvokeResult
    }

    If ($InvokeResult.StatusCode -eq 200) {

        Write-Verbose "Request status code 200 returnd"
        #i-doit puts numbers in the JSON response in quotes :-( - This is breaking type conversion into integer when calling ConvertFrom-Json
        #Before converting the JSON to an PSObject we remove quotes from numbers with this little magic regex!

        $Regex = '(?m)"([0-9]+)"'
        #The regex is matching numbers between "" - (?m) defines multiple occurance

        $TempJson = $InvokeResult.content -replace $Regex, '$1'

        $ContentJson = ConvertFrom-Json $TempJson

        #Check for error object
        Write-Verbose "Checking if response contains error object"

        If ($ContentJson.PSObject.Properties.Name -Contains 'Error') {

            Throw "Error code $($ContentJson.Error.Code) - $($ContentJson.error.data.error)"

        }

        Else {

            Write-Verbose "Checking if the response id matches the request id"

            #We check that we get back our requestId. This ensures that the send JSON request could be read by the service
            If ($ContentJson.id -ne $RequestID) {

                Throw "Request id mismatch. Expected value was $RequestID but it is $($ContentJson.id)"

            }

            #Return only the result part of the response
            $ContentJson.result

        }



    }

}