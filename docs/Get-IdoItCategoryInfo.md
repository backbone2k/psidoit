---
external help file: psidoit-help.xml
Module Name: PsIdoIt
online version:
schema: 2.0.0
---

# Get-IdoItCategoryInfo

## SYNOPSIS
Get-IdoItCategoryInfo

## SYNTAX

### Category
```
Get-IdoItCategoryInfo -Category <String> [<CommonParameters>]
```

### CatgId
```
Get-IdoItCategoryInfo -CatgId <Int32> [<CommonParameters>]
```

### CatsId
```
Get-IdoItCategoryInfo -CatsId <Int32> [<CommonParameters>]
```

## DESCRIPTION
Get-IdoItCategoryInfo lets you discover all available category properties for a given category id

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Version
0.1.0     29.12.2017  CB  initial release

## RELATED LINKS
