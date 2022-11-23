
# proxy aid functions


### VARIABLES ###
#################
[string]$default_proxy="eu"
$unset_flag=$false
[string]$proxy_alias=$args[0]





### FUNCTIONS ###
#################

function _print_help_set_proxy () {
    Write-Host
    Write-Host "Maybe this can help:"
    Write-Host
    Write-Host "    USAGE:    _set_proxy < <available-options> | <unset> | <help> >"
    Write-Host
    Write-Host "    DESCRIPTION:"
   
}
function _set_proxy_environment_variables ($proxy_to_be_set) {
    $env:http_proxy  = "${proxy_to_be_set}"
    $env:https_proxy = "${proxy_to_be_set}"
    $env:HTTP_PROXY  = "${proxy_to_be_set}"
    $env:HTTPS_PROXY = "${proxy_to_be_set}"
    $http_proxy      = "${proxy_to_be_set}"
    $https_proxy     = "${proxy_to_be_set}"
    $HTTP_PROXY      = "${proxy_to_be_set}"
    $HTTPS_PROXY     = "${proxy_to_be_set}"
    Write-Host "Your current proxy was set to ${proxy_to_be_set} ."
}

function _unset_proxy_environment_variables () {
    $env:http_proxy  = ""
    $env:https_proxy = ""
    $env:HTTP_PROXY  = ""
    $env:HTTPS_PROXY = ""
    $http_proxy      = ""
    $https_proxy     = ""
    $HTTP_PROXY      = ""
    $HTTPS_PROXY     = ""
    Write-Host "Your proxy environment variables were set to 'void'."
}

function _get_proxy_curr_variables () {
    Write-Host "Here are your current proxy environment variables:"
    gci env: | Select-String -Pattern "^\[(http|HTTP)(s|S)?_(proxy|PROXY), .*$"
    Get-Variable | Where {$_.Name -cmatch "^(http|HTTP)(s|S)?_(proxy|PROXY)$" }
}



##################################
###                            ###
###   M A I N   S C R I P T S  ###
###                            ###
##################################

function _set_proxy () {
    Param(
        [Parameter(Mandatory=$false)]
        [ValidateSet("pt", "eu", "ge", "glob", "unset", "help")]
        [string]$proxy_alias
    )

    if ( [string]::IsNullOrWhiteSpace(${proxy_alias}) ) {
        Write-Host "[WARN]: No proxy argument provided."
        [string]$proxy_to_be_set=$default_proxy
        Write-Host "[INFO]: Using default: ${proxy_to_be_set}"
    }

    Switch ( "${proxy_alias}" ) {
        "pt" {
            Write-Host "Using Proxy: ${proxy_alias}"
            $unset_flag=$false
            $proxy_to_be_set="http://proxy-pt.global.gls:8080"
            Break
        }
        "eu" {
            Write-Host "Using Proxy: ${proxy_alias}"
            $unset_flag=$false
            $proxy_to_be_set="http://proxy.gls-group.eu:8080"
            Break
        }
        "ge" {
            Write-Host "Using Proxy: ${proxy_alias}"
            $unset_flag=$false
            $proxy_to_be_set="http://proxy.nst.gls-germnay.com:8080"
            Break
        }
        "glob" {
            Write-Host "Using Proxy: ${proxy_alias}"
            $unset_flag=$false
            $proxy_to_be_set="http://proxy.global.gls:8080"
            Break
        }
        "unset" {
            $unset_flag=$true
            Break
        }
        "help" {
            _print_help_set_proxy
            return
        }
        default {
            Write-Error "[ERROR]: I do not know that proxy.";
            Write-Host "[Info]: Nothing Done... Exiting.";
            return
        }
    }

    if ( $unset_flag ) {
        _unset_proxy_environment_variables
    } else {
        _set_proxy_environment_variables "${proxy_to_be_set}"
    }

    _get_proxy_curr_variables
}
