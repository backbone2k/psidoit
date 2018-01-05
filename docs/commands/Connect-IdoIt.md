---
external help file: PsIdoIt-help.xml
Module Name: PsIdoIt
online version:
schema: 2.0.0
---

# Connect-IdoIt

## SYNOPSIS
Connect-Cmdb initalize the session to the idoit cmdb.

## SYNTAX

### SetA
```
Connect-IdoIt -Credential <PSCredential> [-ApiKey] <String> [-Uri] <String> [-RawOutput <PSReference>] [-NoTls]
 [<CommonParameters>]
```

### SetB
```
Connect-IdoIt [-Settings] <Hashtable> [-RawOutput <PSReference>] [-NoTls] [<CommonParameters>]
```

### SetC
```
Connect-IdoIt [-ConfigFile] <String> [-RawOutput <PSReference>] [-NoTls] [<CommonParameters>]
```

## DESCRIPTION
Connect-Cmdb initalize the session to the idoit cmdb.

## EXAMPLES

### EXAMPLE 1
```
Connect-Cmdb -Username 'admin' -Password 'admin' -Uri 'https://demo.i-doit.com/src/jsonrpc.php' -ApiKey 'asdaur'
```

This will esatblish a session to demo.i-doit.com with api key asdaur for user admin

## PARAMETERS

### -Credential
{{Fill Credential Description}}

```yaml
Type: PSCredential
Parameter Sets: SetA
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ApiKey
This is the apikey you define in idoit unter Settings-\> Interface-\> JSON-RPC API to access the api

```yaml
Type: String
Parameter Sets: SetA
Aliases:

Required: True
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Uri
This is the Uri to the idoit JSON-RPC API.
It is always in the format http\[s\]://your.i-doit.host/src/jsonrpc.php

```yaml
Type: String
Parameter Sets: SetA
Aliases:

Required: True
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Settings
This parameter will be removed - for hashtable you can use paramter splatting

```yaml
Type: Hashtable
Parameter Sets: SetB
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ConfigFile
You can provide a path to a settings file in json format.
It must containt username, password, apikey and
uri as key-value pairs

```yaml
Type: String
Parameter Sets: SetC
Aliases:

Required: True
Position: 1
Default value: None
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
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NoTls
{{Fill NoTls Description}}

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
Version
0.1.0   29.12.2017  CB  initial release
0.2.0   31.12.2017  CB  some major redesign for the parameter sets
0.3.0   02.01.2018  CB  Using Credential object instead of username & password (https://github.com/PowerShell/PSScriptAnalyzer/issues/363)
0.3.1   03.01.2018  CB  Added Verbose/Debug output, ParameterSplatting to the Invoke and RawOuput

## RELATED LINKS
