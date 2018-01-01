Function Set-ObjectDefaultPropertySet {
    [CmdletBinding()]
    Param (
        [Parameter( Mandatory=$True,
                    Position=0,
                    ValueFromPipeline=$True )]
        [ValidateNotNullOrEmpty()]
        [PsObject[]]$InputObject,

        [Parameter( Mandatory=$True,
                    Position=3)]
        [ValidateNotNullOrEmpty()]
        [Alias('dp')]
        [System.String[]]$DefaultProperties,

        [Boolean]$Passthru = $True
    )

    Begin
    {
         # define a subset of properties
        $Ddps = New-Object System.Management.Automation.PSPropertySet DefaultDisplayPropertySet,$DefaultProperties
        $PSStandardMembers = [System.Management.Automation.PSMemberInfo[]]$Ddps

    }

    Process {
        ForEach ($Object in $InputObject) {
            # Attach default display property set
            Add-Member -InputObject $Object -MemberType MemberSet -Name PSStandardMembers -Value $PSStandardMembers
        }

        If ($Passthru) {
            $Object
        }

    }
}