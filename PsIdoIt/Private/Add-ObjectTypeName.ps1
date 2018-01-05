Function Add-ObjectTypeName {
<#
    .SYNOPSIS
        Decorates a custom object with a custom type name
    .DESCRIPTION
        Helper function to decorate a custom object with a type name to apply things like formats to it.

        It is a good idea to provide a type name to some of your object to apply custom formatting or result tests to them.

    .PARAMETER InputObject
        Object to decorate with a custom type name. This paramter also accepts pipeline input.

    .PARAMETER TypeName
        This is the type name yout want to insert into your custom object
        This will show up when you use Get-Member against the resulting object.

    .PARAMETER Passthru
        Whether to pass the resulting object through. The default value is $true.

    .EXAMPLE
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

        #Verify that Get-Member shows us the right type
        $Object | Get-Member
            # TypeName: ApplicationX.Account ...

    .NOTES
        Initial code borrowed from Warren Frame - thanks for the great work!
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