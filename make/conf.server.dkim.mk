
this-dir := $(dir $(lastword $(MAKEFILE_LIST)))

REPLACE_CMD := $(this-dir)../bin/replace_file

host_selector = $(shell hostname -s )
host_domain = $(shell hostname -d )

all: dkim conf.server.dkim.deploy-keys conf.server.dkim.deploy-conf
	service opendkim restart
	@ echo "DKIM configuration completed. Update DNS with information in `pwd`/dkim/$host_selector.txt:"

dkim:
	mkdir dkim

$(host_selector).private $(host_seletor).txt:
	opendkim-genkey --directory=./dkim --verbose --domain=$(host_domain) --selector=$(host_selector)

# [ -d /etc/opendkim ] || mkdir /etc/opendkim
# [ -d /etc/dkimkeys ] || mkdir /etc/dkimkeys

conf.server.dkim.deploy-keys: $(host_selector).private $(host_seletor).txt
	cp ./dkim/$(host_selector).private /etc/dkimkeys/$(host_selector).private
	echo "$(host_selector)._domainkey.$(host_domain)	$(host_domain):$(host_domain):/etc/dkimkeys/$(host_selector).private" >> /etc/opendkim/keyfile
	echo "*@$(host_domain)	$(host_seletor)._domainkey.$(host_domain)" >> /etc/opendkim/signing
	chown -R opendkim:opendkim /etc/dkimkeys /etc/opendkim
	@ touch $(@)

define postfix.dkim
if [ ! -f /etc/postfix/main.cf ]; then \
	echo "Skipping dkim config for postfix: not found."; \
else \
	grep "smtpd_milters = inet:localhost:8891" /etc/postfix/main.cf > /dev/null || cat sys-utils/linode-etc/postfix/main.cf.opendkim >> /etc/postfix/main.cf ; \
	service postfix restart; \
fi
endef

conf.server.dkim.deploy-conf:
	$(REPLACE_CMD) opendkim.conf
	$(REPLACE_CMD) default/opendkim
	$(postfix.dkim)
	@ touch $(@)
