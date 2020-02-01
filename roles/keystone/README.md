keystone
=========

This role installs Keystone on a node. We then modify the default configuration file coming with the package and change the following values:

* section database, key connection: this will be adjusted to point to a MySQL database running on {{db_node}} and use the DB password {{keystone_db_user_password}}


We also adapt the Apache2 configuration and set the Apache2 server name to the {{inventory_hostname}}, so make sure that this name is valid and resolves to the correct host. Finally, we create a service project in keystone which can be used to register other OpenStack services. 

Requirements
------------

None

Role Variables
--------------

The following variables need to be set when calling this role.

* db_node: name of the MySQL server that Keystone will use
* keystone_db_user_password - this password will be used when we create the keystone DB user
* OS_ADMIN_PASSWORD - this will initially be used as the Keystone admin password




Dependencies
------------

None


License
-------

MIT

Author Information
------------------

Visit me at https://www.github.com/christianb93
