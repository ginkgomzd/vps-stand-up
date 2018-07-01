
define install-package
	dpkg -s $1 >/dev/null || \
	sudo apt-get install $1
endef
