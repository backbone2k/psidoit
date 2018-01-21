Function Test-IdoItCacheFile {

    <#
   .SYNOPSIS
   This function tests if a cache file exists and/or is valid.

   .DESCRIPTION
   This function tests if a cache file exists and/or is valid. If the file does not exist or the cache duration is not valid anymore
   the function will return $False

   .PARAMETER CacheType
   CacheType defines wich type of cache to be written.

   .PARAMETER Expiry
   Expiry is a TimeSpan that defines how old the cache file is allowed to be

   .EXAMPLE
   PS> Test-IdoItCacheFile -CacheType Constant -Expiry (New-Timespan -Days 30)

   This will test for the Constant cache file and test if the content is not older than 30 days
   If you do not provide Expiry parameter the function will only test if the file exists

   .NOTES
   Version
   0.1.0   20.01.2018 CB  initial release
   #>

   [CmdletBinding ()]
   Param (
       [Parameter (
           Mandatory = $True
       )]
       [ValidateSet('Constant','Config')]
       [String]$CacheType,

       [Parameter (
           Mandatory = $False
       )]
       [Timespan]$Expiry
   )

   Begin {

           $CachePath = $env:LOCALAPPDATA+"\.psidoit"
           $CacheFile = $CachePath + "\$CacheType.json"

   }
   Process {

       Try {

            If ( -Not (Test-Path $CacheFile ) ) {

                Return $False

             }

             If ( $PSBoundParameters.ContainsKey('Expiry') ) {

                $CacheData = Get-Content -Path $CacheFile -Raw | ConvertFrom-Json


                $TimeSpan = New-TimeSpan -Start ([Datetime]::parseexact($CacheData.CreationTime, "o", $Null))
                Write-Verbose "Age of the cache file content is $TimeSpan"

                If ($TimeSpan -gt $Expiry) {
                    Return $False
                }

             }

             Return $True


       }
       Catch [Exeption] {

           Throw $_

       }

   }

}


