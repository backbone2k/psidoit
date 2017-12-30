function checkCmdbConnection {
    if (!$global:cmdbSession) {
        Throw "You must call the Connect-Cmdb cmdlet before calling any other cmdlets."
    }
}

function Invoke-Cmdb {

    param (
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String]$Method,

        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [Hashtable]$Params,

        $uri = "https://demo.i-doit.com/src/jsonrpc.php"


    )

    $RequestID = [Guid]::NewGuid()

    $RequestBody = @{
        "method" = $Method
        "version" = "2.0"
        "id" = $requestID
        "params" = $Params
    }

    #Add the API Key to the params if it is not already defined

    if (!$RequestBody.params.ContainsKey("apikey")) {
        $RequestBody.params.Add("apikey", $global:cmdbApiKey)
    }

    $RequestBody = ConvertTo-Json -InputObject $RequestBody -Depth 4

    #define higher tls version - otherwise tls1.0 will fail on more secure web sockets
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

    try {
        $InvokeResult = Invoke-WebRequest -Uri "https://demo.i-doit.com/src/jsonrpc.php" -Method Post -Body $RequestBody -Headers @{"Content-Type" = "application/json"; "X-RPC-Auth-Session" = $global:cmdbSession}
    }
    catch {

        Throw

    }

    if ($InvokeResult.StatusCode -eq 200) {

        #Synetics puts numbers in the JSON response in quotes. This breaking type conversion into integer.
        #Before converting the JSON to an PSObject we remove quotes from numbers
        
        $Regex = '(?m)"([0-9]+)"'    
        #The regex is matching number between "". (?m) defines multiple occurance

        $TempJson = $InvokeResult.content -replace $Regex, '$1'
        
        $ContentJson = ConvertFrom-Json $TempJson

        #Check for error object
        if ($ContentJson.error -ne $null) {
            Throw "Error code $($ContentJson.error.code) - $($ContentJson.error.data.error)"

        }

        else {

            #We check that we get back our requestId. This ensures that the send JSON request could be read by the service
            if ($ContentJson.id -ne $RequestID) {
                Throw "Request id mismatch. Expected value was $RequestID but it is $($ContentJson.id)"
            }

            #Return only the result part of the response
            $ContentJson.result

        }



    }

}

function Disconnect-Cmdb {

    $Params = @{}

    Invoke-Cmdb -Method "idoit.logout" -Params $Params

    Remove-Variable -Name cmdbApiKey -Scope Global -Force:$true
    Remove-Variable -Name cmdbSession -Scope Global -Force:$true

}

function Connect-Cmdb {

    param(
        #[Parameter(Mandatory=$true)]
        $username = "admin",

        #[Parameter(Mandatory=$true)]
        $password = "admin",

        #[Parameter(Mandatory=$true)]
        [string]$apiKey = "c1ia5q"
    )

    $global:cmdbApiKey = $apiKey


    $body = @{
        "jsonrpc" = "2.0"
        "method"  = "idoit.login"
        "params"  = @{
            "apikey" = $global:cmdbApiKey
        }
    }
    #ConvertTo-Json $body
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    try {
        $result = Convertfrom-Json ((Invoke-WebRequest -Uri "https://demo.i-doit.com/src/jsonrpc.php" -Method Post -Body (ConvertTo-Json $body) -Headers @{"Content-Type" = "application/json"; "X-RPC-Auth-Username" = $username; "X-RPC-Auth-Password" = $password}).Content)
    }

    catch {
        throw

    }

    if (!$result.error) {
        $objResult = [pscustomobject]@{
            Account  = $result.result.name
            Tenant   = $result.result.'client-name'
            TenantId = $result.result.'client-id'
        }
        $global:cmdbSession = $result.result.'session-id'



    }

    else {
        Throw "Error code $($json.error.code) - $($json.error.data.error)"
    }


}

function Get-CmdbVersion {
    $Params = @{}

    checkCmdbConnection

    $ResultObj = Invoke-Cmdb -Method "idoit.version" -Params $Params

    return $ResultObj | Select-Object version, type, step
}

