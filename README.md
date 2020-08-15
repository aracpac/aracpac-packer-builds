# AracPac Boxes

These packer configurations can be used to run existing projects or bootstrap new ones. Each variant is available as a 
standalone project and based on a specific operating system. Currently, there are boxes based on Ubuntu and CentOS.

Scripts automate building, provisioning, scrubbing, shrinking, and exporting the boxes.

## Usage
To build a box, simply `cd` into any configuration's directory and invoke `packer` with the `packer.json` file. For 
example, to build the RHEL 8 box:

```
cd rhel8/
packer build packer.json
```

Once the builds have completed, you can find the generated boxes in the `rhel8/builds` directory. 

The packer [build](https://packer.io/docs/commands/build.html) command can be modified in many ways. For instance, to 
build only a specific build, you can use the `--only` flag. To disable packers garbage collection when an error occurs
(which is useful for debugging the build artifacts), you can modify the `--on-error` flag. For instance:

```
packer build --on-error=abort packer.json
```

## Defaults
Boxes are built from scratch based on [Hashicorp recommendations](https://www.vagrantup.com/docs/boxes.html) and 
configuration taken largely from the [Bento Box](https://github.com/chef/bento) project.
 
In addition, the boxes are configured as follows:
* a `root` user with password `root`
* a `vagrant` user with password `vagrant`, passwordless `sudo`, and an entry for the vagrant insecure key in `~/.ssh/authorized_keys`
* `apache` listening on port `80` and `443` and serving from `/var/www`
* `mysql` listening on port `3306` and with `root` password `root`
* `php-xdebug` installed and available on port `9000` but disabled by default (enable in `/etc/php.d/xdebug.ini`)
* `varnish` configured to listen on `8080` but disabled by default
* `nginx` installed but disabled by default
* `nfsd` installed and configured with the following share: `/var/www *(all_squash,anonuid=1000,anongid=1000,async,crossmnt,insecure,nohide,fsid=9999,rw)`
* `firewalld` installed, enabled, and configured for the stack
* a purpose-built local `dev.crt` and `dev.pem` in `/etc/ssl`
* `250G` VirtualBox primary disk (useful on larger projects -- most publicly available boxes have `40G` disks). **Note:**
that this means you will need more than `250G` disk space on the machine that you use to build the boxes
(see `scripts/common/minimize.sh` to understand why).

The boxes include the following additional software:
* `acl`
* `atop`
* `bash-completion`
* `byobu`
* `composer`
* `curl`
* `git`
* `golang`
* `htop`
* `iotop`
* `java`
* `memcached`
* `nodejs`
* `pv`
* `vim`
* `rsync`
* `rustc`
* `sass`
* `sendmail`
* `symfony`
* `tree`
* `unzip`
* `vim`
* [Virtual Box Guest Additions](https://docs.oracle.com/cd/E36500_01/E36502/html/qs-guest-additions.html)
* `wget`
* `zip`

The boxes include the following NPM packages installed system-wide:
 * [diff-so-fancy](https://www.npmjs.com/package/diff-so-fancy)
 * [node-sass](https://www.npmjs.com/package/node-sass)
 * [rome](https://www.npmjs.com/package/rome)
 * [uglifycss](https://www.npmjs.com/package/uglifycss)
 * [uglify-js](https://www.npmjs.com/package/uglify-js)
 * [yarn](https://www.npmjs.com/package/yarn)

The boxes include the following VIM addons:
* [eunuch](https://github.com/tpope/vim-eunuch)
* [gitgutter](https://github.com/airblade/vim-gitgutter)
* [nerdtree](https://github.com/scrooloose/nerdtree)
* [papercolor-theme](https://github.com/NLKNguyen/papercolor-theme)
* [polyglot](https://github.com/sheerun/vim-polyglot)
* [powerline](https://github.com/powerline/powerline)
* [vundle](https://github.com/VundleVim/Vundle.vim)

The RHEL boxes include the following additional repos:
 * [epel](https://fedoraproject.org/wiki/EPEL)
 * [remi](https://rpms.remirepo.net/)

The apache daemon's umask is set to `0002`, the vagrant user belongs to the apache group, and the apache user belongs to 
the vagrant group. 
 
## Customization
### Packer
All customization should be done in ansible, by editing the `ansible/main.yml` and `ansible/host_vars/common.yml` files. 

### Ansible
All roles are from [geerlingguy](https://galaxy.ansible.com/geerlingguy) via [Ansible Galaxy](https://galaxy.ansible.com/).
