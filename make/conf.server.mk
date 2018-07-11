
this-dir := $(dir $(lastword $(MAKEFILE_LIST)))

REPLACE_CMD := $(this-dir)../bin/replace_file
PATCH_FILE_CMD := $(this-dir)../bin/patch_file

conf.server.mysql:
	$(MAKE) -f $(this-dir)conf.server.mysql.mk
	# Open-file Limits:
	$(PATCH_FILE_CMD) pam.d/common-session
	$(PATCH_FILE_CMD) pam.d/common-session-noninteractive
	$(PATCH_FILE_CMD) /usr/sbin/pam-auth-update
	$(REPLACE_CMD) security/limits.d/01-mysql.conf
	$(REPLACE_CMD) sysctl.d/20-open-files.conf
	$(REPLACE_CMD) systemd/system/mysql.service.d/override.conf
	systemctl daemon-reload
	# End Open-File Limits;
	service mysql restart
	@ touch $(@)

conf.server.postfix:
	$(this-dir)../bin/070-postfix
