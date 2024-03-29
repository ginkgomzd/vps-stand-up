
this-dir := $(dir $(lastword $(MAKEFILE_LIST)))
include $(this-dir)/inc.functions.mk

all: wget git debconf-utils repo.certbot prereqs.keyscan

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

.PHONY: unzip
unzip:
	$(call install-package, unzip)

prereqs.keyscan:
	test -d ~/.ssh || mkdir ~/.ssh
	ssh-keyscan -H github.com >> ~/.ssh/known_hosts
	ssh-keyscan -H bitbucket.org >> ~/.ssh/known_hosts
	touch $(@)
