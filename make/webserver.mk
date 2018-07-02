
this-dir := $(dir $(lastword $(MAKEFILE_LIST)))
include $(this-dir)/inc.functions.mk

webserver.lamp:
	# install lamp-server meta-package (^)
	sudo apt install lamp-server^
	touch webserver.lamp
