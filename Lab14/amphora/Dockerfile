FROM ubuntu:18.04

# Install git
RUN apt-get update && apt-get install -y git

# Get needed repositories from OpenStack
RUN git clone https://github.com/openstack/octavia 
RUN git clone https://github.com/openstack/diskimage-builder

# Checkout the versions that we need
RUN cd octavia && git checkout stable/stein

# Install pip
RUN apt-get install -y python3-pip

# Install all required dependencies
RUN ( cd octavia/diskimage-create ; pip3 install -r requirements.txt)
RUN apt-get install -y qemu qemu-utils git kpartx debootstrap
RUN apt-get install -y lsb-release
RUN apt-get install -y nano sudo curl

# Set needed environment variables
ENV DIB_REPO_PATH /diskimage-builder/diskimage_builder
ENV DIB_REPOLOCATION_amphora_agent /octavia
ENV DIB_REPOREF_amphora_agent "stable/stein"
ENV OCTAVIA_REPO_PATH  /octavia

WORKDIR /octavia/diskimage-create 
CMD ["/octavia/diskimage-create/diskimage-create.sh","-c /lab/.cache", "-o /lab/amphora-x64-haproxy.qcow2"]