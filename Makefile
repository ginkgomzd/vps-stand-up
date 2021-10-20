-include mdo-help.mk
-include mdo-config.mk

export DEBIAN_FRONTEND ?= noninteractive

# # #
# Helper Functions
# # #

# sudo -E to preserve environment
# i.e. DEBIAN_FRONTEND=noninteractive
define install-pkg
	dpkg -s $1 >/dev/null || sudo -E apt-get -y install $1

endef

# Example: note escaping of "${distro_codename}",
# unattended-upgrades/enable_auto_updates := unattnded-upgrades unattended-upgrades/enable_auto_updates	boolean	true
# unattended-upgrades/origins_pattern := unattended-upgrades unattended-upgrades/origins_pattern	string "origin=Debian,codename=\$${distro_codename},label=Debian-Security"
#
# conf.system.updates:
# 	$(call debconf-set-selection, $(unattended-upgrades/enable_auto_updates))
# 	$(call debconf-set-selection, $(unattended-upgrades/origins_pattern))
define debconf-set-selection
	echo "$1" | debconf-set-selections
endef

define keyscan
	ssh-keyscan -H $1 >> ~/.ssh/known_hosts

endef

# # #
# System Utils
# # #

KEYSCAN_HOSTS ?= github.com

SYSUTIL_PACKAGES ?= acl debconf-utils bash-completion opendkim-tools
SYSADMIN_PACKAGES ?= unattended-upgrades bsd-mailx logrotate logwatch
SYSCMD_PACKAGES ?= git zip unzip wget curl

# # #
# Main
sysutil: ssh.keyscan sysutil.packages ubuntu-etc-confs

# # #
# pre-accept host-keys
ssh.keyscan:
	test -d ~/.ssh || mkdir ~/.ssh
	$(foreach host,${KEYSCAN_HOSTS}, $(call keyscan, ${host}))
	@ touch $@

sysutil.packages:
	$(foreach pkg,${SYSUTIL_PACKAGES},$(call install-pkg,${pkg}))
	@ touch $@

sysadmin.packages:
	$(foreach pkg,${SYSADMIN_PACKAGES},$(call install-pkg,${pkg}))
	@ touch $@

syscmd.packages:
	$(foreach pkg,${SYSCMD_PACKAGES},$(call install-pkg,${pkg}))
	@ touch $@

ubuntu-etc-confs:
	- rm -r $@
	git clone git@github.com:ginkgostreet/ubuntu-etc-confs.git $@

# # #
# Security
# # #

# # #
# Main
security: security.fail2ban bad-bot-blocker security.rkhunter

security.fail2ban:
	$(call install-pkg, fail2ban)
	@ touch $@

bad-bot-blocker:
	- rm -rf $@
	git clone git@github.com:ginkgostreet/bad-bot-blocker.git $@

security.rkhunter:
	$(MAKE) -f make/rkhunter.mk
	@ touch $@

# # #
# Web Server

web-server: apache php

apache:
	apt-get update
	apt-get install -y apache2
	apachectl start
	# apache-mods:
	a2enmod rewrite
	a2enmod ssl
	apachectl restart
	@ touch $@

php: apache
	$(MAKE) -f make/php.mk
	apache2ctl restart

# # #
# Web SDKs
# # #

web-sdks: /usr/local/bin/composer /usr/local/bin/wp /usr/local/bin/cv

/usr/local/bin/composer:
	$(MAKE) -f make/composer.mk

/usr/local/bin/wp:
	$(MAKE) -f make/wp-cli.mk

/usr/local/bin/drush:
	$(MAKE) -f make/drush.mk

/usr/local/bin/cv:
	wget https://download.civicrm.org/cv/cv.phar -O /usr/local/bin/cv
	chmod 755 /usr/local/bin/cv

uninstall-cv: /usr/local/bin/cv
	rm -f /usr/local/bin/cv
	rm -f web-utils.cv

/node-js:
	$(MAKE) -f make/nodejs.mk
	@ touch $@


stand-up: sysutil security web-server web-sdks
	$(MAKE) -f make/conf.system.mk
	@ touch conf.system
	$(MAKE) -f make/conf.security.mk
	@ touch conf.security
	$(MAKE) -f make/conf.server.mk
	@ touch conf.server
