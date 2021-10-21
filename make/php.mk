

# # #
# https://linuxize.com/post/how-to-install-php-8-on-ubuntu-20-04/
#

install: repository apache-module extensions

repository:
	apt install -y software-properties-common
	add-apt-repository ppa:ondrej/php

apache-module:
	apt update
	apt install -y php8.0 libapache2-mod-php8.0

PHP80_EXTENSIONS ?= php8.0-mysql php8.0-gd php8.0-curl php8.0-bcmath php8.0-mbstring php8.0-zip php8.0-intl php8.0-xml

extensions:
	apt install -y ${PHP80_EXTENSIONS}
