
this-dir := $(dir $(lastword $(MAKEFILE_LIST)))
include $(this-dir)/inc.functions.mk

all: server.lamp server.certbot

server.lamp:
	# install lamp-server meta-package (^)
	# -y because, for some reason, non-interactive is not enough; maybe because is a meta-package?
	sudo apt -yq install lamp-server^
	@ touch server.lamp

server.certbot:
	$(call install-package, certbot)
	@touch server.certbot