function Find-CmdbObjects {
<#
    .SYNOPSIS
    Find-CmdbObjects

    .DESCRIPTION
    With Find-CmdbObjects you can trigger a global search over the i-doit API.

    .PARAMETER Query
    This parameter defines the query to search for.

    .EXAMPLE
    PS> Find-CmdbObjects -Query "server"

    This command will return all objects that have "server" in their name.

    .NOTES
    Version
    1.0.0     29.12.2017  CB  initial release
#>
    Param (
        [Parameter(Mandatory = $true, Position=0)]
        [String]$Query
    )

    checkCmdbConnection

    $Params  = @{
        "q"      = $Query
    }

    #Create an empty PSObject array to store the results
    $resultObj = @(New-Object PSObject)
    $resultObj = Invoke-Cmdb -Method "idoit.search" -Params $Params

    #Thank synetics for being inconsistent about naming properties. We replace documentId to id, value to title
    foreach ($o in $resultObj) {
        $o | Add-Member -MemberType NoteProperty -Name "id" -Value $o.documentId
        $o | Add-Member -MemberType NoteProperty -Name "title" -Value $o.value
        $o.PSObject.Properties.Remove("documentId")
        $o.PSObject.Properties.Remove("value")
    }

    #Configure a default display set
    $defaultDisplaySet = 'Id','Title','Link','Score'

    #Create the default property display set
    $defaultDisplayPropertySet = New-Object System.Management.Automation.PSPropertySet(‘DefaultDisplayPropertySet’,[string[]]$defaultDisplaySet)
    $PSStandardMembers = [System.Management.Automation.PSMemberInfo[]]@($defaultDisplayPropertySet)


    $resultObj.PSObject.TypeNames.Insert(0,'Cmdb.Object')
    $resultObj | Add-Member MemberSet PSStandardMembers $PSStandardMembers

    return $resultObj


}

function Get-CmdbObject {

    param (
        [Parameter(Mandatory = $true)]
        [int]$Id
    )

    checkCmdbConnection

    $Params  = @{
        "id"     = $Id
    }

    #Create an empty PSObject array to store the results
    $resultObj = @(New-Object PSObject)

    #Configure a default display set
    $defaultDisplaySet = 'Id','SysId','Title','Type_Title'

    #Create the default property display set
    $defaultDisplayPropertySet = New-Object System.Management.Automation.PSPropertySet(‘DefaultDisplayPropertySet’,[string[]]$defaultDisplaySet)
    $PSStandardMembers = [System.Management.Automation.PSMemberInfo[]]@($defaultDisplayPropertySet)

    $ResultObj = Invoke-Cmdb -Method "cmdb.object.read" -Params $Params

    
    $resultObj.PSObject.TypeNames.Insert(0,'Cmdb.Object')
    $resultObj | Add-Member MemberSet PSStandardMembers $PSStandardMembers

    return $ResultObj

}

function Set-CmdbObject {
    [cmdletbinding()]
    Param (
        [Parameter(Mandatory=$true, ParameterSetName="Id" ,Position=0)]
        [int]$Id,

        [Parameter(Mandatory=$true, ParameterSetName="Object" ,Position=0, ValueFromPipeline)]
        [ValidateScript({ $_.PSObject.TypeNames[0] -eq 'Cmdb.Object' })]
        [PSObject]$InputObject,

        [Parameter(Mandatory=$true)]
        [string]$Title    
    )

    Process {

        $Params = @{}
        switch ($PSCmdlet.ParameterSetName) {
            "Id" { $Params.Add("id", $Id); break }
            "Object" { $Params.Add("id", $InputObject.id); break }
        }
        #$Params.Add("id", $Id)
        $Params.Add("title", $title)

        $ResultObj = Invoke-Cmdb -Method "cmdb.object.update" -Params $Params

        if ($ResultObj.success) {
            return $ResultObj.message
        }
    }

}

