
this-dir := $(dir $(lastword $(MAKEFILE_LIST)))
include $(this-dir)/inc.functions.mk

all: server.lamp server.apache-mods server.certbot

server.lamp:
	# install lamp-server meta-package (^)
	# -y because, for some reason, non-interactive is not enough; maybe because is a meta-package?
	sudo apt -yq install lamp-server^
	@ touch $(@)

# TODO: find out why we are doing these:
server.apache-mods:
	$(call install-package, apache2)
	$(call install-package, apache2-bin)
	$(call install-package, apache2-data)
	$(call install-package, apache2-utils)
	a2enmod rewrite
	a2enmod ssl
	apachectl restart

server.certbot:
	$(call install-package, certbot)
	@touch $(@)

server.dkim:
	$(call install-package, opendkim)
	@touch $(@)
