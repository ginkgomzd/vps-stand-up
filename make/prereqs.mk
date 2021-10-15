# include file

PACKAGES ?= wget git debconf-utils zip unzip curl bash-completion

prereqs: prereqs.packages prereqs.keyscan

prereqs.packages:
	$(foreach pkg,${PACKAGES},$(call install-pgk,${pkg}))
	touch $@

KEYSCAN_HOSTS ?= github.com

define keyscan
	ssh-keyscan -H $1 >> ~/.ssh/known_hosts

endef

prereqs.keyscan:
	test -d ~/.ssh || mkdir ~/.ssh
	$(foreach host,${KEYSCAN_HOSTS}, $(call keyscan, ${host}))
	touch $@