Trace-Command -Name ParameterBinding -Expression { Get-CmdbObject -Id 3411 | Set-CmdbObject -Title "web009-1-pipe"} -PSHost
#Get-CmdbObject -Id 3411 | Get-Member
function New-CmdbObject { 
    Param(
        [Parameter(Mandatory=$true, ParameterSetName="ByID")]
        [int]$TypeId,

        [Parameter(Mandatory=$true, ParameterSetName="ByConst")]
        [string]$TypeConst,

        [Parameter(Mandatory=$true)]
        [string]$Title        
    )

    $Params = @{}
    switch ($PSCmdlet.ParameterSetName){
        "ByID" {$Params.Add("type", $TypeId); break}
        "ByConst" {$Params.Add("type", $TypeConst); break}
    }

    $Params.Add("title", $Title)

    $ResultObj = Invoke-Cmdb -Method "cmdb.object.create" -Params $Params

    return $ResultObj
}

#New-CmdbObject -TypeConst "C__OBJTYPE__SERVER" -Title "APIServer001" | Get-Member

function Get-CmdbObjectTypes {
    Param (
        [Parameter(Mandatory=$false)]
        [int[]]$Id,

        [Parameter(Mandatory=$false)]
        [string]$Title,

        [Parameter(Mandatory=$false)]
        [Switch]$Enabled,

        [Parameter(Mandatory=$false)]
        [int]$Limit,

        [Parameter(Mandatory=$false)]
        [ValidateSet("Asc","Desc")]
        [string]$Sort,

        [Parameter(Mandatory=$false)]
        [ValidateSet("Id","Title","Status")]
        [string]$OrderBy,

        [Parameter(Mandatory=$false)]
        [switch]$CountObjects
    )

    checkCmdbConnection
    $Params= @{}
    $Filter = @{}

    foreach ($PSBoundParameter in $PSBoundParameters.Keys) {
        switch ($PSBoundParameter) {
            #Synetics is not consistant... again. In this method there is a difference for a scalar id and array of ids.
            #We reduce complexity and do a little vodoo :-)
            "Id" {
                if ($Id.Count -eq 1) {
                    #this converts the single value to a scalar - othwerise we get a nasty error because
                    #idoit is not catching type mismatch here.
                    $Filter.Add("id", $Id[0])
                }
                else {
                    $Filter.Add("ids", $Id)
                }
                break
            }
            "Title" { $Filter.Add("title", $Title); break }
            "Enabled" { $Filter.Add("enabled", 1); break }
            "Limit" { $Params.Add("limit", $Limit); break }
            "Sort" { $Params.Add("sort", $Sort.ToUpper()); break }
            "OrderBy" { $Params.Add("order_by", $OrderBy.ToLower()); break }
            "CountObjects" { $Params.Add("countobjects", $CountObjects); break }
        }
    }


    $Params.Add("filter", $Filter)

    $ResultObj = Invoke-Cmdb -Method "cmdb.object_types.read" -Params $Params

    return $ResultObj
}

function Get-CmdbConstants {

    $Params = @{}

    $ResultObj = Invoke-Cmdb -Method "idoit.constants" -Params $Params

    #The result of this method is quite strange. Converting it back from json will result in 3 PSObjects
    #with each constant a Noteproperty. So we will create a new CustomObj with properties type, const and title
    #and merge everything into this. So all the cool PowerShell features for filtering and piping are possible

    #First we create a template Object with the properties we need...
    $TemplateObj = [pscustomobject]@{
        "type" = $null
        "const" = $null
        "title" = $null
    }

    #This is our final object where we will populate all values
    $CustomObj = @()

    #First we start with the objecttypes
    $tempType = $ResultObj.objectTypes

    Foreach ($o in $tempType.PSObject.Properties) {
        $TempObj = $TemplateObj | Select-Object *

        $TempObj.type = "objectTypes"
        $TempObj.const = $o.name
        $TempObj.title = $o.value

        $CustomObj += $TempObj
    }

    #then the global categories
    $tempType = $ResultObj.categories.g

    Foreach ($o in $tempType.PSObject.Properties) {
        $TempObj = $TemplateObj | Select-Object *

        $TempObj.type = "categories_global"
        $TempObj.const = $o.name
        $TempObj.title = $o.value

        $CustomObj += $TempObj
    }

     #and finally the specific categories
    $tempType = $ResultObj.categories.s

    Foreach ($o in $tempType.PSObject.Properties) {
        $TempObj = $TemplateObj | Select-Object *

        $TempObj.type = "categories_specific"
        $TempObj.const = $o.name
        $TempObj.title = $o.value

        $CustomObj += $TempObj
    }


    return $CustomObj

}

