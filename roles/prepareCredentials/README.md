prepareCredentials
=========

This role prepares all required credentials for the installation. It will create a file credentials.yaml  on the Ansible host if that does not yet exist and
use pwgen to create comparatively secure passwords. It will also make sure that an SSH key pair is in place and distribute this key pair to all nodes.

We will also create a set of certificates:

* a first self-signed CA certificate that the certificate generator of Octavia will use (octavia_ca.crt and octavia_ca.rsa)
* a second self-signed certificates that we will use during the installation process to create client certificates for the Octavia control plane (install_ca.crt and install_ca.rsa)
* a client_cert.pem file contaning a client certificate and the corresponding private key, signed with install_ca



Requirements
------------

Make sure that the pwgen utility is installed on the Ansible host and OpenSSL is installed

Role Variables
--------------

The following variables are assumed to be set when calling this role:

* ssh_key_name - this is the name which is used for the SSH key pair
* credentials_dir: the directory in which we store the credentials. It will be generated if it does not yet exist

Dependencies
------------

None


License
-------

MIT

Author Information
------------------

Visit me at https://www.github.com/christianb93
