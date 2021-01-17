#!/bin/sh -eux
# forked from https://github.com/chef/bento

dnf config-manager --set-enabled powertools;
dnf -y update;
reboot;
sleep 60;