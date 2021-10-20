

# # #
# https://linuxize.com/post/how-to-install-php-8-on-ubuntu-20-04/
#

install: repository apache-module extensions

repository:
	apt install software-properties-common
	add-apt-repository ppa:ondrej/php

apache-module:
	apt update
	apt install php8.0 libapache2-mod-php8.0

extensions:
	apt install php8.0-mysql php8.0-gd
