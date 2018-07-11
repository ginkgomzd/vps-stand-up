
/usr/local/bin/rkhunter: /usr/local/share/rkhunter
	cd /usr/local/share && \
	./installer.sh --install

/usr/local/share/rkhunter:
	cd /usr/local/share && \
	wget https://sourceforge.net/projects/rkhunter/files/rkhunter/1.4.6/rkhunter-1.4.6.tar.gz -O rkhunter.tar.gz
	tar xzf ../rkhunter-1.4.6.tar.gz --xform="s/rkhunter-1.4.6/rkhunter/"

clean:
	rm -f rkhunter.tar.gz

# TODO:
# don't think the following should have been part of the install:
# Set-up a cron-job?
#
# rkhunter --pkgmgr DPKG --check --skip-keypress
# rkhunter --update
# rkhunter --propupd
#
# resources:
# https://www.vultr.com/docs/how-to-install-rkhunter-on-ubuntu
# https://www.albennet.com/installrkhunter.php
