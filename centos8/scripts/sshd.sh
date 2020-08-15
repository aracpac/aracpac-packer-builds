#!/bin/sh -eux
# forked from https://github.com/chef/bento

SSHD_CONFIG="/etc/ssh/sshd_config"

# ensure that there is a trailing newline before attempting to concatenate
sed -i -e '$a\' "$SSHD_CONFIG"

GSSAPI="GSSAPIAuthentication no"
if grep -q -E "^[[:space:]]*GSSAPIAuthentication" "$SSHD_CONFIG"; then
    sed -i "s/^\s*GSSAPIAuthentication.*/${GSSAPI}/" "$SSHD_CONFIG"
else
    echo "$GSSAPI" >>"$SSHD_CONFIG"
fi

X11FORWARDING="X11Forwarding no"
if grep -q -E "^[[:space:]]*X11Forwarding" "$SSHD_CONFIG"; then
    sed -i "s/^\s*X11Forwarding.*/${X11FORWARDING}/" "$SSHD_CONFIG"
else
    echo "X11FORWARDING" >>"$SSHD_CONFIG"
fi