
all: vendor.keyscan vendor/linode-etc vendor/backup-mysql vendor/env-utils vendor/bad-bot-blocker vendor/rkhunter

vendor.keyscan:
	test -d ~/.ssh || mkdir ~/.ssh
	ssh-keyscan -H github.com >> ~/.ssh/known_hosts
	ssh-keyscan -H bitbucket.org >> ~/.ssh/known_hosts

vendor/linode-etc:
	git clone git@bitbucket.org:ginkgostreet/linode-etc.git vendor/linode-etc

vendor/backup-mysql:
	git clone git@bitbucket.org:ginkgostreet/backup-mysql.git vendor/backup-mysql

vendor/env-utils:
	git clone git@bitbucket.org:ginkgostreet/env-utils-v3.git vendor/env-utils
	cd vendor/env-utils && \
	git checkout linode-1.0

vendor/bad-bot-blocker:
	git clone git@github.com:ginkgostreet/bad-bot-blocker.git vendor/bad-bot-blocker

vendor/rkhunter:
	wget https://sourceforge.net/projects/rkhunter/files/rkhunter/1.4.6/rkhunter-1.4.6.tar.gz
	cd vendor && tar xzf ../rkhunter-1.4.6.tar.gz --xform="s/rkhunter-1.4.6/rkhunter/"
	rm rkhunter-1.4.6.tar.gz
