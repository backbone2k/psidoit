---
external help file: psidoit-help.xml
Module Name: PsIdoIt
online version:
schema: 2.0.0
---

# Get-IdoItCategory

## SYNOPSIS
Get-IdoItCategory

## SYNTAX

### Category
```
Get-IdoItCategory [-Id] <Int32> -Category <String> [<CommonParameters>]
```

### CatgId
```
Get-IdoItCategory [-Id] <Int32> -CatgId <Int32> [<CommonParameters>]
```

### CatsId
```
Get-IdoItCategory [-Id] <Int32> -CatsId <Int32> [<CommonParameters>]
```

## DESCRIPTION
With Get-IdoItCategory you can retreive detailed information for a category for a given object.

## EXAMPLES

### BEISPIEL 1
```
Get-IdoItCategory -Id 3411 -Category "C__CATG__ACCOUNTING"
```

This command will return the accounting category for object 3411.

### BEISPIEL 2
```
Get-IdoItCategory -Id 55 -CatsId 1
```

This command will return the specific category with id 1 for object with id 55.

## PARAMETERS

### -Id
This parameter contains the id of the object you want to query a category

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Version
0.1.0     29.12.2017  CB  initial release

## RELATED LINKS
