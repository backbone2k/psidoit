Function Remove-IdoItObject {
    <#
        .SYNOPSIS
        Remove-IdoItObject

        .DESCRIPTION
        With Remove-IdoItObject you can archive, delete or purge a object from i-doit

        .PARAMETER Id
        The id of the object you want to remove

        .PARAMETER Archive
        When this switch is provided, the object is archived

        .PARAMETER Delete
        When this switch is provided, the object is deleted

        .PARAMETER Purge
        When this switch is provided, the object is purged

        .PARAMETER Quicpurge
        When this switch is provided, the object is going through all states and is purged at the end.

        .EXAMPLE
        PS> Remove-IdoItObject -Id 1234 -Archive

        This will archive the object with the id 1234

        .NOTES
        Version
        0.1.0     29.12.2017  CB  initial release
    #>
        [cmdletbinding(SupportsShouldProcess, ConfirmImpact='High')]
        Param (
            [Parameter(Mandatory=$true, ValueFromPipeline, Position=0, ParameterSetName="Default")]
            [Parameter(Mandatory=$true, ValueFromPipeline, Position=0, ParameterSetName="Archive")]
            [Parameter(Mandatory=$true, ValueFromPipeline, Position=0, ParameterSetName="Delete")]
            [Parameter(Mandatory=$true, ValueFromPipeline, Position=0, ParameterSetName="Purge")]
            [Parameter(Mandatory=$true, ValueFromPipeline, Position=0, ParameterSetName="Quickpurge")]
            [Int[]]$Id,

            [Parameter(Mandatory=$true, ParameterSetName="Archive")]
            [Switch]$Archive,

            [Parameter(Mandatory=$true, ParameterSetName="Delete")]
            [Switch]$Delete,

            [Parameter(Mandatory=$true, ParameterSetName="Purge")]
            [Switch]$Purge,

            [Parameter(Mandatory=$true, ParameterSetName="Quickpurge")]
            [Switch]$Quickpurge
        )
        Begin {
            $ConstStatus = @{
                "Archive" = "C__RECORD_STATUS__ARCHIVED"
                "Delete" = "C__RECORD_STATUS__DELETED"
                "Purge" = "C__RECORD_STATUS__PURGE"
            }

        }
        Process {

            ForEach ($Object in $Id) {
                $Params = @{}
                $Params.Add("id", $Object)
                If ($PSCmdlet.ParameterSetName -eq "Default") {
                    $Action = "Archive"
                }
                Else {
                    $Action = $PSCmdlet.ParameterSetName
                }

                If ($Action -eq "Quickpurge") {
                    $Method = "cmdb.object.quickpurge"
                }
                Else {
                    $Method = "cmdb.object.delete"
                    switch ($Action) {
                        "Archive" { $Params.Add("status", $ConstStatus.Archive); break}
                        "Delete" { $Params.Add("status", $ConstStatus.Delete); break}
                        "Purge" { $Params.Add("status", $ConstStatus.Purge); break}
                    }
                }

                #Check if the object we want to modify exists. If not we get a nasty SQL error back from idoit
                If (Get-IdoItObject -Id $Object) {

                    If ($PSCmdlet.ShouldProcess("Action: $Action object $Object")) {
                        $ResultObj = Invoke-IdoIt -Method $Method -Params $Params

                        Return $ResultObj
                    }

                }
                Else {
                    Write-Error -Message "Could not find object id $Object. Skipping action $($Action.ToLower())"
                }
            }
        }
    }