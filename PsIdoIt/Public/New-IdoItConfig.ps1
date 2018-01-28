Function New-IdoItConfig {
    [CmdletBinding(
        DefaultParameterSetName = 'Wizard'
    )]
    Param (
        [Parameter (
            Mandatory = $True,
            ParameterSetName = "Credentials"
        )]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential,

        [Parameter (
            Mandatory = $True,
            ParameterSetName = "Credentials"
        )]
        [String]$ApiKey,

        [Parameter (
            Mandatory = $True,
            ParameterSetName = "Credentials"
        )]
        [String]$Uri,

        [Parameter (
            Mandatory = $True,
            ParameterSetName = "Settings"
        )]
        [ValidateScript ({
            $RequiredKeys= @("Username","Password","ApiKey","Uri")
            $ProvidedKeys = @($_.Keys)
            -Not @($RequiredKeys| Where-Object {$ProvidedKeys -notcontains $_}).Count
        })]
        [Hashtable]$Settings,

        [Parameter (
            Mandatory = $False,
            ParameterSetName = "Settings"
        )]
        [Parameter (
            Mandatory = $False,
            ParameterSetName = "Credentials"
        )]
        [String]$FilePath



    )

    # When –Debug is used, we will not get a prompt each time it is used :-) Thanks to Boe Prox
    # https://learn-powershell.net/2014/06/01/prevent-write-debug-from-bugging-you/
    If ($PSBoundParameters['Debug']) {
        $DebugPreference = 'Continue'
    }

    If ($PSCmdlet.ParameterSetName -ne "Wizard") {

        If ($PSCmdlet.ParameterSetName -eq "Credentials") {
            $SettingsParams = @{
                Username = $Credential.Username
                Password = $Credential.Password | ConvertFrom-SecureString
                ApiKey = $ApiKey
                Uri = $Uri
            }

        }

        Else {
            $SettingsParams = $Settings
        }

        If ($PSBoundParameters.ContainsKey('FilePath')) {

            Try {

                $SettingsJson = New-IdoitCacheFile -CacheType Settings -CacheData $SettingsParams -PassThrough
                If ( -not (Test-Path $FilePath) ) {

                    Out-File -InputObject $SettingsJson -FilePath $FilePath -Encoding default

                }
                Else {

                    Throw (New-Object -TypeName System.IO.IOException -ArgumentList "File already exists" )

                }

            }
            Catch {

                $PSCmdlet.ThrowTerminatingError($PSitem)

            }


        }
        Else {

            New-IdoitCacheFile -CacheType Settings -CacheData $SettingsParams

        }

    }
    Else {
        Write-Host "Wizard not yet implemented"
    }
}