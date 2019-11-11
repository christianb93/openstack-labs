Connecting to the Horizon GUI
==================================


When you run this lab on a remote machine, for instance in a cloud environment, and you want to connect from your local PC to the Horizon GUI, you can create an **SSH tunnel** to do this. For this purpose, enter 


``
ssh -i ~/.ssh/private_key_file user@lab_host -L 2080:192.168.1.11:80
``

where *private_key_file* is the private SSH key, *user* is your user on the lab host and *lab_host* is the lab host. Then, point your browser to localhost:2080/horizon to access the dashboard.

Note that we need to use 192.168.1.11 as the remote address, as this is the address on which the Dashboard will be listening, not 127.0.0.1 and not the IP address under which you reach the lab host.




 
