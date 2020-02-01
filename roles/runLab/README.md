labHost
=========

This role will actually run a lab on a prepared host. 

* Clone the repository
* Bring up the Vagrant environment 


Requirements
------------

None

Role Variables
--------------

* lab - the name of the lab to run, e.g. Lab6
* run_demo - boolean, also run demo.yaml, of course this only works if you select a lab which contains a demo


Dependencies
------------

We assume that a user stack exists on the remote machine and that all required software is installed. Note that this is not hard-coded as dependency to allow users to use this role standalone without installing additional software on the lab host.

License
-------

MIT

Author Information
------------------

Visit me at https://www.github.com/christianb93
