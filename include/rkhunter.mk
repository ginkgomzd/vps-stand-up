
include functions.mk

# resources:
# https://blog.eldernode.com/install-rkhunter-on-ubuntu/ (20.04)
# https://www.vultr.com/docs/how-to-install-rkhunter-on-ubuntu (16.04)
# https://www.albennet.com/installrkhunter.php

#
# Letting Ubuntu manage the databases. Hopefully this is correct.
# so, not using: rkhunter --update --nocolors 
# Enabling cron with customizations to /etc/default/rkhunter

conf.rkhunter:
	@# if overrides are present, will copy to /etc:
	-${REPLACE_ETC} default/rkhunter
	-rkhunter --pkgmgr DPKG --check --skip-keypress
	rkhunter --propupd
	@ touch $@
