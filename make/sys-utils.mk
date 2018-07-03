
all: sys-utils/linode-etc sys-utils/backup-mysql sys-utils/env-utils sys-utils/bad-bot-blocker sys-utils/rkhunter

sys-utils.keyscan:
	test -d ~/.ssh || mkdir ~/.ssh
	ssh-keyscan -H github.com >> ~/.ssh/known_hosts
	ssh-keyscan -H bitbucket.org >> ~/.ssh/known_hosts
	touch sys-utils.keyscan

sys-utils/linode-etc: sys-utils.keyscan
	git clone git@bitbucket.org:ginkgostreet/linode-etc.git sys-utils/linode-etc

sys-utils/backup-mysql: sys-utils.keyscan
	git clone git@bitbucket.org:ginkgostreet/backup-mysql.git sys-utils/backup-mysql

sys-utils/env-utils: sys-utils.keyscan
	git clone git@bitbucket.org:ginkgostreet/env-utils-v3.git sys-utils/env-utils
	cd sys-utils/env-utils && \
	git checkout linode-1.0

sys-utils/bad-bot-blocker: sys-utils.keyscan
	git clone git@github.com:ginkgostreet/bad-bot-blocker.git sys-utils/bad-bot-blocker

sys-utils/rkhunter:
	wget https://sourceforge.net/projects/rkhunter/files/rkhunter/1.4.6/rkhunter-1.4.6.tar.gz
	cd sys-utils && tar xzf ../rkhunter-1.4.6.tar.gz --xform="s/rkhunter-1.4.6/rkhunter/"
	rm rkhunter-1.4.6.tar.gz

.PHONY: sys-utils.clean
sys-utils.clean:
	rm -rf sys-utils/
	rm -f sys-utils.keyscan
