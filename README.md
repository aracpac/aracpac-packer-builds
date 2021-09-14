# AracPac Boxes

These packer configurations can be used to run existing projects or bootstrap new ones. Each variant is available as a 
standalone project and based on a specific operating system. Currently, there are boxes based on Ubuntu and CentOS Stream.

Scripts automate building, provisioning, scrubbing, shrinking, and exporting the boxes.

## Usage
To build a box, simply `cd` into any configuration's directory and invoke `packer` with the `packer.json` file. For 
example, to build the CentOS 8 Stream box:

```
cd centos8-stream/
packer build packer.json
```

Once the build has completed, you can find the generated box in the `centos8-stream/builds` directory. 

## Defaults
Distro images are configured in line with [Hashicorp recommendations](https://www.vagrantup.com/docs/boxes.html) and 
using forked scripts from the [Bento Box](https://github.com/chef/bento) project. Software configuration is handled
primarily via [geerlingguy's](https://galaxy.ansible.com/geerlingguy) [Ansible Galaxy](https://galaxy.ansible.com/) 
roles.

For additional configuration details, see the README file in each box's root directory.