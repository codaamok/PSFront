function New-FrontTag {
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
        [String]$Name,

        [Parameter()]
        [ValidateSet("Grey", "Pink", "Red", "Orange", "Yellow", "Green", "Light-Blue", "Blue", "Purple")]
        [String]$Highlight,

        [Parameter()]
        [Bool]$IsVisibleInConversationLists,

        [Parameter(Mandatory)]
        [SecureString]$ApiKey
    )

    $Params = @{
        Method   = "POST"
        Endpoint = "tags"
        Body     = @{
            name = $Name
        }
        ApiKey   = $ApiKey
    }

    if ($PSBoundParameters.ContainsKey("Highlight")) {
        $Params["Body"]["highlight"] = $Highlight.ToLower()
    }

    if ($PSBoundParameters.ContainsKey("IsVisibleInConversationLists")) {
        $Params["Body"]["is_visible_in_conversation_lists"] = $IsVisibleInConversationLists
    }
    
    try {
        InvokeFrontRestMethod @Params
    }
    catch {
        Write-Error -ErrorRecord $_
    }
}