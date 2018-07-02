include make/inc.functions.mk

all: wget git

.PHONY: wget
wget:
	@ $(call install-package, wget)

.PHONY: git
	@ $(call install-package, git)
