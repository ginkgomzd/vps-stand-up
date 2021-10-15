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
	touch $@

sysutil.packages:
	$(foreach pkg,${SYSUTIL_PACKAGES},$(call install-pkg,${pkg}))
	touch $@

sysadmin.packages:
	$(foreach pkg,${SYSADMIN_PACKAGES},$(call install-pkg,${pkg}))
	touch $@

syscmd.packages:
	$(foreach pkg,${SYSCMD_PACKAGES},$(call install-pkg,${pkg}))
	touch $@

ubuntu-etc-confs:
	- rm -r $@
	git clone git@github.com:ginkgostreet/ubuntu-etc-confs.git $@

# ~,~`

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
