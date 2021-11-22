---
external help file: PSFront-help.xml
Module Name: PSFront
online version:
schema: 2.0.0
---

# Invoke-FrontRestMethod

## SYNOPSIS
Arbitrarily interact with Front's Core API.

## SYNTAX

```
Invoke-FrontRestMethod [-Method] <WebRequestMethod> [-Endpoint] <String> [[-Path] <String>]
 [[-Body] <Hashtable>] [[-Query] <Hashtable>] [-ApiKey] <SecureString> [<CommonParameters>]
```

## DESCRIPTION
Arbitrarily interact with Front's Core API.
Since this function is for no particular endpoint in Front's API, this can be useful for occasions when Front have added a new endpoint, query or body parameter to their API specification and one of the other dedicated functions of PSFront have not yet been updated.

## EXAMPLES

### EXAMPLE 1
```
Invoke-FrontRestMethod -Method GET -Endpoint tags -ApiKey $secret
```

Lists all tags in Front: https://dev.frontapp.com/reference/tags-1#get_tags

### EXAMPLE 2
```
Invoke-FrontRestMethod -Method GET -Endpoint teams -Path "tim_2daq7/tags" -ApiKey $secret
```

Lists all tags for the team with id tim_2daq7 in Front: https://dev.frontapp.com/reference/tags-1#get_teams-team-id-tags-1

## PARAMETERS

### -Method
{{ Fill Method Description }}

```yaml
Type: WebRequestMethod
Parameter Sets: (All)
Aliases:
Accepted values: Default, Get, Head, Post, Put, Delete, Trace, Options, Merge, Patch

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Endpoint
{{ Fill Endpoint Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path
{{ Fill Path Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Body
{{ Fill Body Description }}

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Query
{{ Fill Query Description }}

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ApiKey
{{ Fill ApiKey Description }}

```yaml
Type: SecureString
Parameter Sets: (All)
Aliases:

Required: True
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### This function does not accept pipeline input.
## OUTPUTS

### System.Management.Automation.PSObject
## NOTES

## RELATED LINKS
