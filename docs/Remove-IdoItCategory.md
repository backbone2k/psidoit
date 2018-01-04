---
external help file: psidoit-help.xml
Module Name: PsIdoIt
online version:
schema: 2.0.0
---

# Remove-IdoItCategory

## SYNOPSIS
Remove-IdoItCategory

## SYNTAX

### Category
```
Remove-IdoItCategory [-Id] <Int32> -Category <String> -ElementId <Int32> [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### CatgId
```
Remove-IdoItCategory [-Id] <Int32> -CatgId <Int32> -ElementId <Int32> [-WhatIf] [-Confirm] [<CommonParameters>]
```

### CatsId
```
Remove-IdoItCategory [-Id] <Int32> -CatsId <Int32> -ElementId <Int32> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
With Remove-IdoItCategory you can remove a category object for a given object.

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -Id
This parameter contains the id of the object you want to remove a category

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

### -Category
This parameter takes a constant name of a specific category

```yaml
Type: String
Parameter Sets: Category
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CatgId
With CatgId you can pass an id of a global category from table isysgui_catg

```yaml
Type: Int32
Parameter Sets: CatgId
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -CatsId
With CatsId you can pass an id of a specific catgeory from table isysgui_cats

```yaml
Type: Int32
Parameter Sets: CatsId
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -ElementId
This value is mandatory for multi value categories like CPU or hostaddress.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: 0
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
