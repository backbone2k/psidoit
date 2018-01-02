function Connect-IdoIt {
<#
    .SYNOPSIS
    Connect-Cmdb initalize the session to the idoit cmdb.

    .DESCRIPTION
    Connect-Cmdb initalize the session to the idoit cmdb.

    .PARAMETER Username
    User with appropiate permissions to access the cmdb.

    .PARAMETER Password
    The password for the user to access the cmdb.

    .PARAMETER ApiKey
    This is the apikey you define in idoit unter Settings-> Interface-> JSON-RPC API to access the api

    .PARAMETER Uri
    This is the Uri to the idoit JSON-RPC API. It is always in the format http[s]://your.i-doit.host/src/jsonrpc.php

    .PARAMETER Settings
    This parameter will be removed - for hashtable you can use paramter splatting

    .PARAMETER ConfigFile
    You can provide a path to a settings file in json format. It must containt username, password, apikey and
    uri as key-value pairs

    .EXAMPLE
    PS> Connect-Cmdb -Username 'admin' -Password 'admin' -Uri 'https://demo.i-doit.com/src/jsonrpc.php' -ApiKey 'asdaur'

    This will esatblish a session to demo.i-doit.com with api key asdaur for user admin

    .NOTES
    Version
    0.1.0   29.12.2017  CB  initial release
    0.2.0   31.12.2017  CB  some major redesign for the parameter sets
    0.3.0   02.01.2018  CB  Using Credential object instead of username & password (https://github.com/PowerShell/PSScriptAnalyzer/issues/363)
#>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidGlobalVars", "")]
    [Cmdletbinding()]

    Param(
        [Parameter( Mandatory=$True, ParameterSetName="SetA" )]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential,

        [Parameter(Mandatory=$true, ParameterSetName="SetA", Position=3)]
        [string]$ApiKey,

        [Parameter(Mandatory=$true, ParameterSetName="SetA", Position=4)]
        [string]$Uri,

        [Parameter(Mandatory=$true, ParameterSetName="SetB", Position=0)]
        [ValidateScript({
            $RequiredKeys= @("Username","Password","ApiKey","Uri")
            $ProvidedKeys = @($_.Keys)
            -not @($RequiredKeys| Where-Object {$ProvidedKeys -notcontains $_}).Count
        })]
        [Hashtable]$Settings,

        [Parameter(Mandatory=$true, ParameterSetName="SetC", Position=0)]
        [ValidateNotNullOrEmpty()]
        [String]$ConfigFile


    )

    #TODO Enforce https and provide a switch parameter to allow http only (unsecure!)

    if ($PSCmdlet.ParameterSetName -eq "SetA") {
        $SettingsParams = @{
            Username = $Credential.Username
            Password = $Credential.GetNetworkCredential().Password #$Credential.Password
            ApiKey = $ApiKey
            Uri = $Uri
        }

    } ElseIf ($PSCmdlet.ParameterSetName -eq "SetC") {
        $SettingsParams = Get-Content $ConfigFile -Raw | ConvertFrom-Json
        $SecurePassword = ConvertTo-SecureString $SettingsParams.Password
        $Credential = New-Object System.Management.Automation.PSCredential -ArgumentList $SettingsParams.Username, $SecurePassword

        $SettingsParams.Password = $Credential.GetNetworkCredential().Password

    }

    Else {
        $SettingsParams = $Settings
    }

    New-Variable -Name CmdbApiKey -Scope Global -Value $SettingsParams.ApiKey -Force:$True
    New-Variable -Name CmdbUri -Scope Global -Value $SettingsParams.Uri -Force:$True


    $Params = @{}
    $Headers = @{"Content-Type" = "application/json"; "X-RPC-Auth-Username" = $SettingsParams.Username; "X-RPC-Auth-Password" = $SettingsParams.Password}

    $ResultObj = Invoke-IdoIt -Method "idoit.login" -Params $Params -Headers $Headers -Uri $SettingsParams.Uri

    $LoginResult = [pscustomobject]@{
        Account  = $ResultObj.name
        Tenant   = $ResultObj.'client-name'
        TenantId = $ResultObj.'client-id'
    }

    New-Variable -Name CmdbSession -Scope Global -Value $ResultObj.'session-id' -Force:$True

    #Before we begin, we check that we are running against correct version. Also we know that everything
    #is working.
    $CmdbVer = [Version](Get-IdoItVersion).Version
    If (!$CmdbVer) {
        Throw "There was an unkown problem getting the i-doit version."
    }
    Elseif (($CmdbVer.Major -lt 1) -or ($CmdbVer.Minor -lt 7)) {
        Throw "PSCmdb needs minimum Version 1.7 to work. You are running i-doit $($CmdbVer.Major).$($CmdbVer.Minor)"
    }

    Return $LoginResult
}

#Connect-IdoIt -ConfigFile ..\settings.json
