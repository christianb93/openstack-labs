Running the labs on Packet
--------------------------------------


This directory contains an Ansible playbook which can be used to bring up a lab environment on Packet.net. To use this playbook, you will have to prepare a couple of things.

* First, you will have to use the Packet console to get an API token. Then use `export PACKET_API_TOKEN=...`to put this token into the environment variable PACKET_API_TOKEN
* Next, we will need an SSH key pair. The scripts will automatically upload this key to Packet and distribute it to the provisioned host so that we can log in as root. The standard location for this key that the scripts assume is *~/.ssh/packet-default-key* for the private part and *~/.ssh/packet-default-key.pub* for the public part. The key will be uploaded as *packet-default-key*
* The scripts will create a user *stack* on the lab host. To be able to SSH into the lab host as this user, the scripts will also distribute the public key file of an SSH key pair to the lab host. The default is to use the same key as above, but you can override this by changing the attribute *userPrivateKeyFile* in *global_vars.yaml*
* In *global_vars.yaml*, change the variable *packetFacilitySlug* to the slug of the Packet region that you want to use


To run the script, simply navigate to the top level directory (in which this file is located) and run

``
ansible-playbook site.yaml
``

This will 

* use your API token to provision a machine using the plan *x1.small.x86*, i.e. a general purpose machine with 32 GB of RAM and 8 CPU cores. Be careful and do not forget to shut down the machine if it is no longer needed, this can easily become a bit costly!
* create a user *stack* on this machine
* install all required software like Ansible, Vagrant, Virtualbox and Git on the remote machine
* clone this GitHub repository on the remote machine
* run a lab. By default, Lab6 will be run, but you can change this by adapting *lab* in *global_vars.yaml*
* run the demo within the lab (unless you override this in *global_vars.yaml* by setting *run_demo* to False)

Once the installation is complete, the script will print a short message that tells you how to set up an SSH tunnel to the Horizon GUI on the lab host and displays the needed credentials (of course, this will only work if you chose a lab that contains Horizon).

