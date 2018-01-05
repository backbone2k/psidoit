---
external help file: PsIdoIt-help.xml
Module Name: PsIdoIt
online version:
schema: 2.0.0
---

# Get-IdoItObject

## SYNOPSIS
Gets an object from the idoit cmdb and returns it as a idoit.object object

## SYNTAX

```
Get-IdoItObject [-Id] <Int32> [[-RawOutput] <PSReference>] [<CommonParameters>]
```

## DESCRIPTION
This cmdlet will return an idoit cmbd object for a provided id.
The id can be get by find-idoitobject or by inspecting the idoit url when
using the web interface.

Typically you will have an url like https://demo.i-doit.com/?objID=3569
The objID parameter contains the id.

So if you want to get the object from the above url with the Get-IdoItObject cmdlet you have to type in:
    Get-IdoitObject -Id 3569

## EXAMPLES

### EXAMPLE 1
```
Get-IdoItObject -Id 1234
```

This will get the object with the id \<1234\>

## PARAMETERS

### -Id
This is the unique id of the object you want to get pull from the idoit cmdb.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -RawOutput
You can provide a \[Ref\] parameter to the function to get back the raw response from the invoke to the I-doIt API.

You have to put the parameter in parantheses like this:
-RawOutput (\[Ref\]$Output)

The return value is a Microsoft.PowerShell.Commands.HtmlWebResponseObject

```yaml
Type: PSReference
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
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
0.1.0   29.12.2017  CB  initial release
0.2.0   05.01.2018  CB  Added support for RawOuput; Improved inline help

## RELATED LINKS
