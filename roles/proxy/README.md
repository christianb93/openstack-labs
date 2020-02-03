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


The NGINX configuration is straightforward, with two exceptions - the configuration for the VNC proy server and the catalog information. 

## Configuring the VNC proxy

When a Horizon client uses the noVNC proxy and connects on port 6080, it will initiate the connection as HTTP and then perform an upgrade of the connection to a WebSocket connection. As explained [here](http://nginx.org/en/docs/http/websocket.html), this requires that the proxy passes the Upgrade header and the connection header and uses HTTP version 1.1. In addition, the WebSocket handshake requires the HTTP headers *Host* and *Origin* to be set. 

There is an additional twist with these header fields if we terminate the SSL connection on the NGINX proxy and connect to the noVNC proxy via plain HTTP/WS. In this case, the connection info that is buried in the token is compared to the protocol in the *Origin* header fields by the noVNC proxy (see [here](https://github.com/openstack/nova/blob/4bdecee385ccf68b1b27ae9ead9a72861ea6cc8d/nova/console/websocketproxy.py#L220)) so that we need to make sure that these two protocols match. Note that the token is in fact stored in the database table *console_auth_token* where we can nicely see that it contains, in the field *access_url_base*, the base URL that we have configured on the compute node!

Thus an example for a NGINX configuration for this part looks as follows.


```
server {
  listen 6080 ssl;
  ssl_certificate         /etc/nginx/certs/server.crt;
  ssl_certificate_key     /etc/nginx/certs/server.rsa;  
  location / {
    proxy_bind                  {{mgmt_ip}};
    proxy_pass                  http://controller:6080;
    proxy_request_buffering     off;
    proxy_http_version          1.1;
    proxy_set_header            Upgrade $http_upgrade;
    proxy_set_header            Connection "upgrade";
    proxy_set_header            Host {{mgmt_ip}};
    proxy_set_header            Origin https://{{mgmt_ip}};
  }
}
```

## Handling catalog entries

When the OpenStack client is used to connect, the only URL which it initially has is the link to the Keystone service. From Keystone, it will then obtain a token and a list of service endpoints and use those endpoints for the actual request. 

Now, Keystone does not know that it is behind a proxy. Therefore, it will return the management IP plus the respective port number as a service endpoint, which the client cannot reach. To fix this, we use the *sub_filter* NGINX module which allows us to replace a certain string - in this case the hostname of the controller - by the IP on which the proxy server is running. Thus the client will always receive the public IP of the proxy server as the respective endpoint and use that to submit the next request.




