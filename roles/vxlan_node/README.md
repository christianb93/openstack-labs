vxlan_node
=========

This role will create an OVS bridge and

* create a patch port on that bridge
* connect the patch port to an existing OVS patch port
* establish a VXLAN tunnel to a given remote host 


Requirements
------------

We assume the OVS is installed on the node on which we operate

Role Variables
--------------

The following variables need to be set when invoking this role:

* bridge_name - the name of the bridge that we create
* patch_port_local_name - the name of the local patch port that is created
* patch_port_peer_name - the name of the existing patch port to which we connect
* vxlan_peer - IP address of the VXLAN remote peer
* vxlan_id - the VXLAN ID (segmentation ID) that we use

Dependencies
------------

None


License
-------

MIT

Author Information
------------------

Visit me at https://www.github.com/christianb93
