function InvokeFrontRestMethod {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [Microsoft.PowerShell.Commands.WebRequestMethod]$Method,

        [Parameter()]
        [String]$URL = "https://api2.frontapp.com",

        [Parameter(Mandatory)]
        [String]$Endpoint,

        [Parameter()]
        [String]$Path,

        [Parameter()]
        [hashtable]$Body,

        [Parameter()]
        [System.Collections.Specialized.NameValueCollection]$Query,

        [Parameter(Mandatory)]
        [SecureString]$ApiKey
    )

    if (-not ("System.Web.HttpUtility" -as [Type])) {
        Add-Type -AssemblyName "System.Web" -ErrorAction "Stop"
    }

    $Params = @{
        Method                  = $Method
        URI                     = "{0}/{1}" -f $URL, $Endpoint
        Headers                 = @{
            "Authorization" = "Bearer {0}" -f [PSCredential]::new("none", $ApiKey).GetNetworkCredential().Password
        }
        ContentType             = "application/json"
        ErrorAction             = "Stop"
        ErrorVariable           = "InvokeRestMethodError"
    }

    if ($PSBoundParameters.ContainsKey("Path")) {
        $Params["URI"] = "{0}/{1}" -f $Params["URI"], $Path
    }

    if ($PSBoundParameters.ContainsKey("Query")) {
        $Params["URI"] = "{0}?{1}" -f $Params["URI"], $Query.ToString()
    }

    if ($PSBoundParameters.ContainsKey("Body")) {
        $Params["Body"] = $Body | ConvertTo-Json
    }

    $Params["URI"] = [System.Web.HttpUtility]::UrlDecode($Params["URI"])

    do {
        Write-Verbose "Calling Front API"
        Write-Verbose ("URI: '{0}'" -f $Params["URI"])
        Write-Verbose ("Body: '{0}'" -f $Params["Body"])

        try {
            $Data = Invoke-RestMethod @Params
        }
        catch {
            # The web exception class is different for Core vs Windows
            if ($InvokeRestMethodError.ErrorRecord.Exception.GetType().FullName -match "HttpResponseException|WebException") {
                $ExceptionMessage = $InvokeRestMethodError.Message | 
                    ConvertFrom-Json | 
                    Select-Object -ExpandProperty "_error" |
                    Select-Object -ExpandProperty "message"
                    
                $ErrorId = "{0}{1}" -f 
                    [Int][System.Net.HttpStatusCode]$InvokeRestMethodError.ErrorRecord.Exception.Response.StatusCode, 
                    [String][System.Net.HttpStatusCode]$InvokeRestMethodError.ErrorRecord.Exception.Response.StatusCode

                switch -Regex ($InvokeRestMethodError.ErrorRecord.Exception.Response.StatusCode) {
                    "Unauthorized" {
                        $Exception = [System.UnauthorizedAccessException]::new($ExceptionMessage)
                        $ErrorRecord = [System.Management.Automation.ErrorRecord]::new(
                            $Exception,
                            $ErrorId,
                            [System.Management.Automation.ErrorCategory]::AuthenticationError,
                            $Params['Uri']
                        )
                        $PSCmdlet.ThrowTerminatingError($ErrorRecord)
                    }
                    "BadRequest|Conflict" {
                        $Exception = [System.ArgumentException]::new($ExceptionMessage)
                        $ErrorRecord = [System.Management.Automation.ErrorRecord]::new(
                            $Exception,
                            $ErrorId,
                            [System.Management.Automation.ErrorCategory]::InvalidArgument,
                            $Params['Uri']
                        )
                        $PSCmdlet.ThrowTerminatingError($ErrorRecord)
                    }
                    "NotFound" {
                        $Exception = [System.Management.Automation.ItemNotFoundException]::new($ExceptionMessage)
                        $ErrorRecord = [System.Management.Automation.ErrorRecord]::new(
                            $Exception,
                            $ErrorId,
                            [System.Management.Automation.ErrorCategory]::ObjectNotFound,
                            $Params['Uri']
                        )
                        $PSCmdlet.ThrowTerminatingError($ErrorRecord)
                    }
                    "ServiceUnavailable" {
                        $Exception = [System.InvalidOperationException]::new($ExceptionMessage)
                        $ErrorRecord = [System.Management.Automation.ErrorRecord]::new(
                            $Exception,
                            $ErrorId,
                            [System.Management.Automation.ErrorCategory]::ResourceUnavailable,
                            $Params['Uri']
                        )
                        $PSCmdlet.ThrowTerminatingError($ErrorRecord)
                    }
                    "TooManyRequests" {
                        [int]$Seconds = [int]$InvokeRestMethodError.InnerException.Response.Headers.GetValues("Retry-After")[0] + 1
                        Write-Verbose ("Exceeded number of requests allowed, will wait {0} second(s) until retrying" -f $Seconds)
                        Start-Sleep -Seconds $Seconds

                        $Params = @{
                            Method   = $Method
                            Endpoint = $Endpoint
                            ApiKey   = $ApiKey
                        }

                        if ($PSBoundParameters.ContainsKey("Path")) {
                            $Params["Path"] = $Path
                        }
                    
                        if ($PSBoundParameters.ContainsKey("Query")) {
                            $Params["Query"] = $Query
                        }
                    
                        if ($PSBoundParameters.ContainsKey("Body")) {
                            $Params["Body"] = $Body
                        }

                        return InvokeFrontRestMethod @Params
                    }
                    default {
                        $Exception = [System.InvalidOperationException]::new($ExceptionMessage)
                        $ErrorRecord = [System.Management.Automation.ErrorRecord]::new(
                            $Exception,
                            $ErrorId,
                            [System.Management.Automation.ErrorCategory]::InvalidOperation,
                            $Params['Uri']
                        )
                        $PSCmdlet.ThrowTerminatingError($ErrorRecord)
                    }
                }
            }
            else {
                $PSCmdlet.ThrowTerminatingError($_)
            }
        }

        if ($Params["URI"] -ne $Data._pagination.next) {
            # This could be null, depending if pagination is needed or not
            # Update the URI just in case the loop isn't finished yet
            $Params["URI"] = $Data._pagination.next
        }
        else {
            $Exception = [System.InvalidOperationException]::new("Pagination failure with Front API (the same URL was given for next page)")
            $ErrorRecord = [System.Management.Automation.ErrorRecord]::new(
                $Exception,
                $ErrorId,
                [System.Management.Automation.ErrorCategory]::OperationStopped,
                $Params['Uri']
            )
            $PSCmdlet.ThrowTerminatingError($ErrorRecord)
        }

        if ($Data._results) {
            Write-Output $Data._results
        }
        else {
            Write-Output $Data
        }
        
    } until ([String]::IsNullOrWhiteSpace($Data._pagination.next))

}