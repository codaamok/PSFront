function New-FrontComment {
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
    .NOTES
        General notes
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = "Low")]
    param (
        [Parameter(Mandatory)]
        [String]$ConversationId,

        [Parameter(Mandatory)]
        [String]$AuthorId,

        [Parameter(Mandatory)]
        [String]$Comment,

        [Parameter(Mandatory)]
        [SecureString]$ApiKey
    )

    $Params = @{
        Method = "POST"
        Endpoint = "conversations"
        Path = "{0}/comments" -f $ConversationId
        Body = @{
            author_id = $AuthorId
            body = $Comment
        }
        ApiKey = $ApiKey
    }

    try {
        if ($PSCmdlet.ShouldProcess(
            ('Would add commment "{0}" as author "{1}" to conversation "{2}"' -f $Comment, $AuthorId, $ConversationId),
            "Are you sure you want to continue?",
            ('Adding commment "{0}" as author "{1}" to conversation "{2}"' -f $Comment, $AuthorId, $ConversationId))) {
                InvokeFrontRestMethod @Params
            }
    }
    catch {
        Write-Error -ErrorRecord $_
    }
}