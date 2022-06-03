#!/bin/sh -eux

# Delete obsolete networking
apt-get -y purge ppp pppconfig pppoeconf;

apt-get -y autoremove;
apt-get -y clean;

# Remove caches
find /var/cache -type f -exec rm -rf {} \;

# truncate any logs that have built up during the install
find /var/log -type f -exec truncate --size=0 {} \;

# remove xdebug cruft
rm -f /root/package.xml
rm -fr /root/xdebug-*

# remove vmware cruft
rm -f /root/linux.iso

# remove misc cruft
rm -fr /root/.ansible
rm -fr /root/.composer
rm -fr /root/.config
rm -f /root/.cshrc
rm -fr /root/.gnupg
rm -f /root/.my.cnf
rm -f /root/.mysql_history
rm -fr /root/.npm
rm -f /root/.tcshrc
rm -f /root/.viminfo
rm -rf /var/www/html

# remove the contents of /tmp and /var/tmp
rm -fr /tmp/* /var/tmp/*

# Blank netplan machine-id (DUID) so machines get unique ID generated on boot.
truncate -s 0 /etc/machine-id

# clear the history so our install isn't there
rm -f /root/.bash_history
rm -f /root/.wget-hsts
unset HISTFILE