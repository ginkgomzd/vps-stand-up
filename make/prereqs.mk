include make/inc.functions.mk

all: wget

.PHONY: wget
wget:
	@ $(call install-package, wget)
