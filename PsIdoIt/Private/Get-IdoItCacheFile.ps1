Function Get-IdoItCacheFile {

    <#
   .SYNOPSIS
   Gets the content of a cache file in the users local app data directory

   .DESCRIPTION
   Gets the content of a cache file in the users local app data directory

   .PARAMETER CacheType
   CacheType defines wich type of cache to be written.

   .EXAMPLE
   PS> Gew-IdoItCacheFile -CacheType Constant

   This will the cache for idoit constants

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
       [String]$CacheType
   )

   Begin {
           # $VerbosePreference = Continue
           $CachePath = $env:LOCALAPPDATA+"\.psidoit"
           $CacheFile = $CachePath + "\$CacheType.json"
           #CacheFile = $CachePath + "\Constant.json"


   }

   Process {
   # More work needed :-)
       Try {


        If ( (Test-Path $CacheFile ) ) {

            Return (Get-Content -Path $CacheFile -Raw -Encoding Default | ConvertFrom-Json).Data.Value

        }


       }
       Catch [Exeption] {

           Throw $_

       }

   }

}
