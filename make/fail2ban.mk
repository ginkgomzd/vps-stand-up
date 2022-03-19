
conf.fail2ban: pkg.fail2ban
	${REPLACE_ETC} fail2ban/paths-overrides.local
	${REPLACE_ETC} fail2ban/jail.local
	${REPLACE_ETC} fail2ban/filter.d
	sudo service fail2ban restart
	@ touch $@

pkg.fail2ban:
	$(call install-pkg, fail2ban)
	@ touch $@
