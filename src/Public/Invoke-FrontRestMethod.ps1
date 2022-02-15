function Invoke-FrontRestMethod {
    <#
    .SYNOPSIS
        Arbitrarily interact with Front's Core API.
    .DESCRIPTION
        Arbitrarily interact with Front's Core API. Since this function is for no particular endpoint in Front's API, this can be useful for occasions when Front have added a new endpoint, query or body parameter to their API specification and one of the other dedicated functions of PSFront have not yet been updated.
    .EXAMPLE
        PS C:\> Invoke-FrontRestMethod -Method GET -Endpoint tags -ApiKey $secret
        
        Lists all tags in Front: https://dev.frontapp.com/reference/tags-1#get_tags
    .EXAMPLE
        PS C:\> Invoke-FrontRestMethod -Method GET -Endpoint teams -Path "tim_2daq7/tags" -ApiKey $secret
        
        Lists all tags for the team with id tim_2daq7 in Front: https://dev.frontapp.com/reference/tags-1#get_teams-team-id-tags-1
    .INPUTS
        This function does not accept pipeline input.
    .OUTPUTS
        System.Management.Automation.PSObject
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [Microsoft.PowerShell.Commands.WebRequestMethod]$Method,

        [Parameter(Mandatory)]
        [String]$Endpoint,

        [Parameter()]
        [String]$Path,

        [Parameter()]
        [hashtable]$Body,

        [Parameter()]
        [hashtable]$Query,

        [Parameter(Mandatory)]
        [SecureString]$ApiKey
    )

    $Params = @{
        Method      = $Method
        Endpoint    = $Endpoint
        ApiKey      = $ApiKey
        ErrorAction = "Stop"
    }

    switch ($PSBoundParameters.Keys) {
        "Path" {
            $Params["Path"] = $Path
        }
        "Body" {
            $Params["Body"] = $Body
        }
        "Query" { 
            $QueryString = [System.Web.HttpUtility]::ParseQueryString('')

            foreach ($item in $Query.GetEnumerator()) {
                $QueryString.Add($item.Key, $item.Value)
            }

            $Params["Query"] = $QueryString
        }
    }

    try {
        InvokeFrontRestMethod @Params
    }
    catch {
        Write-Error -ErrorRecord $_
    }
}