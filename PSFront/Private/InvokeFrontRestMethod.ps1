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

        [Parameter()]
        [SecureString]$ApiKey
    )

    $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($ApiKey)

    if (-not ("System.Web.HttpUtility" -as [Type])) {
        Add-Type -AssemblyName "System.Web" -ErrorAction "Stop"
    }

    $Params = @{
        Method        = $Method
        URI           = "{0}/{1}" -f $URL, $Endpoint
        Headers       = @{
            "Authorization" = "Bearer {0}" -f [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
        }
        ContentType   = "application/json"
        ErrorAction   = "Stop"
        ErrorVariable = "InvokeRestMethodError"
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

    $Result = do {
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
                            $Params['Url']
                        )
                    }
                    "BadRequest|Conflict" {
                        $Exception = [System.ArgumentException]::new($ExceptionMessage)
                        $ErrorRecord = [System.Management.Automation.ErrorRecord]::new(
                            $Exception,
                            $ErrorId,
                            [System.Management.Automation.ErrorCategory]::InvalidArgument,
                            $Params['Url']
                        )
                    }
                    "NotFound" {
                        $Exception = [System.Management.Automation.ItemNotFoundException]::new($ExceptionMessage)
                        $ErrorRecord = [System.Management.Automation.ErrorRecord]::new(
                            $Exception,
                            $ErrorId,
                            [System.Management.Automation.ErrorCategory]::ObjectNotFound,
                            $Params['Uri']
                        )
                    }
                    "ServiceUnavailable" {
                        $Exception = [System.InvalidOperationException]::new($ExceptionMessage)
                        $ErrorRecord = [System.Management.Automation.ErrorRecord]::new(
                            $Exception,
                            $ErrorId,
                            [System.Management.Automation.ErrorCategory]::ResourceUnavailable,
                            $Params['Uri']
                        )
                    }
                    default {
                        $Exception = [System.InvalidOperationException]::new($ExceptionMessage)
                        $ErrorRecord = [System.Management.Automation.ErrorRecord]::new(
                            $Exception,
                            $ErrorId,
                            [System.Management.Automation.ErrorCategory]::InvalidOperation,
                            $Params['Uri']
                        )
                    }
                }

                $PSCmdlet.ThrowTerminatingError($ErrorRecord)
            }
            else {
                $PSCmdlet.ThrowTerminatingError($_)
            }
        }

        Write-Output $Data._results
    } until ([String]::IsNullOrWhiteSpace($Data._pagination.next))

    Write-Output $Result

    [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($BSTR)
}