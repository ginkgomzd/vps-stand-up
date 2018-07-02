
export SHELL := sh

export DEBIAN_FRONTEND ?= noninteractive

.PHONY: vendor
vendor:
	$(MAKE) -f make/vendor.mk

.PHONY: prereqs
prereqs:
	$(MAKE) -f make/prereqs.mk

.PHONY: system
system: prereqs vendor
	$(MAKE) -f make/system.mk

.PHONY: web-utils
web-utils: prereqs
	$(MAKE) -f make/web-utils.mk
