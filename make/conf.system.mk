
this-dir := $(dir $(lastword $(MAKEFILE_LIST)))
include $(this-dir)/inc.functions.mk

REPLACE_CMD := $(this-dir)../bin/replace_file

all: conf.system.hostname conf.system.gsl-logo conf.system.sudoers conf.system.logwatch conf.system.dkim conf.system.updates

conf.system.hostname:
	# [ "$H" != \*"."\* ] && H="$H.ginkgostreet.com" # This doesn't work
	hostnamectl set-hostname $(STANDUP_FQDN)
	echo "127.0.1.1	$H	$( hostname --short )" >> /etc/hosts
	domainname $(STANDUP_DOMAIN)

STANDUP_TIMEZONE ?= 'America/New_York'
conf.system.timezone:
	ln -fs /usr/share/zoneinfo/$(STANDUP_TIMEZONE) /etc/localtime
	dpkg-reconfigure -f noninteractive tzdata
	@ touch $(@)

conf.system.gsl-logo:
	$(REPLACE_CMD) gsl-motd-logo.txt
	$(REPLACE_CMD) update-motd.d/00-0logo
	$(call install-package, fortunes)
	$(call install-package, fortunes-bofh-excuses)
	$(call install-package, fortune-mod)
	$(call install-package, fortunes-min)
	@ touch conf.system.gsl-logo

conf.system.sudoers:
	test -d /etc/sudoers.d || exit 1
	$(REPLACE_CMD) sudoers.d/logging
	$(REPLACE_CMD) sudoers.d/maint
	@ touch $(@)

conf.system.logwatch: logwatch.conf logwatch.scripts

.PHONY: logwatch.conf
logwatch.conf:
	test -d /etc/logwatch/conf || exit 1
	$(REPLACE_CMD) logwatch/conf/logwatch.conf
	$(REPLACE_CMD) logwatch/conf/logfiles/http.conf
	$(REPLACE_CMD) logwatch/conf/logfiles/http-error.conf

.PHONY: logwatch.scripts
logwatch.scripts:
	test -d /etc/logwatch/scripts/services || exit 1
	$(REPLACE_CMD) logwatch/scripts/services/sshd
	$(REPLACE_CMD) logwatch/scripts/services/sudo

conf.system.logrotate:
	test -d /etc/logrotate.d || exit 1
	$(REPLACE_CMD) logrotate.d/apache2
	@ touch $(@)

define debconf.unattended-upgrades.selections
unattended-upgrades/enable_auto_updates	boolean	true unattended-upgrades unattended-upgrades/origins_pattern	string "origin=Debian,codename=${distro_codename},label=Debian-Security";
endef

conf.system.updates:
	dpkg-reconfigure -fnoninteractive unattended-upgrades unattended-upgrades < $(debconf.unattended-upgrades.selections)
	@ touch $(@)
