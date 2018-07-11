
this-dir := $(dir $(lastword $(MAKEFILE_LIST)))

REPLACE_CMD := $(this-dir)../bin/replace_file

all: conf.d memory

.PHONY: conf.d
conf.d:
	$(REPLACE_CMD) mysql/mysql.conf.d

.PHONY: memory
memory:
	# Check for higher-memory VPS configurations
	if [ $(memTotal) -gt 3000 ]; then \
		$(REPLACE_CMD) mysql/mysql.conf.d/innodb.cnf-8gb && \
		mv -f /etc/mysql/mysql.conf.d/innodb.cnf-8gb /etc/mysql/mysql.conf.d/innodb.cnf; \
	fi

define memTotal
$$(( $(shell grep MemTotal /proc/meminfo | sed -E 's/[ ]+/\t/g' | cut -f 2) / 1024 ))
endef
