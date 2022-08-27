include functions.mk

unattended-upgrades/enable_auto_updates := unattended-upgrades unattended-upgrades/enable_auto_updates	boolean	true
unattended-upgrades/origins_pattern := unattended-upgrades unattended-upgrades/origins_pattern	string "origin=Debian,codename=\$${distro_codename},label=Debian-Security"

conf.unattended-upgrades:
	$(call debconf-set-selection, $(unattended-upgrades/enable_auto_updates))
	$(call debconf-set-selection, $(unattended-upgrades/origins_pattern))
	dpkg-reconfigure -fnoninteractive unattended-upgrades
	@ touch $@