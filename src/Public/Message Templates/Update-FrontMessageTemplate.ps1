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
        [String]$Name,

        [Parameter()]
        [String]$Subject,

        [Parameter()]
        [String]$Body,

        [Parameter()]
        [String]$FolderId,

        [Parameter()]
        [String[]]$InboxId,

        [Parameter(Mandatory)]
        [SecureString]$ApiKey
    )

    $Params = @{
        Method   = "PATCH"
        ApiKey   = $ApiKey
        Endpoint = "message_templates"
        Path     = $id
    }

    $Body = @{}

    switch ($PSBoundParameters.Keys) {
        "Name" {
            $Params["Body"] = $Body["name"] = $Name
        }
        "Subject" {
            $Params["Body"] = $Body["subject"] = $Subject
        }
        "Body" {
            $Params["Body"] = $Body["body"] = $Body
        }
        "FolderId" {
            $Params["FolderId"] = $Body["folder_id"] = $FolderId
        }
        "InboxId" {
            $Params["InboxId"] = $Body["inbox_ids"] = @($InboxId)
        }
    }

    InvokeFrontRestMethod @Params
}