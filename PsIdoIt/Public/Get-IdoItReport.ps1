Function Get-IdoItReport {
    <#
       .SYNOPSIS
       Get-IdoItReport

       .DESCRIPTION
       This Cmdlet can retreive all reports or if you provide a report id also get the result of the
       specified report

       .PARAMETER Id
       Optional parameter that, if provided executes the report with the id and shows the results

       .EXAMPLE
       PS> Get-IdoItReport

       Gets all Reports

       .EXAMPLE
       PS> Get-IdoItReport -Id 23

       Runs Report with Id 23 and outputs the result

       .NOTES
       Version
       0.1.0     29.12.2017  CB  initial release
   #>
       Param(
           [Parameter(Mandatory = $False, Position=0)]
           [int]$Id
       )

       $Params = @{}
       If ($PSBoundParameters.ContainsKey("Id")) {
           $Params.Add("id", $Id)
       }

       $ResultObj = Invoke-IdoIt -Method "cmdb.reports.read" -Params $Params

       #$ResultObj = $ResultObj | Add-ObjectDefaultPropertySet -DefaultProperties Id, Title, Category
       Return $ResultObj
   }