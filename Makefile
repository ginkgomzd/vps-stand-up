-include mdo-help.mk
-include mdo-config.mk

export DEBIAN_FRONTEND ?= noninteractive

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


include make/prereqs.mk

system: prereqs sys-utils
	$(MAKE) -f make/system.mk

security: system
	$(MAKE) -f make/security.mk

sys-utils: prereqs
	$(MAKE) -f make/sys-utils.mk

server: prereqs sys-utils
	$(MAKE) -f make/server.mk

web-utils: prereqs
	$(MAKE) -f make/web-utils.mk

stand-up: system sys-utils server security
	$(MAKE) -f make/conf.system.mk
	@ touch conf.system
	$(MAKE) -f make/conf.security.mk
	@ touch conf.security
	$(MAKE) -f make/conf.server.mk
	@ touch conf.server
