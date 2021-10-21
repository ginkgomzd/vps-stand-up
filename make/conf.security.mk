
REPLACE_CMD := bin/replace_etc_file

# TODO: define all: target

conf.security.fail2ban:
	$(REPLACE_CMD) fail2ban/paths-overrides.local
	$(REPLACE_CMD) fail2ban/jail.local
	$(REPLACE_CMD) fail2ban/filter.d
	sudo service fail2ban restart
	@ touch $@