function Get-CmdbObjects {
<#
    .SYNOPSIS
    Get-CmdbObjects

    .DESCRIPTION
    With Get-CmdbObjects you can get one or more objects from i-doit cmdb that can be filtered by type, name, sys-id etc.

    .PARAMETER ObjId
    Set this parameter to filter objects by an array of object ids

    .PARAMETER TypeId
    Set this parameter to filter objects by a type id.

    .PARAMETER Title
    With Title you can fFilter objects by their title.

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
    PS> Get-CmdbObjects -Title "web%" -Sort -OrderBy SysId

    This will get all objects that begin with web in the title. The result is sorted by sysid

    .EXAMPLE
    PS> Get-CmdbObjects -Email "john.doe@acme.com"

    In this example you will get all perons with the email address <john.doe@acme.com>

    .NOTES
    Version
    1.0.0     29.12.2017  CB  initial release
#>
    Param (
        [Parameter(Mandatory=$false, ParameterSetName = "NonPerson", Position=0)]
        [int[]]$Id,

        [Parameter(Mandatory=$false, ParameterSetName = "NonPerson")]
        [int]$TypeId,

        [Parameter(Mandatory=$false, ParameterSetName = "NonPerson")]
        [string]$Title,

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

    checkCmdbConnection

    $Filter = @{}

    foreach ($PSBoundParameter in $PSBoundParameters.Keys) {
        switch ($PSBoundParameter) {
            "ObjID" { $Filter.Add("ids", $Id); break }
            "TypeID" {$Filter.Add("type", $TypeId); break }
            "Title" { $Filter.Add("title", $Title); break }
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

    #Create an empty PSObject array to store the results
    $resultObj = @(New-Object PSObject)

    #Configure a default display set
    $defaultDisplaySet = 'Id','SysId','Title','Type_Title'

    #Create the default property display set
    $defaultDisplayPropertySet = New-Object System.Management.Automation.PSPropertySet(‘DefaultDisplayPropertySet’,[string[]]$defaultDisplaySet)
    $PSStandardMembers = [System.Management.Automation.PSMemberInfo[]]@($defaultDisplayPropertySet)

    $resultObj = Invoke-Cmdb -Method "cmdb.objects.read" -Params $Params

    $resultObj.PSObject.TypeNames.Insert(0,'Cmdb.Object')
    $resultObj | Add-Member MemberSet PSStandardMembers $PSStandardMembers

    return $resultObj
}

function Get-CmdbServers {

    $TypeId = (Get-CmdbObjectTypes | Where-Object {$_.Title -eq "Server"}).id

    Get-CmdbObjects -TypeId $TypeId

}


function Get-CmdbCategoryAccounting {

    [cmdletbinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline)]
        [int[]]$Id
    )

    Begin {
        #Create an empty PSObject array to store the results
        $resultObj = @(New-Object PSObject)

        #Configure a default display set
        $defaultDisplaySet = 'ID','objID','Account','Cost_unit'

        #Create the default property display set
        $defaultDisplayPropertySet = New-Object System.Management.Automation.PSPropertySet(‘DefaultDisplayPropertySet’,[string[]]$defaultDisplaySet)
        $PSStandardMembers = [System.Management.Automation.PSMemberInfo[]]@($defaultDisplayPropertySet)
    }

    Process {

        foreach ($o in $Id) {
            $resultObj += Get-CmdbCategory -Id $o -Category "C__CATG__ACCOUNTING"
        }
    }

    End {

        #Give this object a unique typename
        $resultObj.PSObject.TypeNames.Insert(0,'Cmdb.Category.Accounting')
        $resultObj | Add-Member MemberSet PSStandardMembers $PSStandardMembers

        return $resultObj
    }
}

function Get-CmdbCategoryIpAddress {
    [cmdletbinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline)]
        [int[]]$Id
    )

    Process {

        foreach ($o in $Id) {
            $resultObj += Get-CmdbCategory -Id $o -Category "C__CATG__IP"
        }

        $resultObj
    }
}
#Get-CmdbConstants | ? {$_.Title -like "Address"}
#Get-CmdbCategory -id 3411 -CatgId 47
#Get-CmdbObject -Id 3312
#Get-CmdbCategoryIpAddress -Id 3411

