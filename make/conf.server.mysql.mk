
this-dir := $(dir $(lastword $(MAKEFILE_LIST)))

REPLACE_CMD := $(this-dir)../bin/replace_file
PATCH_FILE_CMD := $(this-dir)../bin/patch_file

all: conf.d memory conf.server.mysql.file-limits
	service mysql restart

.PHONY: conf.d
conf.d:
	$(REPLACE_CMD) mysql/mysql.conf.d

define memTotal
$$(( $(shell grep MemTotal /proc/meminfo | sed -E 's/[ ]+/\t/g' | cut -f 2) / 1024 ))
endef

.PHONY: memory
memory:
	# Check for higher-memory VPS configurations
	if [ $(memTotal) -gt 7000 ]; then \
		$(REPLACE_CMD) mysql/mysql.conf.d/innodb.cnf-8gb && \
		mv -f /etc/mysql/mysql.conf.d/innodb.cnf-8gb /etc/mysql/mysql.conf.d/innodb.cnf; \
	fi

conf.server.mysql.file-limits: conf.server.pam_limits
	# Open-file Limits:
	$(REPLACE_CMD) sysctl.d/20-open-files.conf
	$(REPLACE_CMD) security/limits.d/01-mysql.conf
	$(REPLACE_CMD) systemd/system/mysql.service.d/override.conf
	systemctl daemon-reload
	# End Open-File Limits;
	@ touch $(@)

# For Mysql Open-File limit optimization:
# enable the pam_limits.so module
conf.server.pam_limits:
	$(PATCH_FILE_CMD) pam.d/common-session
	$(PATCH_FILE_CMD) pam.d/common-session-noninteractive
	@ touch $(@)
