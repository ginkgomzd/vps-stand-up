
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

# NOTE: assume we are running composer as root:
# --no-plugins --no-scripts to avoid third-party code
# see https://getcomposer.org/root
CMP_CMD := composer --no-plugins --no-scripts

install:
	test -d /usr/local/share/drush8 || mkdir /usr/local/share/drush8
	cd /usr/local/share/drush8 && $(CMP_CMD) require drush/drush:^8
	ln -s /usr/local/share/drush8/vendor/drush/drush/drush /usr/local/bin/drush

# TODO: doubt this is needed:
# # Explicitly use PHP 5.6 for Drush if it's there
# [ -x /usr/bin/php5.6 ] && replace_file profile.d/drush.sh

.PHONY: uninstall-drush8
uninstall-drush8:
	# uninstall drush8
	composer global remove --no-plugins --no-scripts drush/drush
	rm -f /usr/local/bin/drush
	rm -rf /usr/local/share/drush8
	rm -f web-utils.drush8