function Get-CmdbCategory {
<#
    .SYNOPSIS
    Get-CmdbCategory

    .DESCRIPTION
    With Get-CmdbCategory you can retreive detailed information for a category for a given object.

    .PARAMETER Id
    This parameter contains the id of the object you want to query a category

    .PARAMETER Category
    This parameter takes a constant name of a specific category

    .PARAMETER CatgId
    With CatgId you can pass an id of a global category from table isysgui_catg

    .PARAMETER CatsId
    With CatsId you can pass an id of a specific catgeory from table isysgui_cats

    .EXAMPLE
    PS> Get-CmdbCategory -Id 3411 -Category "C__CATG__ACCOUNTING"

    This command will return the accounting category for object 3411.

    .EXAMPLE
    PS> Get-CmdbCategory -Id 55 -CatsId 1

    This command will return the specific category with id 1 for object with id 55.

    .NOTES
    Version
    1.0.0     29.12.2017  CB  initial release
#>
    [cmdletbinding()]
    Param (
        [Parameter(Mandatory = $true, ValueFromPipeline=$true)]
        [int]$Id,

        [Parameter(Mandatory = $true, ParameterSetName="Category")]
        [string]$Category,

        [Parameter(Mandatory = $true, ParameterSetName="CatgId")]
        [int]$CatgId,

        [Parameter(Mandatory = $true, ParameterSetName="CatsId")]
        [int]$CatsId
    )


    Process {

        $Params  = @{}
        $Params.Add("objID", $Id)

        Switch ($PSCmdlet.ParameterSetName) {
            "Category" { $Params.Add("category",$Category); Break }
            "CatgId" { $Params.Add("catgID",$CatgId); Break }
            "CatsId" { $Params.Add("catsID",$CatsId); Break }
        }


        $resultObj = Invoke-Cmdb -Method "cmdb.category.read" -Params $Params

        #We remove the property original property id and rename objID to id to be consistant and be able to pipe results to
        #other Cmdlets

        foreach ($o in $resultObj) {
            if (@("CatgId", "CatsId") -contains $PSCmdlet.ParameterSetName) {
                $o | Add-Member -MemberType NoteProperty -Name $PSCmdlet.ParameterSetName.ToLower() -Value $o.id
            }
            else {
                $o | Add-Member -MemberType NoteProperty -Name "category" -Value $Category
            }
            $o.id = $o.objID
            $o.PSObject.Properties.Remove("objID")

        }

        return $resultObj
    }
}

function Get-CmdbCategoryInfo {
    Param (
        [Parameter(Mandatory=$true, ParameterSetName="CatgId")]
        [int]$CatgId,

        [Parameter(Mandatory=$true, ParameterSetName="CatsId")]
        [int]$CatsId
    )

    $Params = @{}

    Switch ($PSCmdlet.ParameterSetName) {
        "CatgId" { $Params.Add("catgID",$CatgId); Break }
        "CatsId" { $Params.Add("catsID",$CatsId); Break }
    }

    $resultObj = Invoke-Cmdb -Method "cmdb.category_info" -Params $Params
    return $resultObj
}

function Get-CmdbDialog {
    Param (
        [Parameter(Mandatory=$true, Position=0)]
        [String]$Category,

        [Parameter(Mandatory=$true, Position=1)]
        [String]$Property
    )

    $Params = @{}
    $Params.Add("category",$Category)
    $Params.Add("property",$Property)

    $ResultObj = Invoke-Cmdb -Method "cmdb.dialog.read" -Params $Params

    return $ResultObj
}

