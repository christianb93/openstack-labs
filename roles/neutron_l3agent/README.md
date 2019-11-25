neutron_l3agent
================

This role installs the neutron-l3-agent package on a controller node. We then modify the default configuration file coming with the package and change the following values:

* section default, interface_driver is set to openvswitch
* disable the metadata proxy by setting enable_metadata_proxy to false as we use the DHCP agent to provide the necessary route



Requirements
------------

None

Role Variables
--------------

None



Dependencies
------------

None


License
-------

MIT

Author Information
------------------

Visit me at https://www.github.com/christianb93
