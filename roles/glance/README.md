glance
=========

This role installs Glance on a node. The following configuration items are changed compared to the packaged version of the configuration files.

In glance-api.conf:

* we will add the specific configuration for the Keystone service and memcached in the section keystone_authtoken
* set the deployment flavor to keystone in the paste_deploy section. This will be combined with the service name glance-api and be used as a lookup into the WSGI pipeline (i.e. the chain of middleware components that are called before the actual application code is invoked) configuration in /etc/glance/glance-api-paste.ini. This setting will make sure that as part of the pipeline, Keystone is used for authorization. Note that Glance is deployed in a standalone WSGI server, not on top of Apache2
* set the database connection string in the database section


In glance-registry.conf:

* set database connection
* set keystone_authtoken configuration as above
* set deployment flavor as above

We then use the glance-manage tool to sync the glance database scheme and restart the Glance service. Finally, we download and import the CirrOS image.

Requirements
------------

This assumes that Keystone is present and running

Role Variables
--------------

The following variables need to be set when calling this role.

* api_node: the name of the node on which Keystone is running
* db_node: name of the MySQL server that Glance will use
* memcached_node: name of the server on which memcached is running
* glance_db_user_password - this password will be used when we create the glance DB user
* keystone_admin_password - the password of the admin user in Keystone
* glance_keystone_user_password - the password that we will set for the Glance user in Keystone  
* install_user_home - the home directory of the user running the install

For the following variable, a default is defined.

* cirros_download_url - the URL from which we will try to download the CirrOS image.


Dependencies
------------

None


License
-------

MIT

Author Information
------------------

Visit me at https://www.github.com/christianb93
