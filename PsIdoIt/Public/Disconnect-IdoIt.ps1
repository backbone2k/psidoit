function Disconnect-IdoIt {
    <#
        .SYNOPSIS
        Disconnect-IdoIt destroys the session to idoit and removes all session variables

        .DESCRIPTION
        Disconnect-IdoIt destroys the session to idoit and removes all session variables

        .EXAMPLE
        PS> Disconnect-IdoIt

        This will disconnect from idoit

        .NOTES
        Version
        0.1.0   29.12.2017  CB  initial release
        0.2.0   01.01.2018  CB  added removal of variable CmdbUri from global scope; Added Try/Catch Block
    #>

    $Params = @{}

    #Todo Check if a session is available before destroing
    Try {
        Invoke-IdoIt -Method "idoit.logout" -Params $Params
    }
    Catch {
        Throw
    }

    Remove-Variable -Name CmdbApiKey -Scope Global -Force:$true
    Remove-Variable -Name CmdbSession -Scope Global -Force:$true
    Remove-Variable -Name CmdbUri -Scope Global -Force:$true

}
