mariaDB
=========

This role installs MariaDB, creates a configuration file and changes the MariaDB root password.

Requirements
------------

We need the file credentials.yaml and the SSH key present on the Ansible host

Role Variables
--------------

The following variable needs to be set when calling this role.

mariadb_server_ip: the IP on which the server will be listening
mariadb_root_password: the root password that we will set for the local root user once installation is complete

Dependencies
------------

None


License
-------

MIT

Author Information
------------------

Visit me at https://www.github.com/christianb93
