
SYSTEM_PACKAGES ?= acl unattended-upgrades bsd-mailx logrotate logwatch

system.packages:
	$(foreach pkg,${SYSTEM_PACKAGES},$(call install-pgk,${pkg}))
	touch $@

