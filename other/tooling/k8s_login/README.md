These scripts will allow the user to login to a kubernetes cluster by authentication through Keycloak.

Requirements:
- Python 3.8 +
- jq
- kubectl
- wslu (if you are running **WSL2**)(https://wslutiliti.es/wslu/install.html)

To install the scripts run:
```
./install.sh
```

**Attention**: This will prompt the user to install python packages on the global environment, this is required for the python script to run properlly. You have the choice of installing manually afterwards if you wish so.

After installing the script will output a command that you should run in order to make the login command available:
```
source <home_folder>/.kube/scripts/k8s_login/k8s_login.sh
```

You should now be able to run the k8s_login command:
```
k8s_login <cluster-name>
ex:. k8s_login eks-dev
```

**Note**: If you want to make the command available everytime you startup the shell you should add the outputed command in the install script to your shell rc file (.bashrc or .zshrc or any other shell you might use).

## Upgrade

In order to uprade the script you just need to pull the changes from git and run the `./install.sh` again and run the outputed command.

## Caveats

When you run the `k8s_login` the final step will override the current proxy exceptions (`no_proxy` and `NO_PROXY`) with the cluster enpoint, so if you had any exceptions before, you need to readd them after the login.
