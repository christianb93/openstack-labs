labHost
=========

This role prepares a remote host to be able to install and run our labs. The following installation steps are carried out:

* Install all packages which are required to build kernel modules, i.e. gcc, make, perl and the Linux headers
* Install virtualbox-dkms and virtualbox, which will also build the Virtualbox kernel modules
* Install Vagrant, Ansible, Git and the APT Cache apt-cacher-NG

Requirements
------------

None

Role Variables
--------------

None




Dependencies
------------

We assume that a user stack exists on the remote machine.

License
-------

MIT

Author Information
------------------

Visit me at https://www.github.com/christianb93
