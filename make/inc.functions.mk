
define install-package
	@# sudo -E to preserve environment
	dpkg -s $1 >/dev/null || \
	sudo -E apt-get -y install $1
endef
