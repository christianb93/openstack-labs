#!/bin/bash
#
# Wait until the port lb_port is present on the bridge, 
# then figure out the VLAN ID of the load balancer network
# and set the tag on the port accordingly
#
found=$(sudo ovsdb-client dump  unix:/var/run/openvswitch/db.sock Open_vSwitch Port name tag | grep "lb_port")
while [ "$found" == "0" ]; do
  sleep 1 
done
# The port is there - get VLAND id
vlan_id=$({{install_user_home}}/get_vlan_id.sh)
# and update port
sudo ovs-vsctl set port lb_port tag=$vlan_id 
echo "update_lb_port_tag.sh: set tag $vlan_id on load balancer port"