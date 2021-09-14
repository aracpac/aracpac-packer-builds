#!/bin/sh -eux

if [ "$(whoami)" != "root" ]
then
    sudo su -s "$0"
    exit
fi

# truncate any logs that have built up during the install
find /var/log -type f -exec truncate --size=0 {} \;

# clear bash history
unset HISTFILE
> /root/.bash_history
> /root/.viminfo
for USER_HOME in /home/*; do
  if [ -d "$USER_HOME" ]; then
    [ -f "$USER_HOME"/.bash_history ] && truncate "$USER_HOME"/.bash_history --size 0
    [ -f "$USER_HOME"/.viminfo ] && truncate "$USER_HOME"/.viminfo --size 0
  fi
done

# Whiteout root
count=$(df --sync -kP / | tail -n1  | awk -F ' ' '{print $4}')
count=$(($count-1))
dd if=/dev/zero of=/tmp/whitespace bs=1M count=$count || echo "dd exit code $? is suppressed";
rm /tmp/whitespace

# Whiteout /boot
count=$(df --sync -kP /boot | tail -n1 | awk -F ' ' '{print $4}')
count=$(($count-1))
dd if=/dev/zero of=/boot/whitespace bs=1M count=$count || echo "dd exit code $? is suppressed";
rm /boot/whitespace

sync;