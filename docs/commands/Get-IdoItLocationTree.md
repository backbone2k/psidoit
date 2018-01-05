---
external help file: PsIdoIt-help.xml
Module Name: PsIdoIt
online version:
schema: 2.0.0
---

# Get-IdoItLocationTree

## SYNOPSIS
Get-IdoItLocationTree

## SYNTAX

```
Get-IdoItLocationTree [-Id] <Int32> [<CommonParameters>]
```

## DESCRIPTION
With Get-CmdbLOcationTree you can define a parent object and retreive all child objects that are bound to this
location

## EXAMPLES

### EXAMPLE 1
```
Get-IdoItLocationTree -Id 38
```

This will return all objects assigned to the parent object location with id 38

## PARAMETERS

### -Id
This is the object id of the parent object

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: 0
Accept pipeline input: True (ByPropertyName)
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
