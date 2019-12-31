cinder_node
=========

This role installs the Cinder volume manager on a storage node


* remove the configuration items iscsi-helper, volume_name_template, volume_group from the default section as they are apparently not used anymore (and reappear in the lvm section) or have reasonable defaults



Requirements
------------

This assumes that Keystone is present and running

Role Variables
--------------

The following variables need to be set when calling this role.

* api_node - the name of node on which Keystone is running  
* db_node - the name of the node on which MySQL is running
* cinder_db_user_password - password that we will use for the cinder DB user
* cinder_keystone_user_password - the password that we will set for the cinder user in Keystone
* rabbitmq_password - the password of the RabbitMQ user
* mq_node - the node on which RabbitMQ is running
* memcached_node - name of the server on which memcached is running
* cinder_storage_device - the block device that Cinder will use - WARNING: any data on this device will be lost!




Dependencies
------------

None


License
-------

MIT

Author Information
------------------

Visit me at https://www.github.com/christianb93
