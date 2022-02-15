#TODO Finish implementing the other search criteria in the query parameter

function Find-FrontConversation {
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
        [Parameter()]
        [String[]]$InboxId,

        [String[]]$Keyword,

        [Parameter()]
        [String[]]$Recipient,

        [Parameter()]
        [String[]]$From,

        [Parameter()]
        [String[]]$To,

        [Parameter()]
        [String[]]$CC,

        [Parameter()]
        [String[]]$BCC,

        [Parameter()]
        [String[]]$TagId,

        [Parameter()]
        [String[]]$TopicId,

        [Parameter()]
        [String[]]$Contact,

        [Parameter()]
        [String[]]$Participant,

        [Parameter()]
        [String[]]$Assignee,

        [Parameter()]
        [String[]]$Author,

        [Parameter()]
        [String[]]$Mention,

        [Parameter()]
        [String[]]$Commenter,

        [Parameter()]
        [String[]]$Status,

        [Parameter()]
        [String[]]$Date,

        [Parameter(Mandatory)]
        [SecureString]$ApiKey
    )

    [System.Collections.Generic.List[String]]$Query = @()

    switch ($PSBoundParameters.Keys) {
        "Keyword" {
            foreach ($item in $Keyword) {
                $Query.add('"{0}"' -f $item)
            }
        }
        "InboxId" {
            foreach ($item in $InboxId) {
                $Query.add("inbox:{0}" -f $item)
            }
        }
        "TagId" {
            foreach ($item in $TagId) {
                $Query.add("tag:{0}" -f $item)
            }
        }
        "TopicId" {
            foreach ($item in $TopicId) {
                $Query.add("topic:{0}" -f $item)
            }
        }
        "Contact" {
            foreach ($item in $Contact) {
                $Query.add("contact:{0}" -f $item)
            }
        }
        "Status" {
            foreach ($item in $Status) {
                $Query.add("is:{0}" -f $item)
            }
        }
        "Recipient" {
            foreach ($item in $Recipient) {
                $Query.add("recipient:{0}" -f $item)
            }
        }
        "From" {
            foreach ($item in $From) {
                $Query.add("from:{0}" -f $item)
            }
        }
        "To" {
            foreach ($item in $To) {
                $Query.add("to:{0}" -f $item)
            }
        }
        "CC" {
            foreach ($item in $CC) {
                $Query.add("cc:{0}" -f $item)
            }
        }
        "BCC" {
            foreach ($item in $BCC) {
                $Query.add("bcc:{0}" -f $item)
            }
        }
    }

    $Params = @{
        Method = "GET"
        Endpoint = "conversations"
        Path = "search/{0}" -f [String]::Join(" ", $Query)
        ApiKey = $ApiKey
    }

    try {
        InvokeFrontRestMethod @Params
    }
    catch {
        Write-Error -ErrorRecord $_
    }
}