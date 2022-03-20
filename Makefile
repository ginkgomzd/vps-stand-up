-include mdo-help.mk
-include mdo-config.mk

include .env

include functions.mk

# # #
# MAIN()
# # #
standup: system security web-server web-sdk

# # #
# SYSTEM
# # #
system: ssh.keyscan ubuntu-etc-confs packages.sysutil packages.syscmd ubuntu-etc-confs system.timezone unattended-upgrades

KEYSCAN_HOSTS ?= github.com

define keyscan
	ssh-keyscan -H $1 >> ~/.ssh/known_hosts

endef

# # #
# pre-accept host-keys
# no-longer really necessary, but maybe still nice to have:
#
ssh.keyscan:
	test -d ~/.ssh || mkdir ~/.ssh
	$(foreach host,${KEYSCAN_HOSTS}, $(call keyscan, ${host}))

SYS_UTIL_PACKAGES ?= acl debconf-utils bash-completion opendkim-tools

packages.sysutil: $(foreach pkg,${SYS_UTIL_PACKAGES},${pkg}.pkg)

SYS_CMD_PACKAGES ?= zip unzip wget curl bsd-mailx s-nail pandoc

packages.syscmd: $(foreach pkg,${SYS_CMD_PACKAGES},${pkg}.pkg)

ubuntu-etc-confs:
	- rm -r $@
	git clone https://github.com/ginkgostreet/ubuntu-etc-confs.git $@
	cd $@ && git checkout ${STANDUP_ETC_CONF_VERSION}

unattended-upgrades: unattended-upgrades.pkg
	$(MAKE) -f install/unattended-upgrades.mk

system.timezone:
	ln -fs /usr/share/zoneinfo/${STANDUP_TIMEZONE} /etc/localtime
	dpkg-reconfigure -f noninteractive tzdata

# TODO:
# system.custom-logo:
# 	${REPLACE_ETC} gsl-motd-logo.txt
# 	${REPLACE_ETC} update-motd.d/00-0logo
# 	$(call install-package, fortunes)
# 	$(call install-package, fortunes-bofh-excuses)
# 	$(call install-package, fortune-mod)
# 	$(call install-package, fortunes-min)
# 	@ touch $@

# # #
# SECURITY
# # #
security: fail2ban bad-bot-blocker rkhunter

# TODO:
# conf.system.sudoers:
# 	test -d /etc/sudoers.d || exit 1
# 	${REPLACE_ETC} sudoers.d/logging
# 	${REPLACE_ETC} sudoers.d/maint
# 	@ touch $@

fail2ban: fail2ban.pkg
	$(MAKE) -f install/fail2ban.mk

bad-bot-blocker:
	$(MAKE) -f install/bad-bot-blocker.mk

rkhunter: rkhunter.pkg
	$(MAKE) -f install/rkhunter.mk

# # #
# WEB SERVER
# # #
web-server: apache php mysql-client postfix

apache:
	apt-get update
	apt-get install -y apache2
	apachectl start
	# apache-mods:
	a2enmod rewrite
	a2enmod ssl
	apachectl restart
	@ touch $@.pkg

php: apache.pkg
	$(MAKE) -f install/php.mk
	apache2ctl restart
	@ touch $@.pkg

mysql-client: mysql-client.pkg

postfix: postfix.pkg
	$(MAKE) -f install/postfix.mk

# TODO: 
# dkim: postfix 
# 	$(MAKE) -f install/dkim.mk

# # #
# WEB SDK
# # #
web-sdk: /usr/local/bin/composer node-js

/usr/local/bin/composer:
	$(MAKE) -f install/composer.mk

node-js:
	$(MAKE) -f install/nodejs.mk

#
# SDKs Not installed by default:
#

/usr/local/bin/wp:
	$(MAKE) -f install/wp-cli.mk

/usr/local/bin/drush:
	$(MAKE) -f install/drush.mk

/usr/local/bin/cv:
	wget https://download.civicrm.org/cv/cv.phar -O /usr/local/bin/cv
	chmod 755 /usr/local/bin/cv

reset:
	rm *.pkg
	rm conf.*

# # #
# TODOs:
# deploy CloudFlare Certs
# auto-update bad-bot-blocker cron (see README)
# configure logo (muy importante!)
# configure apache SSL w/ redirect from :80
# 	https://linuxconfig.org/how-to-use-apache-to-redirect-all-traffic-from-http-to-https
# 	over-write keys:
# 		/etc/ssl/certs/ssl-cert-snakeoil.pem
# 		/etc/ssl/private/ssl-cert-snakeoil.key

# mount htdocs  https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ebs-using-volumes.html
