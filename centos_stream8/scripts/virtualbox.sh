#!/bin/sh -eux
# forked from https://github.com/chef/bento

# set a default HOME_DIR environment variable if not set
HOME_DIR="/root";

VER="`cat $HOME_DIR/.vbox_version`";
ISO="VBoxGuestAdditions_$VER.iso";
mkdir -p /tmp/vbox;
mount -o loop $HOME_DIR/$ISO /tmp/vbox;
sh /tmp/vbox/VBoxLinuxAdditions.run \
    || echo "VBoxLinuxAdditions.run exited $? and is suppressed." \
        "For more read https://www.virtualbox.org/ticket/12479";
umount /tmp/vbox;
rm -rf /tmp/vbox;
rm -f $HOME_DIR/*.iso;