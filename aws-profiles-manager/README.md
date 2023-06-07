# AWS Custom Functions
All The functions we need for using aws.

This project contains some functions that may be handy for our daily use of aws.

Currently we have (at least):
| Function Name         | Usage                                                     | Description                                                                                                 |
| --------------------- | --------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------- |
| __aws_ps1             | __aws_ps1                                                 | prints out your profile 'name'.                                                                             |         
| aws_config_file_parse | aws_config_file_parse <config_path> <profile> [parameter] | prints the all the "key=value" or the value of the given parameter for the given profile on the given file. |         
| aws_profile_set       | aws_profile_set <profile>                                 | Sets your AWS_PROFILE and logs you into that.                                                               |         
| aws_profile_unset     | aws_profile_unset                                         | Logs You out of any aws sso session and unsets all the related environment variables.                       |         
| aws_profile_curr      | aws_profile_curr                                          | Prints out you environment variables and your aws sso session.                                              |         

