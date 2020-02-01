droplet
=========

Create one or more droplets on DigitalOcean. In addition, this script will add the resulting droplets dynamically to the inventory and will create an SSH configuration file that is included in the main SSH configuration file ~/.ssh/config

Requirements
------------

This role assumes that the environment DO_TOKEN contains a valid DigitalOcean API token.

Role Variables
--------------

For the following variables, defaults are defined but can be overridden.

* doKeyName - the name of an SSH key known to DigitalOcean that we will use to log into the machines later
* doPrivateKeyFile - the file containing the private key for the key above
* targetState - present to bring up the droplet, absent to shut it down again
* machineCount - number of machines to provision
* osImage - the slug of the OS that we use
* regionID - the slug of the region 
* sizeID - the slug of the machine size
* doSSHConfigFile - the name of the SSH configuration file that we create 
* nameRoot - root part of the name of the machines. The machines will be called {{nameRoot}}0, {{nameRoot}}1 and so forth.

Dependencies
------------

None

License
-------

MIT

Author Information
------------------

Visit me on https://www.github.com/christianb93
