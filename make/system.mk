
this-dir := $(dir $(lastword $(MAKEFILE_LIST)))
include $(this-dir)/inc.functions.mk

all: system.acl system.upgrades system.bsd-mailx \
	system.logrotate system.logwatch

system.acl:
	$(call install-package, acl)
	touch system.acl

system.upgrades:
	$(call install-package, unattended-upgrades)
	@ touch system.upgrades

# command-line-mode mail user agent
system.bsd-mailx:
	$(call install-package, bsd-mailx)
	@ touch system.bsd-mailx

system.logrotate:
	$(call install-package, logrotate)
	@ touch system.logrotate

system.logwatch:
	$(call install-package, logwatch)
	@ touch system.logwatch

# TODO:
# Unclear if these packages are needed:
# software-properties-common python-software-properties
