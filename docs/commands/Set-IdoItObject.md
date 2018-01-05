---
external help file: psidoit-help.xml
Module Name: PsIdoIt
online version:
schema: 2.0.0
---

# Set-IdoItObject

## SYNOPSIS
Set-IdoItObject

## SYNTAX

```
Set-IdoItObject [-Id] <Int32> -Title <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Set-IdoItObject lets you modify an existing objects title .

## EXAMPLES

### BEISPIEL 1
```
Set-IdoItObject -Id 1234 -Title "srv12345.domain.de"
```

This will change the title for object 1234 to srv12345.domain.de

## PARAMETERS

### -Id
{{Fill Id Description}}

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

### -Title
Defines  the new title for the object you are modifing.

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
