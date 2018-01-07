Function Set-IdoItObject {
    <#
        .SYNOPSIS
        Set-IdoItObject

        .DESCRIPTION
        Set-IdoItObject lets you modify an existing objects title .

        .PARAMETER Id
        This parameter either the type id of the object you want to modify.

        .PARAMETER Title
        Defines  the new title for the object you are modifing.

        .EXAMPLE
        PS> Set-IdoItObject -Id 1234 -Title "srv12345.domain.de"

        This will change the title for object 1234 to srv12345.domain.de

        .NOTES
        Version
        0.1.0     29.12.2017  CB  initial release
    #>
        [CmdletBinding( SupportsShouldProcess=$True )]
        Param (
            [Parameter( Mandatory=$True,
                        ValueFromPipelineByPropertyName,
                        Position=0)]
            [Int]$Id,

            [Parameter( Mandatory=$True )]
            [String]$Title
        )

        Process {

            $Params = @{}
            $Params.Add("id", $Id)


            $Params.Add("title", $Title)

            If (Get-IdoItObject -Id $Object) {

                If ($PSCmdlet.ShouldProcess("Updating title for object id $Id to $Title")) {
                    $ResultObj = Invoke-IdoIt -Method "cmdb.object.update" -Params $Params
                }

                If ($ResultObj.success) {
                    Return $ResultObj.message
                }

            }
            Else {
                Write-Error -Message "Could not find object id $Id."
            }
        }

    }