proxy
=======

This role sets up a proxy server which proxies requests to the OpenStack API and Horizon running on the controller node. This proxy can run on any node which has a public interface, but is designed to be run on the network node. 

As prerequisites, make sure that

* on the node on which the proxy is running, the iptables setup allows traffic on the OpenStack API ports, the Horizon port (either 443 or 80, depending on your configuration) and the port 6080 for the noVNC proxy. If you run the *route* role on the network node, you can achieve this by adding these ports to *os_known_ports*
* if there are any external firewalls, then, of course, these ports need to be opened as well in that firewall's configuration
* on the compute nodes, the *nonvncproxy_base_url* needs to be set to point to the public IP of the node on which the proxy will be running (if you install using the *nova_compute* role, set *vnc_ip* accordingly)

The role will install NGINX and prepare a configuration file. This configuration will forward all OpenStack API ports plus the Horizon port and port 6080. 


The folowing variables need to be defined to use this role:

* mgmt_ip - the management IP address of the node
* os_known_ports - a list of OpenStack API ports, **not** including Horizon and port 6080
* proxy_public_ip - the IP address which we use as public address for incoming requests


The NGINX configuration is straightforward, with one exception - the configuration for the virtual server listening on port 6080. When a Horizon client uses the noVNC proxy, it will use this port and perform an upgrade of the connection to a WebSocket connection. As explained [here](http://nginx.org/en/docs/http/websocket.html), this requires that the proxy passes the Upgrade header and the connection header and uses HTTP version 1.1. In addition, the WebSocket handshake requires the HTTP headers *Host* and *Origin* to be set. 


