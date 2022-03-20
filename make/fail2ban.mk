
include functions.mk

#
# https://linuxize.com/post/install-configure-fail2ban-on-ubuntu-20-04/
#

conf.fail2ban:
	${REPLACE_ETC} fail2ban/jail.local
	${REPLACE_ETC} fail2ban/filter.d
	systemctl restart fail2ban
	@ touch $@
