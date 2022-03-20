
# # #
# https://linuxize.com/post/how-to-install-php-8-on-ubuntu-20-04/
#

include functions.mk

install: repository apache-module extensions

repository:
	$(call install-pkg,software-properties-common)
	add-apt-repository -y ppa:ondrej/php

apache-module:
	apt update
	$(foreach pkg,php8.0 libapache2-mod-php8.0,$(call install-pkg,${pkg}))

PHP80_EXTENSIONS ?= php8.0-mysql php8.0-gd php8.0-curl php8.0-bcmath php8.0-mbstring php8.0-zip php8.0-intl php8.0-xml

extensions:
	$(foreach pkg,${PHP80_EXTENSIONS},$(call install-pkg,${pkg}))
