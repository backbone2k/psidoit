Function Get-IdoItObjectByRelation {
    #TODO This function is not working yet
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true, Position=0)]
        [int]$Id,

        [Parameter(Mandatory=$false, Position=1)]
        $RelType
    )

    Process {
        $Params = @{}
        $Params.Add("id", $Id)

        If ($PSBoundParameters.ContainsKey("RelType")) {
            $Params.Add("relation_type", $RelType)
        }

        $ResultObj = Invoke-IdoIt -Method "cmdb.objects_by_relation.read" -Params $Params

        Return $ResultObj
    }
}