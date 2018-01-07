Function Get-IdoItObjectTypeGroup {
<#
    .SYNOPSIS
    Get-IdoItObjectTypeGroup

    .DESCRIPTION
    Calling this Cmdlet you retreive all the available object type groups configured in idoit

    .PARAMETER Limit
    Limits the number of Items the function returns.

    .PARAMETER Sort
    ** THIS SHOULD BE REMOVED - WE CAN USE Sort-Object **

    .PARAMETER OrderBy
    Can be Id, Title, Status or Constant and defines the Order in wich the result is comfing from the SQL Query

    ** THIS SHOULD BE REMOVED - WE CAN USE Sort-Object **

    .EXAMPLE
    PS> Get-IdoItObjectTypeGroup

    This will get all Type Groups

    .NOTES
    Version
    0.1.0     29.12.2017  CB  initial release
#>
    Param (
        [Parameter( Mandatory = $False )]
        [int]$Limit,

        [Parameter( Mandatory = $False )]
        [ValidateSet("Asc","Desc")]
        [String]$Sort,

        [Parameter( Mandatory = $False )]
        [ValidateSet( "Id","Title","Status","Constant" )]
        [String]$OrderBy
    )

    $Params = @{}

    If ($PSBoundParameters.ContainsKey("Sort")) {
        $Params.Add("sort", $Sort.ToLower())
    }

    If ($PSBoundParameters.ContainsKey("OrderBy")) {
        $Params.Add("order_by", $OrderBy.ToLower())
    }

    If ($PSBoundParameters.ContainsKey("Limit")) {
        $Params.Add("limit", $Limit)
    }

    $ResultObj = Invoke-IdoIt -Method "cmdb.object_type_groups.read" -Params $Params

    $ResultObj = $ResultObj | Add-ObjectTypeName -TypeName 'Idoit.ObjectTypeGroup'
    Return $ResultObj
}
