
this-dir := $(dir $(lastword $(MAKEFILE_LIST)))

REPLACE_CMD := $(this-dir)../bin/replace_file

conf.server.mysql: conf.d memory
	service mysql restart
	@ touch $(@)

.PHONY: conf.d
conf.d:
 	$(REPLACE_CMD) mysql/mysql.conf.d

.PHONY: memory
memory:
	# Check for higher-memory VPS configurations
	echo $(memTotal)
	[ $(memTotal) -gt 7000 ] && REPLACE_CMD mysql/mysql.conf.d/innodb.cnf-8gb && \
	mv -f /etc/mysql/mysql.conf.d/innodb.cnf-8gb /etc/mysql/mysql.conf.d/innodb.cnf

define memTotal
	memTotal = $(shell grep MemTotal /proc/meminfo | awk '{print $2}')
	$(shell $(memTotal) / 1024)
endef
