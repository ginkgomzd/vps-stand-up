
CHECK_SHA384 := $(shell wget -q https://composer.github.io/installer.sig -O -)
INSTALL_DIR := '/usr/local/share/composer'
INSTALL_BIN := '/usr/local/bin/composer'

install: verify install-composer.php
	php install-composer.php --install-dir=$(INSTALL_DIR) --filename=composer
	ln -s $(INSTALL_DIR)/composer $(INSTALL_BIN)

check.sha384:
	echo $(CHECK_SHA384) install-composer.php > check.sha384

install-composer.php:
	wget -q 'https://getcomposer.org/installer' -O 'install-composer.php'

.PHONY: verify
verify: check.sha384 install-composer.php
	sha384sum -c check.sha384

clean:
	rm check.sha384
	rm install-composer.php
