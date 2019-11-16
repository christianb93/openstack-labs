defaultUser
=========

Create a user and distribute an SSH key. The user will have the sudo privilege without requiring a password.

Requirements
------------

None

Role Variables
--------------

For the following variables, defaults are defined but can be overridden.

userName - the name of the user that will be created
userPrivateKeyFile - the file name of a private key file. The script assumes that a matching public key files with extension *.pub* is present at the same location and will add this key to the *authorized_keys* of the newly created user.

Dependencies
------------

None

License
-------

MIT

Author Information
------------------

Visit me on https://www.github.com/christianb93
