
all: install clean-up

wp-cli.latest:
	wget -q 'https://github.com/wp-cli/builds/raw/gh-pages/deb/php-wpcli_latest_all.deb' -O wp-cli.latest

wp-cli.deb: wp-cli.latest
	wget -q 'https://github.com/wp-cli/builds/raw/gh-pages/deb/'$(shell cat wp-cli.latest) -O 'wp-cli.deb'

.PHONY: install
install: wp-cli.deb
	sudo dpkg -i wp-cli.deb

.PHONY: clean-up
clean-up:
	rm -f wp-cli.deb
	rm -f php-wpcli_latest_all.deb
