
this-dir := $(dir $(lastword $(MAKEFILE_LIST)))
include $(this-dir)/inc.functions.mk

webserver.lamp:
	# install lamp-server meta-package (^)
	# -y because, for some reason, non-interactive is not enough; maybe because is a meta-package?
	apt -yq install lamp-server^
	touch webserver.lamp
