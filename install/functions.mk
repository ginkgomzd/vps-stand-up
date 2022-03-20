
# # #
# Helper Functions
# # #

export DEBIAN_FRONTEND ?= noninteractive

export REPLACE_ETC := bin/replace_etc_file

export PATCH_FILE_CMD := bin/patch_file

# sudo -E to preserve environment
# i.e. DEBIAN_FRONTEND=noninteractive
export define install-pkg
	dpkg -s $1 >/dev/null || sudo -E apt-get -y install $1

endef

%.pkg:
	$(call install-pkg,${*})
	@ touch $@

define debconf-set-selection
	echo '$1' | debconf-set-selections
endef
