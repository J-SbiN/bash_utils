# AWS aid functions


### VARIABLES ###
#################
[string]$default_profile="gls_sb005"
$unset_flag=$false
$profile_to_be_set=$args[0]





### FUNCTIONS ###
#################

function _print_help_set_aws_profile () {
    Write-Host
    Write-Host "Maybe this can help:"
    Write-Host
    Write-Host "    USAGE:    _set_aws_profile  < <aws-profile> | <unset> | <help> >"
    Write-Host
    Write-Host "    DESCRIPTION:"
    Write-Host "        This will set environment variables to any of your already configured aws profiles and then log in using that profile."
    Write-Host "        To Configure the profiles use the standard aws configurations ('$env:USERPROFILE\.aws\config' and '$env:USERPROFILE\.aws\credentials')"
    Write-Host "        The parameter will autocomplete according to your profiles."
    Write-Host "        You can use 'unset' to log out and clear all the variables that were set."
    Write-Host "        At each success lo log in/out the function querys aws just to be sure!..."
    Write-Host "        If you use no argument the parameter defaults to $default_profile"
}
function _set_aws_environment_variables ($profile_to_be_set) {
    $env:AWS_PROFILE         = "${profile_to_be_set}"
    $env:aws_profile         = "${profile_to_be_set}"
    $env:AWS_DEFAULT_PROFILE = "${profile_to_be_set}"
    $env:aws_default_profile = "${profile_to_be_set}"
    $AWS_PROFILE             = "${profile_to_be_set}"
    $aws_profile             = "${profile_to_be_set}"
    $AWS_DEFAULT_PROFILE     = "${profile_to_be_set}"
    $aws_default_profile     = "${profile_to_be_set}"
    Write-Host "Your AWS Profile was set to ${profile_to_be_set} ."
}

function _unset_aws_environment_variables () {
    $env:AWS_PROFILE         = ""
    $env:aws_profile         = ""
    $env:AWS_DEFAULT_PROFILE = ""
    $env:aws_default_profile = ""
    $AWS_PROFILE             = ""
    $aws_profile             = ""
    $AWS_DEFAULT_PROFILE     = ""
    $aws_default_profile     = ""
    Write-Host "Your AWS environment variables were set to 'void'."
}

function _get_aws_curr_profile_information () {
    Write-Host "Here are your current AWS environment variables:"
    gci env: | Select-String -Pattern "^\[(AWS|aws)_*"
    Get-Variable | Where {$_.Name -cmatch "^(aws|AWS)_*" }
    Write-Host
    Write-Host "Your current AWS login is:"
    aws sts get-caller-identity
}


function _get_aws_existing_profiles () {
    $existing_profiles = Get-Content "$env:USERPROFILE\.aws\config" | Select-String "^\[profile (.*)\]$" | ForEach-Object{$_.Matches.Groups[1].Value}
    return [string[]]$existing_profiles
}

function _get_aws_existing_profiles_regex () {
    $regex_prefix="^("
    $regex_sufix=")$"
    $profiles = _get_aws_existing_profiles
    $regex_body = "$profiles".Replace(' ', '|')
    $regex = -join($regex_prefix, $regex_body, $regex_sufix)
    return [string]$regex
}

# For dinamic argument tab completion (fetching profiles from your aws config file)
Class AvailableProfiles : System.Management.Automation.IValidateSetValuesGenerator {
    [string[]] GetValidValues() {
        $profiles_list = $(_get_aws_existing_profiles)
        $profiles_list += "unset"
        $profiles_list += "help"
        return [string[]] $profiles_list
    }
}



##################################
###                            ###
###   M A I N   S C R I P T S  ###
###                            ###
##################################

function _set_aws_profile () {
    Param(
        [Parameter(Mandatory=$false)]
        [ValidateSet([AvailableProfiles])]
        [string]$profile_to_be_set
    )

    if ( [string]::IsNullOrWhiteSpace(${profile_to_be_set}) ) {
        Write-Host "[WARN]: No profile argument provided."
        [string]$profile_to_be_set=$default_profile
        Write-Host "[INFO]: Using default: ${profile_to_be_set}"
    }

    Switch -regex ( "${profile_to_be_set}" ) {
        "$(_get_aws_existing_profiles_regex)" {
            Write-Host "Using AWS Profile: ${profile_to_be_set}"
            $unset_flag=$false
            Break
        }
        "^(null|unset|clear|reset)$" {
            $unset_flag=$true
            Break
        }
        "^(help|--help||\s)$" {
            _print_help_set_aws_profile
            return
            Break
        }
        default {
            Write-Error "[ERROR]: I do not know that profile.";
            Write-Host "[Info]: Nothing Done... Exiting.";
            return
        }
    }

    if ( $unset_flag ) {
        aws sso logout
        _unset_aws_environment_variables "${profile_to_be_set}"
    } else {
        _set_aws_environment_variables "${profile_to_be_set}"
        aws sso login
        if ( ! $? ) {
            Write-Warning "Login Failed."
            Write-Host "Loging out and clearing environment variables."
            aws sso logout
            _unset_aws_environment_variables "${profile_to_be_set}"
        }
    }

    _get_aws_curr_profile_information
}

#_set_aws_profile $args[0]