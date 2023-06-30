import sys, subprocess, pathlib
import json


from global_vars import *

kubectl_config_user = "keycloak_user"
kubectl_config_context = "keycloak_auth"

def check_cluster(cluster):
    # checks if the cluster the user is trying to login is a valid cluster
    clusters = {}
    file_path = pathlib.Path(__file__).parent.absolute()
    with open(file_path / "clusters.json", "r") as cluster_file:
        clusters = json.load(cluster_file)
    
    if not clusters.get(cluster, False):
        sys.exit("The cluster does not exist!")
    
    return clusters[cluster]


def set_cluster_data(cluster):
    # sets/updates the data of the wanted **valid** cluster on the kubeconfig file

    file_path = pathlib.Path(__file__).parent.absolute()

    kubectl_params = [
        "kubectl",
        "config",
        "set-cluster",
        f"{cluster['name']}",
        "--embed-certs",
        f"--certificate-authority={file_path / cluster['certificate-authority-data']}",
        f"--server={cluster['server']}"
    ]

    subprocess.run(kubectl_params)


def set_user_data(tokens):
    # sets/updates the login data of the user on the kubeconfig file
    kubectl_params = [
        "kubectl",
        "config",
        "set-credentials",
        f"{kubectl_config_user}",
        "--auth-provider=oidc",
        f"--auth-provider-arg=idp-issuer-url={KEYCLOAK_URL}/realms/{REALM}",
        f"--auth-provider-arg=client-id={CLIENT_ID}",
        f"--auth-provider-arg=refresh-token={tokens['refresh_token']}",
        f"--auth-provider-arg=id-token={tokens['id_token']}",
    ]

    subprocess.run(kubectl_params)


def set_context(cluster):
    # sets/updates a kubectl context to use the current cluster and the user on the kubeconfig file
    kubectl_params = [
        "kubectl", 
        "config", 
        "set-context", 
        kubectl_config_context, 
        "--cluster", 
        cluster['name'], 
        "--user", 
        kubectl_config_user
    ]
    subprocess.run(kubectl_params)


def use_context():
    # set the **current_context** to the configured context on the kubeconfig file
    kubectl_params = [
        "kubectl", 
        "config", 
        "use-context", 
        kubectl_config_context
    ]
    subprocess.run(kubectl_params)