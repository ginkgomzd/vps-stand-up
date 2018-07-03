
this-dir := $(dir $(lastword $(MAKEFILE_LIST)))
include $(this-dir)/inc.functions.mk

all: security.fail2ban security.rkhunter

security.fail2ban:
	$(call install-package, fail2ban)
	@ touch security.fail2ban

security.rkhunter:
	cd vendor/rkhunter/ && ./installer.sh --install
	@ touch security.rkhunter

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
