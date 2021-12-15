function Update-FrontMessageTemplate {
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
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [String]$Id,

        [Parameter()]
        [String]$Body,

        [Parameter(Mandatory)]
        [SecureString]$ApiKey
    )

    $Params = @{
        Method   = "PATCH"
        ApiKey   = $ApiKey
        Endpoint = "message_templates"
        Path     = $id
    }

    switch ($PSBoundParameters.Keys) {
        "Body" {
            $Params["Body"] = @{ body = $Body }
        }
    }

    InvokeFrontRestMethod @Params
}