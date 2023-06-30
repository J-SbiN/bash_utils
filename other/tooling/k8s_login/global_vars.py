# ------------------------ GLOBALS --------------------
# Easy way to pass information around (don't do this in serious programs)
KEYCLOAK_URL = ""
REALM = ""
CLUSTER_INFO = {}
CLIENT_ID = "eks_k8s_cluster"
REDIRECT_ADDRESS = "http://localhost" # This is the local server address that sets the callback
REDIRECT_PORT = 43234 # local server port
CURRENT_CLUSTER = ""