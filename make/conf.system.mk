
REPLACE_CMD := bin/replace_etc_file

# TODO: defines copy-pasted from Makefile...

# sudo -E to preserve environment
# i.e. DEBIAN_FRONTEND=noninteractive
define install-pkg
	dpkg -s $1 >/dev/null || sudo -E apt-get -y install $1

endef

define debconf-set-selection
	echo "$1" | debconf-set-selections
endef


all: conf.system.sudoers conf.system.logwatch conf.system.upgrades

conf.system.sudoers:
	test -d /etc/sudoers.d || exit 1
	$(REPLACE_CMD) sudoers.d/logging
	$(REPLACE_CMD) sudoers.d/maint
	@ touch $@

conf.system.logwatch: logwatch.conf logwatch.scripts
	@ touch $@

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
	@ touch $@

unattended-upgrades/enable_auto_updates := unattended-upgrades unattended-upgrades/enable_auto_updates	boolean	true
unattended-upgrades/origins_pattern := unattended-upgrades unattended-upgrades/origins_pattern	string "origin=Debian,codename=\$${distro_codename},label=Debian-Security"

conf.system.upgrades:
	$(call debconf-set-selection, $(unattended-upgrades/enable_auto_updates))
	$(call debconf-set-selection, $(unattended-upgrades/origins_pattern))
	dpkg-reconfigure -fnoninteractive unattended-upgrades
	@ touch $@
