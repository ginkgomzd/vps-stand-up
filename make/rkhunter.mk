
RKHUNTER_VER := 1.4.6

/usr/local/bin/rkhunter: /usr/local/share/rkhunter
	cd /usr/local/share/rkhunter && \
	./installer.sh --install > /dev/null

/usr/local/share/rkhunter:
	cd /usr/local/share && \
	wget https://sourceforge.net/projects/rkhunter/files/rkhunter/$(RKHUNTER_VER)/rkhunter-$(RKHUNTER_VER).tar.gz -O rkhunter.tar.gz
	cd /usr/local/share && \
	tar xzf rkhunter.tar.gz --xform="s/rkhunter-$(RKHUNTER_VER)/rkhunter/"
	rm /usr/local/share/rkhunter.tar.gz

.PHONY: clean
clean:
	rm -rf /usr/local/share/rkhunter /usr/local/bin/rkhunter

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
