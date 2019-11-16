Running the labs on DigitalOcean
--------------------------------------


This directory contains an Ansible playbook which can be used to bring up a lab environment on DigitalOcean. To use this playbook, you will have to prepare a couple of things.

* First, head over to the DigitalOcean console and get an API token. Then use `export DO_TOKEN=...`to put this token into the environment variable DO_TOKEN
* Next, we will need an SSH key pair. The public part of this key needs to be a key that has previously been uploaded to DigitalOcean and has been called *do-stack-key*. The standard location for this key that the scripts assume is *~/.ssh/do-stack-key* for the private part and *~/.ssh/do-stack-key.pub* for the public part.
* The scripts will create a user *stack* on the lab host. To be able to SSH into the lab host as this user, the scripts will also distribute the public key file of an SSH key pair to the lab host. The default is to use the same key as above, but you can override this by changing the attribute *userPrivateKeyFile* in *global_vars.yaml*
* In *global_vars.yaml*, change the variable *regionID* to the slug of the DigitalOcean region that you want to use


To run the script, simply navigate to the top level directory (in which this file is located) and run

``
ansible-playbook site.yaml
``

This will 

* use your DigitalOcean token to provision a machine using the slug *s-6vcpu-16gb*, i.e. a general purpose machine with 16 GB of RAM and 6 virtual CPUs. Be careful and do not forget to shut down the machine if it is no longer needed, this can easily become a bit costly!
* create a user *stack* on this machine
* install all required software like Ansible, Vagrant, Virtualbox and Git on the remote machine
* clone this GitHub repository on the remote machine
* run a lab. By default, Lab6 will be run, but you can change this by adapting *lab* in *global_vars.yaml*
* run the demo within the lab (unless you override this in *global_vars.yaml* by setting *run_demo* to False)

Once the installation is complete, the script will print a short message that tells you how to set up an SSH tunnel to the Horizon GUI on the lab host and displays the needed credentials (of course, this will only work if you chose a lab that contains Horizon).

If the SSH connection times out while trying to reach the remote machine for the first time, simply restart the script - this should work in most cases.

Note that the setup in this lab uses virtualiuzation on top of virtualization on top of a virtualized infrastructure, i.e. the OpenStack VM will run on a Virtualbox VM which in turn will run on a DigitalOcean VM. This is not the most efficient thing to do, and do not expect a breathtaking performance (the installation can easily take 45 min), but it is good enough for a playground.