#1/bin/bash
#
# Create the required VirtualBox network interfaces
#

#
# First delete all existing interfaces. This will only work if no machines
# using these interfaces are running
#
iflist=$(vboxmanage --nologo list hostonlyifs | egrep "^Name" | sed "s/Name://g")
for if in $iflist; do
  vboxmanage hostonlyif remove $if
done

#
# Now create two new interfaces. They will be called vboxnet0 and vboxnet1
#
vboxmanage hostonlyif create
vboxmanage hostonlyif create
#
# The first network (vboxnet0) will be our management interface. So we need to
# set the IP address to 192.168.1.0/24 and make sure that there is no DCHP server
#
vboxmanage hostonlyif ipconfig vboxnet0 --netmask 255.255.255.0 --ip 192.168.0.1
vboxmanage dhcpserver remove --netname HostInterfaceNetworking-vboxnet0


#
# The first network will be our VM network. We use the CIDR 172.16.0.0/24
# and disable DHCP as well
#
vboxmanage hostonlyif ipconfig vboxnet1 --netmask 255.255.255.0 --ip 172.16.0.1
vboxmanage dhcpserver remove --netname HostInterfaceNetworking-vboxnet1

#
# Create some output to be able to check that everything worked
#
vboxmanage list hostonlyifs
ip addr show dev vboxnet0
ip addr show dev vboxnet1
