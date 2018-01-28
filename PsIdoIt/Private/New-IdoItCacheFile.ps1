Function New-IdoItCacheFile {

     <#
    .SYNOPSIS
    Creates a new Cache File in the users local app data directory

    .DESCRIPTION
    Creates a new Cache File in the users local app data directory

    .PARAMETER CacheData
    This parameter accepts a PSObject and will convert it into JSON and appends it into the cache file

    .PARAMETER CacheType
    CacheType defines wich type of cache to be written.

    .PARAMETER PassThrough
    Instead of writing the data to the default LOCALUSER location you can get the JSON data back and handle it by your own.

    .EXAMPLE
    PS> New-IdoItCacheFile -CacheType Constant -CacheData (Get-IdoItConstant)

    This will create a new cache for idoit constants

    .NOTES
    Version
    0.1.0   20.01.2018 CB  initial release
    #>

    [CmdletBinding(
        SupportsShouldProcess = $True
    )]
    Param (
        [Parameter (
            Mandatory = $True,
            Position = 0
        )]
        [PSObject]$CacheData,

        [Parameter (
            Mandatory = $True
        )]
        [ValidateSet('Constant','Settings')]
        [String]$CacheType,

        [Switch]$PassThrough
    )

    Begin {
            # $VerbosePreference = Continue
            $CachePath = $env:LOCALAPPDATA+"\.psidoit"
            #$CacheMetaDataFile = $CachePath + "\cachemetadata.json"
            $CacheFile = $CachePath + "\$($CacheType.ToLower()).json"


            $CacheDataObject = [PSCustomObject]@{
                'CreationTime' = (Get-Date -Format o)
                'CacheType' = $CacheType
                'Data' = $CacheData
            }
    }
    Process {
    # More work needed :-)
        Try {

            If ( -Not $PassThrough ) {
                If ( -Not (Test-Path $CachePath ) ) {

                    New-Item -ItemType Directory -Path $CachePath

                }

                Write-Verbose "Creating idoit cache file"
                ConvertTo-Json -InputObject $CacheDataObject -Depth 4 | Out-File -FilePath ($CacheFile) -Encoding default -Force:$True
            }
            Else {

                Return ConvertTo-Json -InputObject $CacheDataObject -Depth 4

            }

        }
        Catch [Exeption] {

            Throw $_

        }

    }

}




            #Create a cache meta file to store cache age and some other stuff into it
            #Write-Verbose "Checking if cache metadata file exists"
            #If ( Test-Path -Path $CacheMetaDataFile ) {

             #   Write-Verbose "Found existing metadata file. Loading content"
             #   $CacheMetaData = Get-Content $CacheMetaDataFile -Encoding Default -Raw | ConvertFrom-Json
             #   $MaxCacheAge = New-TimeSpan -Days 1
             #   $TimeSpan = New-TimeSpan -Start ([Datetime]::parseexact($CacheMetaData.Created, "o", $Null))

             #   If ($TimeSpan -gt $MaxCacheAge) {

             #       Write-Verbose "Cache MaxAge reached - forcing rebuild of the cache"
             #       $ValidCache = $False

             #   } Else {

             #       Write-Verbose "Cache MaxAge not reached - skipping rebuild of cache"
             #       $ValidCache = $True

             #   }

            #}
            #ElseIf ( (-Not $ValidCache ) -or ( -Not (Test-Path -Path $CacheMetaDataFile) ) ) {

   #             $CacheMetaData = @{
    #                Created = (Get-Date -Format o)
     #           }

      #          ConvertTo-Json -InputObject $CacheMetaData -Depth 2 | Out-File -FilePath $CacheMetaDataFile -Encoding default -Force:$True
    #
     #       }

      #      If ( ( -not $ValidCache ) -or ( $ForceCacheRebuild ) -or (-Not (Test-Path -Path $CacheConstantFile)) ) {