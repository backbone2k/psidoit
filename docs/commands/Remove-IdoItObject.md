---
external help file: PsIdoIt-help.xml
Module Name: PsIdoIt
online version:
schema: 2.0.0
---

# Remove-IdoItObject

## SYNOPSIS
Remove-IdoItObject

## SYNTAX

### Quickpurge
```
Remove-IdoItObject [-Id] <Int32[]> [-Quickpurge] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Purge
```
Remove-IdoItObject [-Id] <Int32[]> [-Purge] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Delete
```
Remove-IdoItObject [-Id] <Int32[]> [-Delete] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Archive
```
Remove-IdoItObject [-Id] <Int32[]> [-Archive] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Default
```
Remove-IdoItObject [-Id] <Int32[]> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
With Remove-IdoItObject you can archive, delete or purge a object from i-doit

## EXAMPLES

### EXAMPLE 1
```
Remove-IdoItObject -Id 1234 -Archive
```

This will archive the object with the id 1234

## PARAMETERS

### -Id
The id of the object you want to remove

```yaml
Type: Int32[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Archive
When this switch is provided, the object is archived

```yaml
Type: SwitchParameter
Parameter Sets: Archive
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Delete
When this switch is provided, the object is deleted

```yaml
Type: SwitchParameter
Parameter Sets: Delete
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Purge
When this switch is provided, the object is purged

```yaml
Type: SwitchParameter
Parameter Sets: Purge
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Quickpurge
{{Fill Quickpurge Description}}

```yaml
Type: SwitchParameter
Parameter Sets: Quickpurge
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
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
