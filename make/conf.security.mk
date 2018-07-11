
this-dir := $(dir $(lastword $(MAKEFILE_LIST)))

REPLACE_CMD := $(this-dir)../bin/replace_file

# TODO:
# all:

conf.security.fail2ban:
	$(REPLACE_CMD) fail2ban/paths-overrides.local
	$(REPLACE_CMD) fail2ban/jail.local
	$(REPLACE_CMD) fail2ban/filter.d
	sudo service fail2ban restart
	@ touch $(@)
