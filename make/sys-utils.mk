
this-dir := $(dir $(lastword $(MAKEFILE_LIST)))
include $(this-dir)/inc.functions.mk

all: sys-utils/keyscan sys-utils/linode-etc sys-utils/backup-mysql sys-utils/env-utils sys-utils/dkim-tools /usr/local/sbin/mysqltuner

sys-utils/keyscan:
	test -d ~/.ssh || mkdir ~/.ssh
	ssh-keyscan -H github.com >> ~/.ssh/known_hosts
	ssh-keyscan -H bitbucket.org >> ~/.ssh/known_hosts
	touch sys-utils/keyscan

sys-utils/linode-etc: sys-utils/keyscan
	git clone git@bitbucket.org:ginkgostreet/linode-etc.git sys-utils/linode-etc

sys-utils/backup-mysql: sys-utils/keyscan
	git clone git@bitbucket.org:ginkgostreet/backup-mysql.git sys-utils/backup-mysql

sys-utils/env-utils: sys-utils/keyscan
	git clone git@bitbucket.org:ginkgostreet/env-utils-v3.git sys-utils/env-utils
	cd sys-utils/env-utils && \
	git checkout linode-1.0

sys-utils/dkim-tools:
	$(call install-package, opendkim-tools)
	@ touch sys-utils/dkim-tools

/usr/local/sbin/mysqltuner:
	wget "http://mysqltuner.pl" -O /usr/local/sbin/mysqltuner
	chmod a+x /usr/local/sbin/mysqltuner

.PHONY: sys-utils.clean
sys-utils.clean:
	rm -rf sys-utils/
	rm -f sys-utils/keyscan
