Function Invoke-IdoIt {
    <#
    .SYNOPSIS
    Invoke-IdoIt

    .DESCRIPTION
    The Invoke-IdoIt Cmdlet will call the i-doit RPC API endpoint with the provieded query parameters and will return a WebRequest result.
    The result of the web request is validated and if everything looks ok the cmdlet returns the property <result>.

    The result is already converted from an JSON string into an PSObject. The NoteProperties that are returned depend on the provided method
    for the idoit request.

    .PARAMETER Method
    This parameter the method yout want to call at the RPC endpoint. The different methods are descriped in the idoit api documentation.

    If you define the "idoit.login" method you must provide the following headers:

    X-RPC-Auth-Username = <Username>
    X-RPC-Auth-Password = <Password>
    Content-Type = "application/json"

    .PARAMETER Params
    This is a hashtable objects with all method specific parameters to pass to the RPC endpoint. The different value/key pairs are described in the
    idoit api reference.

    Beside the values you pass to this parameter Invoke-IdoIt will always add some static ones like
    - ApiKey
    - Request id
    - Version

    ApiKey is read from a global variable.

    .PARAMETER Headers
    This is an optional parameter to pass specific header fields in the POST request. This parameter is optional and only needed if you call the
    idoit.login.

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

    $RequestId = New-IdoItRequestId

    $RequestBody = @{
        "method" = $Method
        "version" = "2.0"
        "id" = $RequestId
        "params" = $Params
    }

    #Add the API Key to the params if it is not already defined
    If (!$RequestBody.Params.ContainsKey("ApiKey")) {

        $RequestBody.Params.Add("apikey", $Global:cmdbApiKey)

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

    Write-Verbose "Request headers: $($Headers | Out-String)"

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

        Write-Verbose "Request status code 200 returned"
        #i-doit puts numbers in the JSON response in quotes :-( - This is breaking type conversion into integer when calling ConvertFrom-Json
        #Before converting the JSON to an PSObject we remove quotes from numbers with this little magic regex!

        $ContentJson = $InvokeResult.Content | ConvertFrom-IdoItJsonResponse | ConvertFrom-Json

        Write-Verbose "Response: $ContentJson"
        Write-Verbose "Response: $($ContentJson.Result)"
        #$TempJson = $InvokeResult.content -replace $Regex, '$1'

        #$ContentJson = ConvertFrom-Json $TempJson

        #Check for error object
        Write-Verbose "Checking if response contains error object"

        If ($ContentJson.PSObject.Properties.Name -Contains 'Error') {

            Throw "Error code $($ContentJson.Error.Code) - $($ContentJson.error.data.error)"

        }

        Else {

            Write-Verbose "Checking if the response id matches the request id"

            #We check that we get back our requestId. This ensures that the send JSON request could be read by the service
            If ( -Not (Compare-IdoItRequestId -RequestId $RequestId -ResponseId $ContentJson.id)) {
            #If ($ContentJson.id -ne $RequestID) {

                Throw "Request id mismatch. Expected value was $RequestID but it is $($ContentJson.id)"

            }

            #Return only the result part of the response
            $ContentJson.result

        }



    }
    Else {
        Return "Error"
    }

}