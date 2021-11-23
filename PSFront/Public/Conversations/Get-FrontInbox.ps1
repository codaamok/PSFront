function Get-FrontInbox {
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
        Endpoint = "inboxes"
        ApiKey   = $ApiKey
    }

    if ($PSBoundParameters.ContainsKey("Id")) {
        $Params["Path"] = $Id
    }

    try {
        InvokeFrontRestMethod @Params
    }
    catch {
        Write-Error -ErrorRecord $_
    }
}