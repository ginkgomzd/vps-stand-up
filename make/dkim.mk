
#
# NEEDS WORK!
#


HOST_SELECTOR ?= $(shell hostname -s )
HOST_DOMAIN ?= $(shell hostname -d )

all: dkim conf.dkim.deploy-keys conf.dkim.deploy-conf
	service opendkim restart
	@ echo "DKIM configuration completed. Update DNS with information in `pwd`/dkim/${HOST_SELECTOR}.txt:"

dkim:
	mkdir dkim

dkim/${HOST_SELECTOR}.private dkim/${HOST_SELECTOR}.txt:
	opendkim-genkey --directory=./dkim --verbose --domain=${HOST_DOMAIN} --selector=${HOST_SELECTOR}

# [ -d /etc/opendkim ] || mkdir /etc/opendkim
# [ -d /etc/dkimkeys ] || mkdir /etc/dkimkeys

conf.dkim.deploy-keys: dkim/${HOST_SELECTOR}.private dkim/${HOST_SELECTOR}.txt
	- mkdir /etc/dkimkeys /etc/opendkim
	cp ./dkim/${HOST_SELECTOR}.private /etc/dkimkeys/${HOST_SELECTOR}.private
	echo "${HOST_SELECTOR}._domainkey.${HOST_DOMAIN}	${HOST_DOMAIN}:${HOST_DOMAIN}:/etc/dkimkeys/${HOST_SELECTOR}.private" >> /etc/opendkim/keyfile
	echo "*@${HOST_DOMAIN}	${HOST_SELECTOR}._domainkey.${HOST_DOMAIN}" >> /etc/opendkim/signing
	# not working on Ubuntu 20.04:
	# chown -R opendkim:opendkim /etc/dkimkeys /etc/opendkim
	@ touch $@

define postfix.dkim
if [ ! -f /etc/postfix/main.cf ]; then \
	echo "Skipping dkim config for postfix: not found."; \
else \
	grep "smtpd_milters = inet:localhost:8891" /etc/postfix/main.cf > /dev/null || cat sys-utils/ubuntu-etc-confs/postfix/main.cf.opendkim >> /etc/postfix/main.cf ; \
	service postfix restart; \
fi
endef

conf.dkim.deploy-conf:
	${REPLACE_ETC} opendkim.conf
	${REPLACE_ETC} default/opendkim
	$(shell ${postfix.dkim})
	@ touch $(@)
