horizon
=========

This role installs Horizon and is meant to be executed on the controller node.  After installing the Ubuntu Horizon package, there are a couple of changes we need to make to the configuration (which is actually a Python code snippet called local_settings.py). 

* we first set the list ALLOWED_HOSTS from which connections are accepted to "*" to allow incoming connections from every IP address (which is of course not a good in any non-playground setting)
* we adjust the OpenStack API versions that the Horizon application will use to talk to the individual OpenStack services 
* we enable support for several domains 
* we set the default domain to "default"
* we adjust the URL that Horizon will use to contact Memcached to store session data and the set the session engine
* we set the OpenStack host to be the local host (this is the host where Horizon will look for Keystone)
* set the default role that Keystone will use to create new users to member
* adapt the structure OPENSTACK_NEUTRON_NETWORK: disable all layer 3 features (we only have a layer 2 network at the moment)




Requirements
------------

None

Role Variables
--------------

The following variables need to be set when calling this role.

* horizon_physical_networks - a  list of physical networks in Python syntax, like ['net1', 'net2']. Needs to match the actual configuration of the OVS agent
* horizon_supported_network_types - a similar list of supported network types, like flat, local, vlan, gre, .. Again this needs to match the Neutron configuration (type drivers)
* memcached_node - name of the node on which memcached is running 
* api_node - the name of the node on which Keystone is running

For the following variables, default values are set:

* horizon_enable_router - whether to enable router related functionality in the dashboard


Dependencies
------------

None


License
-------

MIT

Author Information
------------------

Visit me at https://www.github.com/christianb93
