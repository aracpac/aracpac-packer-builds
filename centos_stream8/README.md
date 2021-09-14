# About
This is a CentOS Stream web development box preconfigured with many common tools.

[PhpStorm](https://www.jetbrains.com/phpstorm/) is installed server-side via [JetBrains Projector](https://lp.jetbrains.com/projector/),
which means much faster indexing with reverse NFS mounts.

Get a Vagrantfile optimized for this box [here](https://github.com/aracpac/aracpac-vagrantfiles/blob/v1.3.0/centos_stream/Vagrantfile).

### Stack summary:
* Linux 4.18.0-315.el8.x86_64
* Apache/2.4.37
* mysql 15.1 Distrib 10.3.28-MariaDB
* psql (PostgreSQL) 13.3 and PostGIS 3.1
* PHP 8.0.8 (cli) (built: Jun 29 2021 07:41:19)
* Xdebug v3.0.4
* varnish-6.6.1 revision e6a8c860944c4f6a7e1af9f40674ea78bbdcdc66

### Configuration details:
* `root` user with password `root`
* `vagrant` user with password `vagrant`, passwordless `sudo`, and an entry for the vagrant insecure key in `~/.ssh/authorized_keys`
* `apache` listening on port `80` and `443` and serving from `/var/www`
* `mysql` listening on port `3306` and with `root` password `root`
* `postgresql` listening on port `5432` and with `vagrant` password `vagrant`
* `php-xdebug` installed and available on port `9003` but disabled by default
* JetBrains `projector` installed, with PHPStorm installed as a service (`projector_phpstorm`) on port `9999` but disabled by default
* `varnish` configured to listen on `8080` but disabled by default
* `nginx` installed but disabled by default
* `nfsd` installed and configured with the following share: `/var/www *(all_squash,anonuid=1000,anongid=1000,async,crossmnt,insecure,nohide,fsid=9999,rw)`
* `firewalld` installed, enabled, and configured for the stack
* `selinux` configured for all installed packages and services
* a purpose-built local `dev.crt` and `dev.pem` in `/etc/ssl`
* `500G` VirtualBox primary disk (useful on larger projects -- most publicly available boxes have `40G` disks)
* `apache` daemon's umask set to `0002`
* `vagrant` user belongs to the `apache` group; `apache` user belongs to the `vagrant` group

### Extra repos:
* [epel](https://fedoraproject.org/wiki/EPEL)
* [remi](https://rpms.remirepo.net/)

### Installed packages:
* `acl`
* `atop`
* `bash-completion`
* `byobu`
* `composer`
* `curl`
* `docker-ce`
* `git`
* `golang`
* `htop`
* `iotop`
* `java`
* `memcached`
* `nodejs`
* `ncat`
* `pv`
* `vim`
* `rsync`
* `rustc`
* `sass`
* `sendmail`
* `supervisor`
* `symfony`
* `tree`
* `unzip`
* `vim`
* [Virtual Box Guest Additions](https://docs.oracle.com/cd/E36500_01/E36502/html/qs-guest-additions.html)
* `wget`
* `zip`

### Installed NPM packages:
* [diff-so-fancy](https://www.npmjs.com/package/diff-so-fancy)
* [node-sass](https://www.npmjs.com/package/node-sass)
* [rome](https://www.npmjs.com/package/rome)
* [uglifycss](https://www.npmjs.com/package/uglifycss)
* [uglify-js](https://www.npmjs.com/package/uglify-js)
* [yarn](https://www.npmjs.com/package/yarn)

### Installed VIM addons:
* [eunuch](https://github.com/tpope/vim-eunuch)
* [gitgutter](https://github.com/airblade/vim-gitgutter)
* [nerdtree](https://github.com/scrooloose/nerdtree)
* [papercolor-theme](https://github.com/NLKNguyen/papercolor-theme)
* [polyglot](https://github.com/sheerun/vim-polyglot)
* [powerline](https://github.com/powerline/powerline)
* [vundle](https://github.com/VundleVim/Vundle.vim)
