Function Test-IdoItHasTypeName {

    [CmdletBinding()]
    Param (
        [Parameter (
            Mandatory = $True,
            ValueFromPipeline = $True,
            Position = 0
        )]
        [System.Object]$Object,

        [Parameter (
            Mandatory = $True,
            Position = 1
        )]
        [String]$TypeName
    )

    Process  {

        If ( (Get-Member -InputObject $Object).TypeName -eq $TypeName) {

            Return $True

        }
        Else {

            Return $False

        }


    }
}