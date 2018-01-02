function Invoke-IdoIt {
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

        .EXAMPLE
        PS> Invoke-IdoIt -Method "cmdb.location_tree.read" -Params @{"id"=1234}

        This will invoke the metho cmdb.location_tree.read for the object 1234

        .NOTES
        Version
        0.1.0   29.12.2017  CB  initial release
        0.2.0   31.12.2017  CB  redesign of the function to be more generic
    #>
        [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidGlobalVars", "")]
        param (
            [Parameter(Mandatory=$true)]
            [ValidateNotNullOrEmpty()]
            [String]$Method,

            [Parameter(Mandatory=$true)]
            [ValidateNotNull()]
            [Hashtable]$Params,

            [Parameter(Mandatory=$false)]
            [Hashtable]$Headers,

            [Parameter(Mandatory=$false)]
            [String]$Uri
        )

        $RequestID = [Guid]::NewGuid()

        $RequestBody = @{
            "method" = $Method
            "version" = "2.0"
            "id" = $requestID
            "params" = $Params
        }

        #Add the API Key to the params if it is not already defined
        if (!$RequestBody.params.ContainsKey("ApiKey")) {
            $RequestBody.params.Add("apikey", $Global:cmdbApiKey)
        }
        if (!$RequestBody.params.ContainsKey("Uri")) {
            if ($Global:CmdbUri.Length -gt 0) {
                $Uri = $Global:cmdbUri
            }
        }

        $RequestBody = ConvertTo-Json -InputObject $RequestBody -Depth 4

        if (!$PSBoundParameters.ContainsKey("Headers")) {
            $Headers = @{"Content-Type" = "application/json"; "X-RPC-Auth-Session" = $global:cmdbSession}
        }


        #define higher tls version - otherwise tls1.0 will fail on more secure web sockets
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

        try {
            $InvokeResult = Invoke-WebRequest -Uri $Uri -Method Post -Body $RequestBody -Headers $Headers
        }

        catch {
            Throw
        }

        if ($InvokeResult.StatusCode -eq 200) {

            #i-doit puts numbers in the JSON response in quotes :-( - This is breaking type conversion into integer when calling ConvertFrom-Json
            #Before converting the JSON to an PSObject we remove quotes from numbers with this little magic regex!

            $Regex = '(?m)"([0-9]+)"'
            #The regex is matching numbers between "" - (?m) defines multiple occurance

            $TempJson = $InvokeResult.content -replace $Regex, '$1'

            $ContentJson = ConvertFrom-Json $TempJson

            #Check for error object
            if ($ContentJson.PSObject.Properties.Name -Contains 'Error') {
                Throw "Error code $($ContentJson.Error.Code) - $($ContentJson.error.data.error)"

            }

            else {

                #We check that we get back our requestId. This ensures that the send JSON request could be read by the service
                if ($ContentJson.id -ne $RequestID) {
                    Throw "Request id mismatch. Expected value was $RequestID but it is $($ContentJson.id)"
                }

                #Return only the result part of the response
                $ContentJson.result

            }



        }

    }