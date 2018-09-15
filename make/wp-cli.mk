
all: install clean-up

wp-cli.phar:
	curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

.PHONY: install
install: wp-cli.phar
	php wp-cli.phar --info
	chmod +x wp-cli.phar
	mv wp-cli.phar /usr/local/bin/wp
	# verify:
	wp --info

.PHONY: clean-up
clean-up:
	rm -f wp-cli.phar
