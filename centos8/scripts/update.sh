#!/bin/sh -eux
# forked from https://github.com/chef/bento

dnf config-manager --set-enabled PowerTools;
dnf -y update;
reboot;
sleep 60;