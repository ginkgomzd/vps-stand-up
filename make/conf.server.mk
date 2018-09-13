
this-dir := $(dir $(lastword $(MAKEFILE_LIST)))
include $(this-dir)/inc.functions.mk

REPLACE_CMD := $(this-dir)../bin/replace_file
PATCH_FILE_CMD := $(this-dir)../bin/patch_file

all: conf.server.mysql conf.server.postfix conf.server.dkim

conf.server.mysql:
	$(MAKE) -f $(this-dir)conf.server.mysql.mk
	@ touch $(@)

postfix/protocols := postfix	postfix/protocols	select	all
postfix/root_address := postfix	postfix/root_address	string	clients@ginkgostreet.com
postfix/procmail := postfix	postfix/procmail	boolean	false
postfix/mailbox_limit := postfix	postfix/mailbox_limit	string	51200000
postfix/recipient_delim := postfix	postfix/recipient_delim	string	+
postfix/chattr := postfix	postfix/chattr	boolean	false
postfix/compat_conversion_warning := postfix	postfix/compat_conversion_warning	boolean	true'
postfix/rfc1035_violation := postfix	postfix/rfc1035_violation	boolean	false
postfix/destinations := postfix	postfix/destinations	string	\\$$myhostname, $(STANDUP_FQDN), localhost.$(STANDUP_DOMAIN) , localhost
postfix/mynetworks := postfix	postfix/mynetworks	string	127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128
postfix/main_mailer_type := postfix	postfix/main_mailer_type	select	Internet Site
postfix/mailname := postfix	postfix/mailname	string	$(STANDUP_FQDN)
postfix/main_cf_conversion_warning := postfix	postfix/main_cf_conversion_warning	boolean	true

conf.server.postfix:
	$(call debconf-set-selection,$(postfix/protocols))
	$(call debconf-set-selection,$(postfix/root_address))
	$(call debconf-set-selection,$(postfix/procmail))
	$(call debconf-set-selection,$(postfix/mailbox_limit))
	$(call debconf-set-selection,$(postfix/recipient_delim))
	$(call debconf-set-selection,$(postfix/chattr))
	$(call debconf-set-selection,$(postfix/compat_conversion_warning))
	$(call debconf-set-selection,$(postfix/rfc1035_violation))
	$(call debconf-set-selection,$(postfix/destinations))
	$(call debconf-set-selection,$(postfix/mynetworks))
	$(call debconf-set-selection,$(postfix/main_mailer_type))
	$(call debconf-set-selection,$(postfix/mailname))
	$(call debconf-set-selection,$(postfix/main_cf_conversion_warning))
	dpkg-reconfigure -f noninteractive postfix
	@ touch $(@)

conf.server.dkim: conf.server.postfix
	$(MAKE) -f make/conf.server.dkim.mk
	@ touch $(@)

.PHONY: back-up-sshd-keys
back-up-sshd-keys:
	- mkdir -p sshd.keys/etc/ssh
	for KEYFILE in `ls -1 /etc/ssh/ssh_host*key*`; \
	do \
		mv $$KEYFILE sshd.keys$$KEYFILE-$(shell date +"%Y%m%d.%H%M");\
	done

conf.server.sshd.keys: back-up-sshd-keys
	ssh-keygen -f /etc/ssh/ssh_host_rsa_key     -N '' -t rsa
	ssh-keygen -f /etc/ssh/ssh_host_dsa_key     -N '' -t dsa
	ssh-keygen -f /etc/ssh/ssh_host_ecdsa_key   -N '' -t ecdsa
	ssh-keygen -f /etc/ssh/ssh_host_ed22519_key -N '' -t ed25519
	service sshd restart
	@ touch $(@)

conf.server.sshd.port:
	$(REPLACE_CMD) ssh/port22-deprecated.txt
	$(REPLACE_CMD) ssh/sshd_config
	service sshd restart
	@ touch $(@)

conf.server.ssl:
	nslookup $(STANDUP_FQDN).
	certbot --apache --allow-subset-of-names -d $(STANDUP_FQDN)
	@ touch $(@)
