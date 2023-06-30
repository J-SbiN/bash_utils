This repository holds scripts that facilitate the usage of the several tools that we use internally.

# AWS Login Tools
Tooling for the AWSCLI and for connection to kubernetes from AWS prespective.
- `aws_login` - SSO login to AWS and sets the profile globally
- `aws_change_profile` - Change the global AWS profile
- `aws_eks_login` - Sets the kubecontext with the AWS profile

# K8S Login
Tooling for connection to kubernetes from keycloak
- `k8s_login` - Connects to a kubernetes cluster with Keycloak OIDC.