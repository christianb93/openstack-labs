#!/bin/bash
#
# Get the latest Ubuntu Bionic Box and resize it
#

#
# First make sure that we have the latest box
# and remove older boxes
#
vagrant box add "ubuntu/bionic64" 2>/dev/null
vagrant box update --box "ubuntu/bionic64"
vagrant box prune --name "ubuntu/bionic64"


#
# Now do the actual resize. First we navigate to the
# directory where all the boxes are located
#
cd ~/.vagrant.d/boxes/ubuntu-VAGRANTSLASH-bionic64/
#
# Each box is in its own subdirectoy.
#
dirs=$(find . -maxdepth 1 -mindepth 1 -type d)
for x in $dirs; do
  if [ -x $x/virtualbox ]; then
    echo "Resizing VirtualBox image in $x"
    # Each box contains two images in VMDK format, one for the actual OS and one
    # config image. To be able to resize it, we create a copy of the image in VDI format.
    VBoxManage clonehd $x/virtualbox/ubuntu-bionic-18.04-cloudimg.vmdk $x/virtualbox/tmp-disk.vdi --format vdi
    # resize it
    VBoxManage modifyhd $x/virtualbox/tmp-disk.vdi --resize 20000
    # and replace the original image by it
    VBoxManage clonehd $x/virtualbox/tmp-disk.vdi $x/virtualbox/resized-disk.vmdk  --format vmdk
    rm $x/virtualbox/tmp-disk.vdi $x/virtualbox/ubuntu-bionic-18.04-cloudimg.vmdk
    mv $x/virtualbox/resized-disk.vmdk $x/virtualbox/ubuntu-bionic-18.04-cloudimg.vmdk
  fi
done
