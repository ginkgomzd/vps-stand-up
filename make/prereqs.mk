
this-dir := $(dir $(lastword $(MAKEFILE_LIST)))
include $(this-dir)/inc.functions.mk

all: wget git debconf-utils repo.certbot

.PHONY: wget
wget:
	$(call install-package, wget)

.PHONY: git
git:
	$(call install-package, git)

.PHONY: debconf-utils
debconf-utils:
	$(call install-package, debconf-utils)

repo.certbot:
	# Add the repo for CertBot/Let's Encrypt
	sudo add-apt-repository -y ppa:certbot/certbot
	touch repo.certbot
