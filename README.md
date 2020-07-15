# The COMPSs runtime on different Computing Infrastructures

This section presents how to run a preliminary version of an EDDL training operation in two different computing environments, demonstrating the heterogeneous capabilities of COMPSs. The demonstrators presented here have been executed on a Linux Ubuntu 18.04.

## 4.1.1 COMPSs in a Linux-based Infrastructure

1. Install Docker and docker-compose in your own computing resource. The one provided in this deliverable has been tested with Docker version 19.03.7, build 7141c199a2, Ubuntu 18.04.
2. Pull the demonstrator image by running: `docker pull bscppc/compss-deephealth-demo`
3. Download the docker-compose.yml file provided and store it in a separate directory named deephealth: `git clone https://github.com/deephealthproject/docker-compss-runtime`
4. Run: `docker-compose up -d --scale compss-worker=4`. This will deploy five containers, four of which will take on the role of COMPSs workers, while the remaining will be used as the COMPSs master.
5. Access the COMPSs master container by running: `docker exec -it deephealth_compss-master_1 bash`. This will open a bash session inside the container, in the directory with the EDDL application and the needed COMPSs configuration options.
6. Enter the pyeddl directory: `cd pyeddl/third_party/compss_runtime`
7. Launch COMPSs by running the following command: `runcompss --lang=python --python_interpreter=python3 –project=linux-based/project.xml --resources=linux-based/resources.xml eddl_train_batch_compss.py`
8. Once the application finishes correctly, the COMPSs master container can be exited. The containers can be destroyed by running, in the same directory: `docker-compose down -v`

## COMPSS in a cloud

1. Follow steps 1 and 2 of previous section.
2. Make sure that kubectl, openvpn and curl package are installed in your Linux environment: curl is generally present in all Linux distributions; kubectl can be installed through the universal package manager snap, and openvpn can be obtained through the default package manager of the operating system, such as apt.
3. Download the files required for the VPN connection into a separate folder (see in the comments attached to this deliverable how to get these files and the credentials; this information has not been included here for security reasons). In a terminal, run the following command, to connect the VPN: `sudo openvpn --script-security 2 --config ./infierno-TCP-1199-deephealth.ovpn`
4. Download the configuration files by executing the following command: `git clone https://github.com/deephealthproject/docker-compss-runtime`
5. A container must be deployed in the cluster, which will play the role of the COMPSs master. This can be done by running the provided script: `./deploy_master.sh`, which communicates with the API developed by TREE. The script will fail if the container exists, but the next steps can be followed nevertheless.
6. Disconnect from the VPN. 
7. Copy the provided kubeconfig configuration file in a separate, empty folder. Use kubectl, along with the aforementioned configuration file, to access the newly created COMPSs master, by running the following command: `KUBECONFIG=kubeconfig kubectl exec -it compss-master -- /bin/bash`
8. Inside the COMPSs master container, go to pyeddl/third_party/compss_runtime directory and launch the execution by running the following command: `runcompss --lang=python --python_interpreter=python3 --project=cloud/project.xml --resources=cloud/resources.xml --conn=es.bsc.compss.connectors.DefaultNoSSHConnector --master_name=$(hostname -I) eddl_train_batch_compss.py`