Creating an Octavia load balancer image
=========================================

We do a build in a Docker container in order to avoid pollution of the local Python environment, however, a cache on the host machine is used. To create the image, enter the following commands (from the directory in which this file is located) to create the cache directory (be careful, files in this directory will be owned by root), build the Docker image and run it to perform the actual image creation. 

```
mkdir .cache
(cd amphora ; docker build -t os .)
docker run -it -v $(pwd):/lab --privileged os
```
Once this completes, an image should be present in the lab directory, called *amphora-x64-haproxy.qcow2*

Instructions for the build were taken from:

https://docs.openstack.org/octavia/latest/admin/amphora-image-build.html
