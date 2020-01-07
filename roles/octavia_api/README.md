octavia_api
=========

This role install the Octavia API server, typically on a controller node.  We

* create an octavia Keystone user
* create an Octavia database and a corresponding user
* create services and endpoints
* install the octavia-api package 
* populate the database
* change the default configuration and restart the service

The following changes are made to the default configuration:

* set the URL for the RabbitMQ interface
* change the *bind_host* variable to the management IP of the node on which we are running
* change the auth strategy to keystone
* only expose the v2 API
* change the values in the auth_token section 
* set a topic name in oslo_messaging
* in the service_auth section, configure the authentication data that Octavia will use to communicate with other services (though this is apparantly not really needed by the API service itself)
* set amphora driver, compute driver and network driver (the reason we need this here is that the API server will already ask the network driver to allocate a VIP port, and if the noop driver is still set, this port is later not found by the controller)

Requirements
------------

None

Role Variables
--------------

The following variables need to be set when calling this role.

* db_node - name of the node on which the database is running
* api_node - the node on which Keystone is running
* memcached_node - node on which the memcached server is running
* mariadb_root_password - root password for the database
* octavia_db_user_password - a password that we will use for the octavia DB user
* keystone_admin_password - the Keystone admin password
* octavia_keystone_user_password - a password for the new octavia user in Keystone
* mq_node - the node on which RabbitMQ is running
* rabbitmq_password - password of the RabbitMQ user


Dependencies
------------

None


License
-------

MIT

Author Information
------------------

Visit me at https://www.github.com/christianb93
