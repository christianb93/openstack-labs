nova
=========

This role installs the nova service on a compute node. The configuration for the compute service has two parts.

First, there is the file nova.conf that we also use on the controller node. The configuration is almost the same as on the control node, with two difference.

* as the nova-compute service does not connect directly to the MySQL database, we can comment out the DB connection settings
* In the section neutron, we not need the part refering to the proxy configuration, as the VNC proxy is running on the controller node only
* in the VNC section, we configure the settings for the VNC proxy (see below)

In addition to this file, there is a second configuration file which is relevant for the compute node - nova-compute.conf. This file contains two relevant setting - the virtualization driver (where we use the default, libvirt) and the virtualization type.


A few words on the configuration of the VNC proxy (see also https://docs.openstack.org/nova/latest/admin/remote-console-access.html), as this is a bit tricky and spread over several files on controller and compute nodes.

Libvirt has a nice feature that allows a virtual machine to present its screen as a VNC server. For every virtual machine started with this service, a VNC server process is started on the compute host to which a client can connect to access the screen.

Now in a typical setup, the IP address on which this server is listening is not accessible to the end user. To provide this connectivity, there is a **VNC proxy** which is typically running on the controller node on which the Nova API server is running as well. The VNC proxy is used to bridge VNC traffic between the private network and public network which the user can access. When a user wants to access an instance using a web-based VNC client like noVNC, OpenStack will create an URL pointing to the controller node. When the users client connects to this URL, this will in fact be a connection to the VNC proxy.

To make this work, you will need the following configuration.

* on the controller node, the VNC proxy needs to be installed and running
* on the compute node, the item *server_proxyclient_address* needs to be set to the management IP of the compute node. This is the address which the proxy server will connect to to actually establish the tunnel
* again on the compute node, the *novncproxy_base_url* must point to an IP address of the controller node (on which the proxy is running) which the end user can reach
* and finally, the *server_listen* attribute on the compute node determines on which IP address the actual VNC server will be listening

Requirements
------------

This assumes that Keystone is present and running and that the infrastructure components like MySQL and Rabbit are up and running

Role Variables
--------------

The following variables need to be set when calling this role.

* api_node - the name of node on which Keystone is running  
* memcached_node - the name of the node on which memcached is running
* mq_node - the name on which the RabbitMQ service is running
* neutron_keystone_user_password - the password of the neutron Keystone user
* rabbitmq_password - the password to use for the openstack user in RabbitMQ
* keystone_admin_password - the password of the admin user in keystone
* nova_db_user_password - password that we will use for the nova DB user
* nova_keystone_user_password - the password that we will set for the nova user in Keystone
* placement_keystone_user_password - the password of the placement Keystone user


For the following variable, we define a default within this role.

* virt_type - virtualization type to use, either kvm (preferred) or qemu (use this if your compute nodes do not support hardware acceleration).

Dependencies
------------

None


License
-------

MIT

Author Information
------------------

Visit me at https://www.github.com/christianb93
