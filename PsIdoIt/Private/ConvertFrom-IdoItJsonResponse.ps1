Function ConvertFrom-IdoItJsonResponse {

    [CmdletBinding()]
    Param (
        [Parameter (
            Mandatory = $True,
            ValueFromPipeline = $True,
            Position = 0
        )]
        [String]$InputString
    )

    Write-Verbose "Removing quotes from integer numbers in $InputString"
    $Regex = '(?m)"([0-9]+)"'
    #The regex is matching numbers between "" - (?m) defines multiple occurance
    $OutputString = $InputString -replace $Regex, '$1'

    Return $OutputString
}