function Get-CmdbReport {
    Param(
        [Parameter(Mandatory=$false, Position=0)]
        [int]$Id
    )

    $Params = @{}
    if ($PSBoundParameters.ContainsKey("Id")) {
        $Params.Add("id", $Id)
    }

    $ResultObj = Invoke-Cmdb -Method "cmdb.reports.read" -Params $Params

    return $ResultObj
}

function Get-CmdbObjectTypeCategories {
    Param (
        [Parameter(Mandatory=$true, Position=0)]
        $Type
    )

    $Params = @{}
    $Params.Add("type", $Type)

    $ResultObj = Invoke-Cmdb -Method "cmdb.object_type_categories.read" -Params $Params

    return $ResultObj
}

function Get-CmdbObjectTypeGroups {
    Param (
        [Parameter(Mandatory=$false)]
        [int]$Limit,

        [Parameter(Mandatory=$false)]
        [ValidateSet("Asc","Desc")]
        [String]$Sort,

        [Parameter(Mandatory=$false)]
        [ValidateSet("Id","Title","Status","Constant")]
        [String]$OrderBy
    )

    $Params = @{}

    if ($PSBoundParameters.ContainsKey("Sort")) {
        $Params.Add("sort", $Sort.ToLower())
    }

    if ($PSBoundParameters.ContainsKey("OrderBy")) {
        $Params.Add("order_by", $OrderBy.ToLower())
    }

    if ($PSBoundParameters.ContainsKey("Limit")) {
        $Params.Add("limit", $Limit)
    }

    $ResultObj = Invoke-Cmdb -Method "cmdb.object_type_groups.read" -Params $Params

    return $ResultObj
}


function get-cmdbResponsibles-xx {

    param (
        [Parameter(Mandatory = $true)]
        [int]$objID = 3411,

        [int]$roleID = 5
    )

    $body = @{
        "jsonrpc" = "2.0"
        "method"  = "cmdb.category.read"
        "params"  = @{
            "apikey"   = $global:cmdbApiKey
            "objID"    = $objID
            "category" = "C__CATG__CONTACT"

        }
        "id"      = 1
    }

    $result = @()

    $r = invoke-cmdb -body $body

    if ($r.count -gt 0) {

        $contacts = $r | Where-Object {$_.role.id -eq $roleID}

        foreach ($contact in $contacts) {
            $contactObj = get-cmdbobject -objId $contact.'contact_object'.id
            switch ($contactObj.objecttype) {
                53 { $result += get-cmdbCategory -objID $contactObj.id -category "C__CATS__PERSON" }
                54 { $result += get-cmdbCategory -objID $contactObj.id -category "C__CATS__PERSON_GROUP" }
                default {}
            }
        }

        return $result
    }
}

function measure-cmdbQuality-xx {

    param (
        [Parameter(Mandatory = $true)]
        [int]$objID = 3411,

        $objType = "Server"
    )

    [xml]$definition = Get-Content -Path "C:\Temp\$($objType)_def.xml"

    $accounting = Get-CmdbCategoryAccounting -objID $objID
    if ($accounting.account -eq $null) {
        Write-Host "Möp"
    }

}

#Find-CmdbObjects "Web App"

#3411,3327 | Get-CmdbCategory -Category "C__CATG__ACCOUNTING"
#Get-CmdbCategory -Id 55 -CatsId 1

#Get-CmdbObjects -Title "web%" -Sort -OrderBy Id

#Get-CmdbCategoryInfo -CatgId 38

#Get-CmdbDialog -Category "C__CATG__GLOBAL" -Property "cmdb_status"

#Get-CmdbReport -Id 16
#Get-CmdbReport

#Get-CmdbObjectTypeCategories -Type "C__OBJTYPE__SERVICE"

#Get-CmdbObjectTypeGroups -OrderBy "constant" -Sort "Desc"

#Get-CmdbConstants

#Get-CmdbObjectTypes -Title "%l Maschines%" -CountObjects

#Get-CmdbObject -Id 3411