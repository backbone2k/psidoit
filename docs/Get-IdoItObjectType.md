---
external help file: psidoit-help.xml
Module Name: PsIdoIt
online version:
schema: 2.0.0
---

# Get-IdoItObjectType

## SYNOPSIS
Get-IdoItObjectType

## SYNTAX

```
Get-IdoItObjectType [[-Id] <Int32[]>] [[-Title] <String>] [-Enabled] [[-Limit] <Int32>] [-CountObjects]
 [<CommonParameters>]
```

## DESCRIPTION
Get-IdoItObjectType returns available object types.
If you provide no parameters you will get all availabke
object types from idoit.

## EXAMPLES

### BEISPIEL 1
```
Get-IdoItObjectType -Id 123,572,1349 -Enabled
```

This will return the object types 123, 572 and 1349 but will filter out objects if they are not enabled.

## PARAMETERS

### -Id
If provided the result will be filtered these Ids

```yaml
Type: Int32[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Title
If provided the result will be filtered by title

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Enabled
Only return object types that are enabled

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

### -Limit
Limit the number results to the this value

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -CountObjects
When you define this switch parameter, you will get the amount of objects per object type

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
The parameters order_by and sort are not used through the api.
Instead you can use the PowerShell to sort results :-)

Version
0.1.0     29.12.2017  CB  initial release

## RELATED LINKS
