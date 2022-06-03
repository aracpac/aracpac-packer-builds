#!/bin/sh -eux
# forked from https://github.com/chef/bento

dnf config-manager --set-enabled crb;
dnf -y update;
dnf -y install epel-release;
dnf -y install dkms;
reboot;