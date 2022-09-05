## Full Stack Web Development Environment

This CentOS 9 Stream virtual machine is preconfigured with support for a variety of full stack web development
frameworks, including:

* ✅ LAMP/LAPP: Laravel / Symfony / CakePHP / CodeIgnitor
* ✅ JS: Angular / Ember / Express / Vue / React
* ✅ Java Spring
* ✅ Ruby on Rails
* ✅ Django
* ✅ ASP.Net

Download a
turbocharged [Vagrantfile](https://raw.githubusercontent.com/aracpac/aracpac-vagrantfiles/v2.1.0/centos9-stream/Vagrantfile)
made specifically for this box.

## Stack summary:

* Apache 2.4.53
* dotnet 6.0.108
* Java 8 / 11 / 17
* Linux 5.14.0-160
* MongoDB 6.0.1
* MySQL Ver 15.1 Distrib 10.5.16-MariaD
* Node 16.17.0 via NVM
* PHP 8.1.10
* PostgreSQL 14.5 and PostGIS 3.3
* Python 3.9.10
* Ruby 3.1.2p20 via RVM
* Varnish 6.6.2 (with VMODs)
* Xdebug 3.1.5

## 5 minute quickstart

The quickstart assumes you've:

1. already installed [vagrant](https://www.vagrantup.com/docs/installation/),
   [VirtualBox](https://www.virtualbox.org/wiki/Downloads), and the `vagrant-hostmanager` plugin (if you need help with this step, navigate to the AracPac
   [Vagrantfile repository](https://github.com/aracpac/aracpac-vagrantfiles) and checkout the __Beginner's Guide__
   section in the README)
2. downloaded
   the [Vagrantfile optimized for this box](https://github.com/aracpac/aracpac-vagrantfiles/blob/v1.4.0/centos_stream/Vagrantfile)
   to an empty directory
3. run `vagrant up` from a command shell within that directory
4. run `vagrant ssh` to connect to the guest machine
5. navigated to `/var/www` inside the guest machine and removed any existing files in the directory

Now find the name of the framework you want to work with in the following list. Under the name of the framework are the
shell commands you'll need to run to initialize a new project and to start seeing your work on your host machine's web
browser (just navigate to the URL adjacent the framework name after you've run all the commands). The first time you
access the box via an HTTPS url, you will get a browser-specific error like `MOZILLA_PKIX_ERROR_SELF_SIGNED_CERT` or
`NET::ERR_CERT_AUTHORITY_INVALID` — this is expected due to the self-signed certificate generated in the virtual
machine. Follow the prompts in your browser to trust the certificate and proceed.

###

✅ LAMP ( https://dev.local/ )

```bash
# everything is preconfigured and you can start modifying `/var/www/index.php` immediately
```

###

✅ Symfony ( https://dev.local/ )

```bash
symfony new . --webapp
# install apache support (be sure to answer 'y' when prompted to run the recipe)
composer require symfony/apache-pack symfony/orm-pack
# update the default vhost to match symfony's file structure
sudo sed -i -e 's/var\/www.*$/var\/www\/public/g' /etc/httpd/conf.d/vhosts.conf
# restart httpd to reload the vhost
sudo systemctl restart httpd
# create a local .env override and add the local machine's database information
sed -i -e 's/app:!ChangeMe!/vagrant:vagrant/g' .env
# create the database
bin/console doctrine:database:create --if-not-exists --no-interaction
```

###

✅ Laravel (https://dev.local/ )

```bash
composer create-project laravel/laravel .
# update the default vhost to match Laravel's file structure
sudo sed -i -e 's/var\/www.*$/var\/www\/public/g' /etc/httpd/conf.d/vhosts.conf
# restart httpd to reload the vhost
sudo systemctl restart httpd
```

###

✅ CakePHP ( https://dev.local/ )

```bash
composer create-project --prefer-dist cakephp/app .
# update the default vhost to match CakePHP's file structure
sudo sed -i -e 's/var\/www.*$/var\/www/g' /etc/httpd/conf.d/vhosts.conf
# restart httpd to reload the vhost
sudo systemctl restart httpd
```

###

✅ CodeIgniter ( https://dev.local/ )

```bash
composer create-project codeigniter4/appstarter .
# update the default vhost to match CodeIgniter's file structure
sudo sed -i -e 's/var\/www.*$/var\/www\/public/g' /etc/httpd/conf.d/vhosts.conf
# restart httpd to reload the vhost
sudo systemctl restart httpd
```

###

✅ Angular ( http://dev.local:4200/ )

```bash
ng new web --directory .
ng serve --host 0.0.0.0 --disable-host-check
```

###

✅ Ember ( http://dev.local:4200/ )

```bash
ember init
ember serve --host 0.0.0.0
```

###

✅ Express ( http://dev.local:3000/ )

```bash
express --view=twig .
npm install
DEBUG=.:* npm start
```

###

✅ Vue ( http://dev.local:8080/ )

```bash
vue create .
# create a vue.config.js file and add our host to the allowed hosts list
echo "module.exports = { devServer: { allowedHosts: ['dev.local'] } }" > vue.config.js
yarn serve --host 0.0.0.0 --public dev.local
```

###

✅ React ( http://dev.local:3000/ )

```bash
create-react-app .
serve -s public
```

###

✅ Java Spring ( http://dev.local:8080/ )

```bash
spring init --dependencies=web -j=17 ./
mvn spring-boot:run
```

###

✅ Ruby on Rails ( http://dev.local:3000/ )

```bash
rails new .
# whitelist all IPs in config/environments/development.rb so we can view our work from the host machine
sed -i "\$i config.hosts << \"dev.local\"\nconfig.web_console.whitelisted_ips = '0.0.0.0/0'" config/environments/development.rb
rails server -b 0.0.0.0
```

###

✅ Django ( http://dev.local:8080 )

```bash
django-admin startproject web .
# whitelist all hosts in web/settings.py so we can view our work from the host machine
sed -i -e 's/^ALLOWED_HOSTS = \[\]$/ALLOWED_HOSTS = ["*"]/g' web/settings.py
python3 manage.py runserver 0.0.0.0:8080
```

###

✅ ASP.Net ( http://dev.local:5000 )

```bash
dotnet new webapp -o .
dotnet run --urls "http://0.0.0.0:5000" --project .
```

###

## Reverse mounts

Traditionally, a major downside of developing in a virtual machine has been __synced folders__. Because the host machine
(your desktop) and the guest machine (the virtual machine) are two logically separate operating systems, files on one
filesystem are not immediately accessible to the other. This is a challenge if you want to work on your code using your
favorite desktop IDE, but the code requires the software and infrastructure of the virtual machine to actually run. The
most common solution is using a synced folder, which syncs code from one environment to the other using rsync, NFS,
samba, etc.

Unfortunately, synced folders have some performance penalty, especially on projects that require constance recompilation
(think most JavaScript frameworks). On the one hand, you could run your code locally on your desktop and mount your
working folder to your virtual machine. This is the default vagrant behaviour, and it allows for a speedy IDE experience
with code analysis, refactoring, linting, and all the other IDE goodies. Unfortunately, this setup can cause a delay
between the work you're doing and the results you see in the browser.

AracPac can support the default vagrant behaviour but uses a different approach sometimes called a reverse mount. Here,
the Vagrantfile is used to automatically mount the `/var/www` directory from the virtual machine to your project
directory on your computer. Though a reverse mount can make some IDE features a little less responsive, there are big
wins in terms of how quickly your work is displayed in the browser, which makes debugging code and working on features a
much nicer experience.

### Mailcatcher

Mailcatcher runs a local mail server and allows you to review mail sent to it from a web browser on your host machine.
This can be very useful during development.

Run Mailcatcher by using a command shell on the guest machine:

```shell
mailcatcher --http-ip 0.0.0.0
```

Mailcatcher will run in the background as a daemon. If you want to route all local mail to port 1025 so Mailcatcher will
catch it, just add a line to `/etc/postfix/main.cf`:

```shell
relayhost = [localhost]:1025
```

Now use a command shell to send a test message:

```
echo "Mailcatcher test!" | mail -s "Testing 1, 2 ,3" -r from@email.address to@email.address
```

Finally, use a web browser on your host machine and review your caught messages at http://dev.local:1080/. messages.

## Configuration details:

* `root` user with password `root`
* `vagrant` user with password `vagrant`, passwordless `sudo`, and an entry for the vagrant insecure key
  in `~/.ssh/authorized_keys`
* `apache` listening on port `80` and `443` and serving from `/var/www`
* `java` 8 / 11 / 17 JDKs and JREs (with 17 set as the default)
* `mysql` listening on port `3306` and with `root` password `root`
* `mongodb` configured to listen on `27017` but disabled by default
* `postgresql` listening on port `5432` and with `vagrant` password `vagrant`, with `postgis`
* `php-xdebug` installed and available on port `9003` but disabled by default
* `varnish` configured to listen on `8080` but disabled by default
* `nginx` installed but disabled by default
* `nfsd` installed and configured with the following
  share: `/var/www *(all_squash,anonuid=1000,anongid=1000,async,crossmnt,insecure,nohide,fsid=9999,rw)`
* `firewalld` installed, enabled, and configured for the stack
* `selinux` configured for all installed packages and services
* a purpose-built local `dev.crt` and `dev.pem` in `/etc/ssl`
* `500G` VirtualBox primary disk (useful on larger projects -- most publicly available boxes have `40G` disks)
* `apache` daemon's umask set to `0002`
* `vagrant` user belongs to the `apache` group; `apache` user belongs to the `vagrant` group

## Extra repos:

* [epel](https://fedoraproject.org/wiki/EPEL)
* [remi](https://rpms.remirepo.net/)

## Notable system packages:

* `acl`
* `atop`
* `bash-completion`
* `composer`
* `curl`
* `docker-ce`
* `git`
* `golang`
* [gradle](https://gradle.org/)
* `htop`
* `iotop`
* `java`
* `maven`
* `memcached`
* `nodejs`
* `ncat`
* `pv`
* `vim`
* `rsync`
* `rustc`
* [SDKMAN!](https://sdkman.io/)
* `sendmail`
* [spring](https://docs.spring.io/spring-boot/docs/current/reference/html/cli.html)
* `sqlite`
* `subversion`
* `supervisor`
* `symfony`
* `tmux`
* `tree`
* `unzip`
* `vim`
* [Virtual Box Guest Additions](https://docs.oracle.com/cd/E36500_01/E36502/html/qs-guest-additions.html)
* [wp](https://wp-cli.org/)
* `wget`
* `zip`

## Notable NPM packages:

* [@angular/cli](https://angular.io/cli)
* [@vue/cli](https://cli.vuejs.org/)
* [create-react-app](https://create-react-app.dev/)
* [ember-cli](https://cli.emberjs.com/release/)
* [express-generator](https://expressjs.com/en/starter/generator.html)
* [node-sass](https://www.npmjs.com/package/node-sass)
* [pm2](https://www.npmjs.com/package/pm2)
* [rome](https://www.npmjs.com/package/rome)
* [sass](https://www.npmjs.com/package/sass)
* [webpack](https://webpack.js.org/)
* [yarn](https://www.npmjs.com/package/yarn)

## Notable PIP packages:

* [Django](https://pypi.org/project/Django/)
* [virtualenv](https://pypi.org/project/virtualenv/)

## Notable Ruby packages:

* [bundler](https://bundler.io/)
* [mailcatcher](https://mailcatcher.me/)
* [rails](https://rubyonrails.org/)
