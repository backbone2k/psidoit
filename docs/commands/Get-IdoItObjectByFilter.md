---
external help file: PsIdoIt-help.xml
Module Name: PsIdoIt
online version:
schema: 2.0.0
---

# Get-IdoItObjectByFilter

## SYNOPSIS
Get-IdoItObjectByFilter

## SYNTAX

### NonPerson
```
Get-IdoItObjectByFilter [[-Id] <Int32[]>] [-TypeId <Int32>] [-Title <String>] [-SysId <String>]
 [-TypeTitle <String>] [-Limit <Int32>] [-Sort] [-OrderBy <String>] [<CommonParameters>]
```

### Person
```
Get-IdoItObjectByFilter [-FirstName <String>] [[-LastName] <String>] [-Email <String>] [-Limit <Int32>] [-Sort]
 [-OrderBy <String>] [<CommonParameters>]
```

## DESCRIPTION
With Get-IdoItObjectByFilter you can get one or more objects from i-doit cmdb that can be filtered by type, name, sys-id etc.

## EXAMPLES

### EXAMPLE 1
```
Get-IdoItObjectByFilter -Title "web%" -Sort -OrderBy SysId
```

This will get all objects that begin with web in the title.
The result is sorted by sysid

### EXAMPLE 2
```
Get-IdoItObjectByFilter -Email "john.doe@acme.com"
```

In this example you will get all perons with the email address \<john.doe@acme.com\>

## PARAMETERS

### -Id
Set this parameter to filter objects by an array of object ids

```yaml
Type: Int32[]
Parameter Sets: NonPerson
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TypeId
Set this parameter to filter objects by a type id.

```yaml
Type: Int32
Parameter Sets: NonPerson
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Title
With Title you can fFilter objects by their title.

```yaml
Type: String
Parameter Sets: NonPerson
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SysId
Filter objects by their sys id value.

```yaml
Type: String
Parameter Sets: NonPerson
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TypeTitle
Withe TypeTitle you can filter objects by type title.

```yaml
Type: String
Parameter Sets: NonPerson
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FirstName
Search for person objects by and filter by first name.

```yaml
Type: String
Parameter Sets: Person
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LastName
Search for person objects by and filter by last name.

```yaml
Type: String
Parameter Sets: Person
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Email
Search for person objects by and filter by email adress.

```yaml
Type: String
Parameter Sets: Person
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Limit
With limit you can recuce the number of results you get back.
Without Limit you get all objects that match your filter.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Sort
If you set the parameter sort objects will be ordered by the the property you define with the parameter OrderBy

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -OrderBy
With order by you can define what property is used for sorting objects in the result.
Default is ID.
The possbile values are
"Id","TypeID","Title","TypeTitle","SysId","FirstName","LastName","Email"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Id
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Version
0.1.0     29.12.2017  CB  initial release

## RELATED LINKS
