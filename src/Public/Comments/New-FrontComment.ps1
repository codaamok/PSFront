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
        InvokeFrontRestMethod @Params
    }
    catch {
        Write-Error -ErrorRecord $_
    }
}