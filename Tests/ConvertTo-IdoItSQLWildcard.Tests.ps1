if(-not $ENV:BHProjectPath)
{
    Set-BuildEnvironment -Path $PSScriptRoot\.. -Force
}
Remove-Module $ENV:BHProjectName -ErrorAction SilentlyContinue
Import-Module (Join-Path $ENV:BHProjectPath $ENV:BHProjectName) -Force



InModuleScope $ENV:BHProjectName {
    $PSVersion = $PSVersionTable.PSVersion.Major
    #$ProjectRoot = $ENV:BHProjectPath

    $Verbose = @{}

    If ($ENV:BHBranchName -notlike "master" -or $env:BHCommitMessage -match "!verbose") {

        $Verbose.Add("Verbose", $True)

    }

    Describe -Name "ConvertTo-IdoItSQLWildcard PS$PSVersion" {

        It -Name 'Escape SQL wildcard characters' {
            $Output = ConvertTo-IdoItSQLWildcard -InputString 'Some % SQ_ wildcard test \_ \%'
            $Output | Should Be 'Some \% SQ\_ wildcard test \_ \%'
        }

        It -Name 'Convert PowerShell to SQL wildcard characters' {
            $Output = ConvertTo-IdoItSQLWildcard -InputString 'Some * SQ? wildcard test'
            $Output | Should Be 'Some % SQ_ wildcard test'
        }

        It -Name 'Convert Escaped PowerShell wildcard characters' {
            $Output = ConvertTo-IdoItSQLWildcard -InputString 'Some \* SQ\? wildcard test'
            $Output | Should Be 'Some * SQ? wildcard test'
        }

    }
}