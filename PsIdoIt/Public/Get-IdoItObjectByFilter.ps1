Function Get-IdoItObjectByFilter {
    <#
        .SYNOPSIS
        Get-IdoItObjectByFilter

        .DESCRIPTION
        With Get-IdoItObjectByFilter you can get one or more objects from i-doit cmdb that can be filtered by type, name, sys-id etc.

        .PARAMETER Title
        With Title you can fFilter objects by their title.

        .PARAMETER Id
        Set this parameter to filter objects by an array of object ids

        .PARAMETER TypeId
        Set this parameter to filter objects by a type id.

        .PARAMETER SysId
        Filter objects by their sys id value.

        .PARAMETER TypeTitle
        Withe TypeTitle you can filter objects by type title.

        .PARAMETER FirstName
        Search for person objects by and filter by first name.

        .PARAMETER LastName
        Search for person objects by and filter by last name.

        .PARAMETER Email
        Search for person objects by and filter by email adress.

        .PARAMETER Limit
        With limit you can recuce the number of results you get back. Without Limit you get all objects that match your filter.

        .PARAMETER Sort
        If you set the parameter sort objects will be ordered by the the property you define with the parameter OrderBy

        .PARAMETER OrderBy
        With order by you can define what property is used for sorting objects in the result. Default is ID. The possbile values are
        "Id","TypeID","Title","TypeTitle","SysId","FirstName","LastName","Email"

        .EXAMPLE
        PS> Get-IdoItObjectByFilter -Title "web%" -Sort -OrderBy SysId

        This will get all objects that begin with web in the title. The result is sorted by sysid

        .EXAMPLE
        PS> Get-IdoItObjectByFilter -Email "john.doe@acme.com"

        In this example you will get all perons with the email address <john.doe@acme.com>

        .NOTES
        Version
        0.1.0   29.12.2017  CB  initial release
        0.2.0   10.01.2018  CB  Added Titel SupportWildcards.
    #>
        Param (
            [Parameter (
                Mandatory = $False,
                ParameterSetName = "NonPerson",
                Position = 0
            )]
            [SupportsWildcards()]
            [String]$Title,

            [Parameter(Mandatory=$false, ParameterSetName = "NonPerson")]
            [int[]]$Id,

            [Parameter(Mandatory=$false, ParameterSetName = "NonPerson")]
            [int]$TypeId,

            [Parameter(Mandatory=$false, ParameterSetName = "NonPerson")]
            [string]$SysId,

            [Parameter(Mandatory=$false, ParameterSetName = "NonPerson")]
            [string]$TypeTitle,

            [Parameter(Mandatory=$false, ParameterSetName = "Person")]
            [string]$FirstName,

            [Parameter(Mandatory=$false, ParameterSetName = "Person", Position=0)]
            [string]$LastName,

            [Parameter(Mandatory=$false, ParameterSetName = "Person")]
            [string]$Email,

            [Parameter(Mandatory=$false)]
            [int]$Limit,

            [Parameter(Mandatory=$false)]
            [Switch]$Sort,

            [Parameter(Mandatory=$false)]
            [ValidateSet("Id","TypeID","Title","TypeTitle","SysId","FirstName","LastName","Email")]
            [String]$OrderBy="Id"
        )

        #checkCmdbConnection

        $Filter = @{}

        ForEach ($PSBoundParameter in $PSBoundParameters.Keys) {

            Switch ($PSBoundParameter) {
                "Id" { $Filter.Add("ids", $Id); break }
                "TypeId" {$Filter.Add("type", $TypeId); break }
                "Title" {
                    $Filter.Add("title", ( ConvertTo-IdoItSQLWildcard -InputString $Title ))
                    Break
                }
                "SysID" { $Filter.Add("sysid", $SysId); break }
                "TypeTitle" { $Filter.Add("type_title", $TypeTitle); break }
                "FirstName" { $Filter.Add("first_name", $FirstName); break }
                "LastName" { $Filter.Add("last_name", $LastName); break }
                "Email" { $Filter.Add("email", $Email); break }
            }
        }

        $Params= @{}
        $Params.Add("filter", $Filter)

        If ($PSBoundParameters.ContainsKey('Limit')) {
            $Params.Add("limit", $Limit)
        }

        If ($PSBoundParameters.ContainsKey('Sort')) {
            $Params.Add("Sort", 1)
            $Params.Add("order_by", $OrderBy)
        }

        $ResultObj = Invoke-IdoIt -Method "cmdb.objects.read" -Params $Params

        $ResultObj = $ResultObj | Add-ObjectTypeName -TypeName 'Idoit.Object'

        Return $ResultObj
    }