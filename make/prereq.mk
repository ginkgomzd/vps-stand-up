# include file

PREREQ_PACKAGES ?= wget git debconf-utils zip unzip curl bash-completion

prereq: prereq.packages prereq.keyscan

prereq.packages:
	$(foreach pkg,${PREREQ_PACKAGES},$(call install-pgk,${pkg}))
	touch $@

KEYSCAN_HOSTS ?= github.com

define keyscan
	ssh-keyscan -H $1 >> ~/.ssh/known_hosts

endef

prereq.keyscan:
	test -d ~/.ssh || mkdir ~/.ssh
	$(foreach host,${KEYSCAN_HOSTS}, $(call keyscan, ${host}))
	touch $@
