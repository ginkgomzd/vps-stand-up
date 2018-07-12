
this-dir := $(dir $(lastword $(MAKEFILE_LIST)))

REPLACE_CMD := $(this-dir)../bin/replace_file
PATCH_FILE_CMD := $(this-dir)../bin/patch_file

all: conf.server.mysql conf.server.postfix conf.server.dkim

conf.server.mysql: conf.server.mysql.file-limits
	$(MAKE) -f $(this-dir)conf.server.mysql.mk
	@ touch $(@)

conf.server.postfix:
	echo 'postfix	postfix/protocols	select	all\
	postfix	postfix/root_address	string	clients@ginkgostreet.com\
	postfix	postfix/procmail	boolean	false\
	postfix	postfix/mailbox_limit	string	51200000\
	postfix	postfix/recipient_delim	string	+\
	postfix	postfix/chattr	boolean	false\
	postfix	postfix/compat_conversion_warning	boolean	true\
	postfix	postfix/rfc1035_violation	boolean	false\
	postfix	postfix/destinations	string	$$myhostname, $(STANDUP_FQDN), localhost.$(STANDUP_DOMAIN) ,\ localhost\
	postfix	postfix/mynetworks	string	127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128\
	postfix	postfix/main_mailer_type	select	Internet Site\
	postfix	postfix/mailname	string	$(STANDUP_FQDN)\
	postfix	postfix/main_cf_conversion_warning	boolean	true\' \
	| debconf-set-selections
	dpkg-reconfigure -f noninteractive postfix
	@ touch $(@)

conf.server.dkim: conf.server.postfix
	$(MAKE) -f make/conf.server.dkim.mk
	@ touch $(@)

.PHONY: back-up-sshd-keys
back-up-sshd-keys:
	- mkdir sshd.keys
	for KEYFILE in `ls -1 ssh/ssh_host*key*`; \
	do \
		mv $$KEYFILE sshd.keys/$$KEYFILE-$(shell date +"%Y%m%d.%H%M");\
	done

conf.server.sshd.keys: back-up-sshd-keys
	ssh-keygen -f ssh/ssh_host_rsa_key     -N '' -t rsa
	ssh-keygen -f ssh/ssh_host_dsa_key     -N '' -t dsa
	ssh-keygen -f ssh/ssh_host_ecdsa_key   -N '' -t ecdsa
	ssh-keygen -f ssh/ssh_host_ed22519_key -N '' -t ed25519
	service sshd restart
	@ touch $(@)
