Function Test-IdoitHttpSSL {

    Param (
        # Parameter help description
        [Parameter (
            Mandatory = $True,
            Position = 0
        )]
        [String]$Uri
    )

    $RegEx = "^(https)://.*$"

    If ($Uri -match $RegEx) {
        Return $True
    }
    Else {
        Return $False
    }
}