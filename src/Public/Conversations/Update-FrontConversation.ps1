#TODO Need to do more here than just tags

function Update-FrontConversation {
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
        [Parameter(Mandatory)]
        [String]$ConversationId,

        [Parameter(Mandatory)]
        [String[]]$TagId,

        [Parameter(Mandatory)]
        [SecureString]$ApiKey
    )

    $Params = @{
        Method = "PATCH"
        Endpoint = "conversations"
        Path = $ConversationId
        Body = @{
            "tag_ids" = @($TagId)
        }
        ApiKey = $ApiKey
    }

    try {
        InvokeFrontRestMethod @Params
    }
    catch {
        Write-Error -ErrorRecord $_
    }
}