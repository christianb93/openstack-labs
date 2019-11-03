prepareCredentials 
=========

This role prepares all required credentials for the installation. It will create a file credentials.yaml in the playbook directory on the Ansible host if that does not yet exist and
use pwgen to create comparatively secure passwords. It will also make sure that an SSH key pair is in place and distribute this key pair to all nodes.

Note that all generated files will be placed in the main playbook directory

Requirements
------------

Make sure that the pwgen utility is installed on the Ansible host.

Role Variables
--------------

The following variables are assumed to be set when calling this role:

ssh_key_name - this is the name which is used for the SSH key pair

Dependencies
------------

None


License
-------

MIT

Author Information
------------------

Visit me at https://www.github.com/christianb93
