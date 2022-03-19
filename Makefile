-include mdo-help.mk
-include mdo-config.mk

include .env

# # #
# Helper Functions
# # #

export DEBIAN_FRONTEND ?= noninteractive

# sudo -E to preserve environment
# i.e. DEBIAN_FRONTEND=noninteractive
export define install-pkg
	dpkg -s $1 >/dev/null || sudo -E apt-get -y install $1

endef

export REPLACE_ETC := bin/replace_etc_file

export PATCH_FILE_CMD := bin/patch_file

# Example from unattended-upgrades.mk: note escaping of "${distro_codename}",
# unattended-upgrades/enable_auto_updates := unattnded-upgrades unattended-upgrades/enable_auto_updates	boolean	true
# unattended-upgrades/origins_pattern := unattended-upgrades unattended-upgrades/origins_pattern	string "origin=Debian,codename=\$${distro_codename},label=Debian-Security"
#
# conf.system.updates:
# 	$(call debconf-set-selection, $(unattended-upgrades/enable_auto_updates))
# 	$(call debconf-set-selection, $(unattended-upgrades/origins_pattern))
export define debconf-set-selection
	echo "$1" | debconf-set-selections
endef

pkg.%:
	$(call install-pkg,${*})
	@ touch $@

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
	@ touch $@

SYS_UTIL_PACKAGES ?= acl debconf-utils bash-completion opendkim-tools

packages.sysutil: $(foreach pkg,${SYSUTIL_PACKAGES},pkg.${pkg})
	@ touch $@

SYS_CMD_PACKAGES ?= zip unzip wget curl bsd-mailx s-nail pandoc

packages.syscmd: $(foreach pkg,${SYS_CMD_PACKAGES}, pkg.${pkg})
	@ touch $@

ubuntu-etc-confs:
	- rm -r $@
	git clone https://github.com/ginkgostreet/ubuntu-etc-confs.git $@
	cd $@ && git checkout ${STANDUP_ETC_CONF_VERSION}

unattended-upgrades:
	$(MAKE) -f make/unattended-upgrades.mk
	@ touch $@

system.timezone:
	ln -fs /usr/share/zoneinfo/${STANDUP_TIMEZONE} /etc/localtime
	dpkg-reconfigure -f noninteractive tzdata
	@ touch $@

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

fail2ban:
	$(MAKE) -f make/fail2ban.mk

bad-bot-blocker:
	$(MAKE) -f make/bad-bot-blocker.mk
	@ touch $@

rkhunter:
	$(MAKE) -f make/rkhunter.mk
	@ touch $@

# # #
# WEB SERVER
# # #
web-server: apache php mysql-client postfix dkim

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

mysql-client:
	$(call install-pkg,mysql-client)
	@ touch $@

postfix:
	$(MAKE) -f make/postfix.mk
	@ touch $@

dkim: postfix
	$(MAKE) -f make/dkim.mk
	@ touch $@

# # #
# WEB SDK
# # #
web-sdk: /usr/local/bin/composer node-js

/usr/local/bin/composer:
	$(MAKE) -f make/composer.mk

node-js:
	$(MAKE) -f make/nodejs.mk
	@ touch $@

#
# SDKs Not installed by default:
#

/usr/local/bin/wp:
	$(MAKE) -f make/wp-cli.mk

/usr/local/bin/drush:
	$(MAKE) -f make/drush.mk

/usr/local/bin/cv:
	wget https://download.civicrm.org/cv/cv.phar -O /usr/local/bin/cv
	chmod 755 /usr/local/bin/cv
