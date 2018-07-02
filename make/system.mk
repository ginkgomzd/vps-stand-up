
this-dir := $(dir $(lastword $(MAKEFILE_LIST)))
include $(this-dir)/inc.functions.mk

all: system.lamp

system.lamp:
	# install lamp-server meta-package (^)
	# -y because, for some reason, non-interactive is not enough; maybe because is a meta-package?
	sudo apt -yq install lamp-server^
	@ touch system.lamp

system.acl:
	$(call install-package, acl)
	touch system.acl

system.upgrades:
	$(call install-package, unattended-upgrades)
	@ touch system.upgrades

system.bsd-mailx:
	$(call install-package, bsd-mailx)
	@ touch system.bsd-mailx

system.fail2ban:
	$(call install-package, fail2ban)
	@ touch system.fail2ban

system.logrotate:
	$(call install-package, logrotate)
	@ touch system.logrotate

system.logwatch:
	$(call install-package, logwatch)
	@ touch system.logwatch

system.certbot:
	$(call install-package, certbot)
	@touch system.certbot

system.rkhunter:
	vendor/rkhunter ./installer.sh --install
	@ touch system.rkhunter

# TODO:
# don't think the following should have been part of the install:
# Set-up a cron-job?
#
# rkhunter --pkgmgr DPKG --check --skip-keypress
# rkhunter --update
# rkhunter --propupd
#
# resources:
# https://www.vultr.com/docs/how-to-install-rkhunter-on-ubuntu
# https://www.albennet.com/installrkhunter.php


# TODO:
# Unclear if these packages are needed:
# software-properties-common python-software-properties
