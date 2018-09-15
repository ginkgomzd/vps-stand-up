
this-dir := $(dir $(lastword $(MAKEFILE_LIST)))
include $(this-dir)/inc.functions.mk

# NOTE: assume we are running composer as root:
# --no-plugins --no-scripts to avoid third-party code
# see https://getcomposer.org/root
CMP_CMD := composer --no-plugins --no-scripts

# TODO: fix web-utils.wpcli
install: web-utils.composer web-utils.drush8 web-utils.cv

web-utils.composer:
	$(MAKE) -f $(this-dir)/composer.mk
	touch web-utils.composer

web-utils.drush8: /usr/local/bin/drush web-utils.composer
	touch web-utils.drush8

# TODO: don't use composer to install drush
# http://docs.drush.org/en/8.x/install/
#  Browse to https://github.com/drush-ops/drush/releases and download the drush.phar attached to the latest 8.x release.
#
# # Test your install.
# php drush.phar core-status
#
# # Rename to `drush` instead of `php drush.phar`. Destination can be anywhere on $PATH.
# chmod +x drush.phar
# sudo mv drush.phar /usr/local/bin/drush
#
# # Optional. Enrich the bash startup file with completion and aliases.
# drush init

/usr/local/bin/drush:
	test -d /usr/local/share/drush8 || mkdir /usr/local/share/drush8
	cd /usr/local/share/drush8 && $(CMP_CMD) require drush/drush:^8
	ln -s /usr/local/share/drush8/vendor/drush/drush/drush /usr/local/bin/drush

# TODO: doubt this is needed:
# # Explicitly use PHP 5.6 for Drush if it's there
# [ -x /usr/bin/php5.6 ] && replace_file profile.d/drush.sh

# TODO: fails because it requires php7.1, and we are getting 7.2 from lamp-server
web-utils.wpcli: /usr/local/bin/wp
	$(MAKE) -f $(this-dir)/wp-cli.mk
	touch web-utils.wpcli

web-utils.cv: /usr/local/bin/cv
	wget https://download.civicrm.org/cv/cv.phar -O /usr/local/bin/cv
	chmod 755 /usr/local/bin/cv
	touch web-utils.cv

.PHONY: uninstall-drush8
uninstall-drush8:
	# uninstall drush8
	composer global remove --no-plugins --no-scripts drush/drush
	rm -f /usr/local/bin/drush
	rm -rf /usr/local/share/drush8
	rm -f web-utils.drush8

.PHONY: uninstall-composer
uninstall-composer:
	rm -f /usr/local/bin/composer
	rm -rf /root/.config/composer
	rm -f web-utils.composer

.PHONY: uninstall-cv
uninstall-cv:
	rm -f /usr/local/bin/cv
	rm -f web-utils.cv
