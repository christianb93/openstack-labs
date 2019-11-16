placement
=========

This role installs the placement service on a node. The following configuration are done compared to the packaged version of the configuration files.

* we set the authorization strategy to keystone so that the Placement API services uses Keystone to authenticate incoming requests
* we supply the data in the section keystone_authtoken that placement needs to connect (URL, node on which memcached is running, credentials)
* we set the SQL connection string in the database section

Note that the placement service will be running on top of Apache2

Requirements
------------

This assumes that Keystone is present and running

Role Variables
--------------

The following variables need to be set when calling this role.

keystone_server_name - the name of node on which Keystone is running  
memcached_server_name - the name of the node on which memcached is running
mysql_server_name - the name of the node on which MySQL is running
keystone_admin_password - the password of the admin user in keystone
placement_db_user_password - password that we will use for the placement DB user
placement_keystone_user_password - the password that we will set for the placement user in Keystone

Dependencies
------------

None


License
-------

MIT

Author Information
------------------

Visit me at https://www.github.com/christianb93
