function Remove-FrontConversationTag {
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
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = "High")]
    param (
        [Parameter(Mandatory)]
        [String]$ConversationId,

        [Parameter(Mandatory)]
        [String[]]$TagId,

        [Parameter(Mandatory)]
        [SecureString]$ApiKey
    )

    $Params = @{
        Method = "DELETE"
        Endpoint = "conversations"
        Path = "{0}/tags" -f $ConversationId
        Body = @{
            "tag_ids" = @($TagId)
        }
        ApiKey = $ApiKey
    }

    try {
        if ($PSCmdlet.ShouldProcess(
            ('Would remove tag ID(s) "{0}" to conversation "{1}"' -f [String]::Join('", "', $TagId), $ConversationId),
            "Are you sure you want to continue?",
            ('Removing tag ID(s) "{0}" to conversation "{1}"' -f [String]::Join('", "', $TagId), $ConversationId))) {
                InvokeFrontRestMethod @Params
            }
    }
    catch {
        Write-Error -ErrorRecord $_
    }
}