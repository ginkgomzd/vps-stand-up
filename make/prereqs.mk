
PACKAGES ?= wget git debconf-utils zip unzip curl bash-completion

default: prereqs.packages prereqs.keyscan

define install-pkg
	dpkg -s $1 >/dev/null || sudo -E apt-get -y install $1

endef

prereqs.packages: export DEBIAN_FRONTEND ?= noninteractive
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
