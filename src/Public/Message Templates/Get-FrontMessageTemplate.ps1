function Get-FrontMessageTemplate {
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
    [CmdletBinding(DefaultParameterSetName="ById")]
    param (
        [Parameter(Mandatory, ParameterSetName="ById")]
        [String]$Id,

        [Parameter(Mandatory, ParameterSetName="ByFolderId")]
        [String]$FolderId,

        [Parameter(ParameterSetName="All")]
        [Switch]$All,

        [Parameter(Mandatory)]
        [SecureString]$ApiKey
    )

    $Params = @{
        Method   = "GET"
        ApiKey   = $ApiKey
    }

    switch ($PSCmdlet.ParameterSetName) {
        "ById" {
            $Params["Endpoint"] = "message_templates"
            $Params["Path"]     = $id
        }
        "ByFolderId" {
            $Params["Endpoint"] = "message_template_folders"
            $Params["Path"]     = "{0}/message_templates" -f $FolderId
        }
        "All" {
            $Params["Endpoint"] = "message_templates"
        }
    }

    InvokeFrontRestMethod @Params
}