function Get-FrontMessageTemplateFolder {
    <#
    .SYNOPSIS
        Short description
    .DESCRIPTION
        Long description
    .EXAMPLE
        PS C:\> <example usage>
        Explanation of what the example does
    .INPUTS
        Inputs (if any)
    .OUTPUTS
        Output (if any)
    #>
    param (
        [Parameter()]
        [String]$Id,

        [Parameter(Mandatory)]
        [SecureString]$ApiKey
    )

    $Params = @{
        Method   = "GET"
        Endpoint = "message_template_folders"
        ApiKey   = $ApiKey
    }

    if ($PSBoundParameters.ContainsKey("Id")) {
        $Params["Path"] = $Id
    }

    InvokeFrontRestMethod @Params
}