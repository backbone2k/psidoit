Function ConvertTo-IdoItSQLWildcard {
    <#
        .SYNOPSIS
        Converts a input string to valid SQL STRING

        .DESCRIPTION
        The function converts an input string to a SQL output string. It escapes SQL wildcard charactes
            - %
            - _

        and converts the  PowerShell wildcard characters * and ? to an corepsonding I-Doit SQL Syntax.
        You can escape the PowerShell wildcards with '\' to search for * and ? instead of asuming this is
        an wildcard.


        .PARAMETER InputString
        This is the input string where the function replaces all the characters

        .EXAMPLE
        PS> ConvertTo-IdoItSQLWildcard -InputString 'SRV*'

        This command will pass the String SRV* to the function and will return an SQL representation of the * wildcard.
        The return value is 'SRV%'

        .INPUTS
        System.String

        .OUTPUTS
        System.String

        .NOTES
        Version
        0.1.0   10.01.2018  CB  initial release

    #>
    [CmdletBinding()]
    Param (
        [Parameter (
            Mandatory = $True,
            ValueFromPipeline = $True,
            Position = 0
        )]
        [String]$InputString
    )

    $RegExEscapePercent = "(?<!\\)%"
    $RegExEscapeUnderline = "(?<!\\)_"
    $RegExReplaceAsterisk = "(?<!\\)\*"
    $RegExReplaceEscapedAsterisk = "\\\*"
    $RegExReplaceQuestionmark = "(?<!\\)\?"
    $RegExReplaceEscapedQuestionmark = "\\\?"

    $Result = $InputString -replace $RegExEscapePercent, "\%"
    $Result = $Result -replace $RegExEscapeUnderline, "\_"
    $Result = $Result -replace $RegExReplaceAsterisk, '%'
    $Result = $Result -replace $RegExReplaceQuestionmark, '_'
    $Result = $Result -replace $RegExReplaceEscapedAsterisk, '*'
    $Result = $Result -replace $RegExReplaceEscapedQuestionmark, '?'

    Return $Result
}