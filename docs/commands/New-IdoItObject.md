---
external help file: PsIdoIt-help.xml
Module Name: PsIdoIt
online version:
schema: 2.0.0
---

# New-IdoItObject

## SYNOPSIS
New-IdoItObject

## SYNTAX

```
New-IdoItObject [-Type] <Object> -Title <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
New-IdoItObject lets you create a new object.

DYNAMIC PARAMETERS
-Category \<String\>
    This parameter defines the dialog category on the general category.
It is a dynamic parameter
    that will pull the available values in real time.

-Purpose \<String\>
    This parameter defines the dialog purpose on the general category.
It is a dynamic parameter
    that will pull the available values in real time.

## EXAMPLES

### EXAMPLE 1
```
New-IdoItObject -Type 5 -Title "srv12345.domain.de" -Purpose "Production"
```

This will create a new Object of type 5 (C__OBJTYPE__SERVER) with the name srv12345.domain.de
and the purpose "Production"

## PARAMETERS

### -Type
This parameter either the type id or the the type name of the object you wan't to create.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: TypeId

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Title
This the title of the object you are creating.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
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
