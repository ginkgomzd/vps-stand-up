
this-dir := $(dir $(lastword $(MAKEFILE_LIST)))
include $(this-dir)/inc.functions.mk

all: server.lamp server.apache-mods server.dkim server.certbot

server.lamp:
	apt-get update
	# install lamp-server meta-package (^)
	# -y because, for some reason, non-interactive is not enough; maybe because is a meta-package?
	apt-get -yq install lamp-server^
	@ touch $(@)

server.postfix:
	$(call install-package, postfix)

server.apache-mods:
	a2enmod rewrite
	a2enmod ssl
	apachectl restart
	@ touch $(@)

server.certbot:
	$(call install-package, certbot)
	$(call install-package, python-certbot-apache)
	@touch $(@)

server.dkim:
	$(call install-package, opendkim)
	@touch $(@)
