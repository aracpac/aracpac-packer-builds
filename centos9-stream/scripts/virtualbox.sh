#!/bin/sh -eux
# forked from https://github.com/chef/bento

# install deps
dnf -y install tar patch;

# set a default HOME_DIR environment variable if not set
HOME_DIR="/root";

VER="`cat $HOME_DIR/.vbox_version`";
ISO="VBoxGuestAdditions_$VER.iso";
mkdir -p /tmp/vbox;
mount -o loop $HOME_DIR/$ISO /tmp/vbox;
sh /tmp/vbox/VBoxLinuxAdditions.run
umount /tmp/vbox;
rm -rf /tmp/vbox;
rm -f $HOME_DIR/*.iso;