
import sys
from threading import Thread
import webbrowser

import requests

from global_vars import *
from k8s_config_funcs import (
    set_cluster_data,
    set_user_data,
    set_context,
    use_context,
    check_cluster
)

# --------------- SERVER -----------------------------
from bottle import run, route, ServerAdapter, request

# we kind of need to return a specific value to make the script check if the process went correctly, because the way this server is made, if the browser didn't return
# anything, you will need to CTRL-C, and for this server that is a "normal/success" shutdown, meaning that the rest of the script will run as if you would have logged in.
# As we only want the script to fully run when the browser actually return something we need to "hack" the return value to something very specific and check for it in the 
# script
FUGLY_RETURN = 0

class MyWSGIRefServer(ServerAdapter):
# This class only serves the purpose of extending the default server to handle its halt gracefully programmatically (basically adds the "stop()" function)
    server = None

    def run(self, handler):
        from wsgiref.simple_server import make_server, WSGIRequestHandler
        if self.quiet:
            class QuietHandler(WSGIRequestHandler):
                def log_request(*args, **kw): pass
            self.options['handler_class'] = QuietHandler
        self.server = make_server(self.host, self.port, handler, **self.options)
        self.server.serve_forever()

    def stop(self):
        global FUGLY_RETURN
        FUGLY_RETURN = 101
        self.server.shutdown()

# Create the server Object
server = MyWSGIRefServer(host="0.0.0.0", port=REDIRECT_PORT)


# Set the callback function that will handle the rest of the authentication
@route('/callback') 
def callback():
    print("Authentication Successfull!")
    Thread(target=server.stop).start() # this will "flag" the server to shutdown when it finishes the callback
    
    tokens = auth_with_code(request.params["code"])
    
    # setup the kubeconfig file with the necessary data to login to the desired cluster
    set_cluster_data(CLUSTER_INFO)
    set_user_data(tokens)
    set_context(CLUSTER_INFO)
    use_context()

    return "<h1>Login Complete!</h1><br/><br/><h3>You can now close this Tab.</h3>"
# --------------- SERVER -----------------------------


# --------- KEYCLOAK AUTHENTICATION CODE FLOW --------
# This function requests the refresh and ID tokens from the keycloak with the previous obtain Authentication code
def auth_with_code(code):
    headers = {
        "Content-Type": "application/x-www-form-urlencoded"
    }
    body = {
        "client_id": "eks_k8s_cluster",
        "grant_type": "authorization_code",
        "code": code,
        "redirect_uri": f"{REDIRECT_ADDRESS}:{REDIRECT_PORT}/callback"
    }
    
    url = f"{KEYCLOAK_URL}/realms/{REALM}/protocol/openid-connect/token"
    res = requests.post(url=url, data=body, headers=headers)

    return res.json()
# --------- KEYCLOAK AUTHENTICATION CODE FLOW --------


def main():
    redirect_uri = f"{REDIRECT_ADDRESS}:{REDIRECT_PORT}/callback"

    # open browser to perform login
    print("Redirecting to the browser ...")
    url = f"{KEYCLOAK_URL}/realms/{REALM}/protocol/openid-connect/auth?scope=openid&client_id={CLIENT_ID}&response_type=code&redirect_uri={redirect_uri}"
    webbrowser.open(url)

    # start the server that waits for the authentication code callback
    try:
        run(server=server, quiet=True)
    except Exception as ex:
        print(ex)

    sys.exit(FUGLY_RETURN)


if __name__ == "__main__":
    if len(sys.argv) > 1:
        CURRENT_CLUSTER = sys.argv[1]

    # get and set cluster relevant information
    CLUSTER_INFO = check_cluster(CURRENT_CLUSTER)
    KEYCLOAK_URL = CLUSTER_INFO["auth_server"]
    REALM = CLUSTER_INFO["realm"]
    print(f"Authenticating against {CLUSTER_INFO['name']} cluster")
    main()
    