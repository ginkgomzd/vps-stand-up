
define install-package
	@# sudo -E to preserve environment
	dpkg -s $1 >/dev/null || \
	sudo -E apt-get -y install $1
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
