Function Add-ObjectTypeName {
<#
    .SYNOPSIS
        Decorate an object with a TypeName
    .DESCRIPTION
        Helper function to decorate an object with a TypeName

    .PARAMETER InputObject
        Object to decorate. Accepts pipeline input.

    .PARAMETER TypeName
        Typename to insert.

        This will show up when you use Get-Member against the resulting object.

    .PARAMETER Passthru
        Whether to pass the resulting object on. Defaults to true

    .EXAMPLE
        #
        # Create an object to work with
        $Object = [PSCustomObject]@{
            First = 'Cookie'
            Last = 'Monster'
            Account = 'CMonster'
        }
        #Add a type name
        Add-ObjectTypeName -InputObject $Object -TypeName 'ApplicationX.Account'

            # First  Last    Account
            # -----  ----    -------
            # Cookie Monster CMonster

        #Verify that get-member shows us the right type
        $Object | Get-Member
            # TypeName: ApplicationX.Account ...

    .NOTES
        Initial code borrowed from Warren Frame:
        https://github.com/RamblingCookieMonster

    .LINK
        http://ramblingcookiemonster.github.io/Decorating-Objects/

    .FUNCTIONALITY
        PowerShell Language
    #>

    [CmdletBinding()]
    Param (
        [Parameter( Mandatory=$True,
                    Position=0,
                    ValueFromPipeline=$True )]
        [ValidateNotNullOrEmpty()]
        [PsObject[]]$InputObject,

        [Parameter( Mandatory=$True,
                    Position=1)]
        [String]$TypeName,

        [Boolean]$Passthru = $True
    )

    Process {
        ForEach ($Object in $InputObject) {
            [Void]$Object.PsObject.TypeNames.Insert(0,$TypeName)
        }

        If ($Passthru) {
            $Object
        }
    }
}