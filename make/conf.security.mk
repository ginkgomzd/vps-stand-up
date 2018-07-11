
this-dir := $(dir $(lastword $(MAKEFILE_LIST)))

REPLACE_CMD := $(this-dir)/../bin/replace_file

# TODO:
# all:

conf.security.fail2ban:
	test -d /etc/fail2ban || exit 1
	$(REPLACE_CMD) fail2ban/paths-overrides.local
	$(REPLACE_CMD) fail2ban/jail.local
	cp -vp $(this-dir)/../vendor/linode-etc/fail2ban/filter.d/* /etc/fail2ban/filter.d
	sudo service fail2ban restart
