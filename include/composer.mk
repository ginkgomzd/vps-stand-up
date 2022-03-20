
CHECK_SHA384 := $(shell curl https://composer.github.io/installer.sig)
INSTALL_PATH := '/usr/local/bin'

all: install clean-up

.PHONY: install
install: verify install-composer.php
	php install-composer.php --install-dir=$(INSTALL_PATH) --filename=composer

install-composer.php:
		curl 'https://getcomposer.org/installer' -o 'install-composer.php'

check.sha384:
	echo $(CHECK_SHA384) install-composer.php > check.sha384

.PHONY: verify
verify: check.sha384 install-composer.php
	sha384sum -c check.sha384

.PHONY: clean-up
clean-up:
	rm check.sha384
	rm install-composer.php

.PHONY: uninstall-composer
uninstall-composer:
	rm -f /usr/local/bin/composer
	rm -rf /root/.config/composer
	rm -f web-utils.composer
