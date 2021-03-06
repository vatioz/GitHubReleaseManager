# Invoke-GitHubRestMethod

## SYNOPSIS
A module specific wrapper for Invoke-ResetMethod

## SYNTAX

### Standard (Default)
```
Invoke-GitHubRestMethod [-Method] <String> [-URI] <String> [[-Headers] <IDictionary>]
```

### WithBody
```
Invoke-GitHubRestMethod [-Method] <String> [-URI] <String> [[-Body] <String>] [[-Headers] <IDictionary>]
```

### InFile
```
Invoke-GitHubRestMethod [-Method] <String> [-URI] <String> [[-InFile] <String>] [[-ContentType] <String>]
 [[-Headers] <IDictionary>]
```

### OutFile
```
Invoke-GitHubRestMethod [-Method] <String> [-URI] <String> [[-OutFile] <String>] [[-Headers] <IDictionary>]
```

## DESCRIPTION
A module specific wrapper for Invoke-ResetMethod

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Invoke-GitHubRestMethod -Method POST -URI /api/release/1
```

## PARAMETERS

### -Method
METHOD: GET, POST, PUT, DELETE

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -URI
Service URI

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

### -Body
Payload for the request, if applicable

```yaml
Type: String
Parameter Sets: WithBody
Aliases: 

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -InFile
The File to upload

```yaml
Type: String
Parameter Sets: InFile
Aliases: 

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ContentType
The content type of the file to upload

```yaml
Type: String
Parameter Sets: InFile
Aliases: 

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OutFile
Path to downloaded file

```yaml
Type: String
Parameter Sets: OutFile
Aliases: 

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Headers
Optional Headers to send.
This will override the default set provided

```yaml
Type: IDictionary
Parameter Sets: (All)
Aliases: 

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

### System.String

## OUTPUTS

### System.Management.Automation.PSObject

## NOTES

## RELATED LINKS

