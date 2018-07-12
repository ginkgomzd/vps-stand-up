
this-dir := $(dir $(lastword $(MAKEFILE_LIST)))
include $(this-dir)/inc.functions.mk

REPLACE_CMD := $(this-dir)../bin/replace_file

# TODO:
# all:

conf.system.gsl-logo:
	$(REPLACE_CMD) gsl-motd-logo.txt
	$(REPLACE_CMD) update-motd.d/00-0logo
	$(call install-package, fortunes)
	$(call install-package, fortunes-bofh-excuses)
	$(call install-package, fortune-mod)
	$(call install-package, fortunes-min)
	@ touch conf.system.gsl-logo

# TODO: dkim
conf.system.dkim:
	$(this-dir)/../bin/075-opendkim
	@ touch $(@)

conf.system.sudoers:
	test -d /etc/sudoers.d || exit 1
	$(REPLACE_CMD) sudoers.d/logging
	$(REPLACE_CMD) sudoers.d/maint
	@ touch $(@)

conf.system.logwatch: logwatch.conf logwatch.scripts

.PHONY: logwatch.conf
logwatch.conf:
	test -d /etc/logwatch/conf || exit 1
	$(REPLACE_CMD) logwatch/conf/logwatch.conf
	$(REPLACE_CMD) logwatch/conf/logfiles/http.conf
	$(REPLACE_CMD) logwatch/conf/logfiles/http-error.conf

.PHONY: logwatch.scripts
logwatch.scripts:
	test -d /etc/logwatch/scripts/services || exit 1
	$(REPLACE_CMD) logwatch/scripts/services/sshd
	$(REPLACE_CMD) logwatch/scripts/services/sudo

conf.system.logrotate:
	test -d /etc/logrotate.d || exit 1
	$(REPLACE_CMD) logrotate.d/apache2
	@ touch $(@)

conf.system.updates:
	$(this-dir)/../bin/015-unattended-upgrades
	@ touch $(@)
