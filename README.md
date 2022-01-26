# Deploying a Kubernetes Cluster with Terraform and Ansible

### Terraform
In progress

### Ansible
This is an Ansible role to deploy a Kubernetes cluster on Ubuntu, which performs the following tasks:

- Update the Ansible inventory file
- Add the public key to the nodes
- Install Kubernetes, and Docker on each node
- Configure the Master node
- Join the Worker node(s) to the cluster
- Cleanup

I wanted to make this process as automated as possible with no manual input during the handoff from Terraform to Ansible. I have a play in the kubernetes.yaml playbook file to update the Ansible inventory with the Master, and Worker node information, including the ansible_user, and ansible_password parameters. This allowed me to connect to the instances, and copy over the public key for future authentication. 

I will be lookingt o implement a cleanup to remove the ansible_password parameter as it is no longer required.
