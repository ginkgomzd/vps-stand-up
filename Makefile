
export SHELL := sh

export DEBIAN_FRONTEND ?= noninteractive

.PHONY: vendor
vendor:
	$(MAKE) -f make/vendor.mk

.PHONY: prereqs
prereqs:
	$(MAKE) -f make/prereqs.mk

.PHONY: system
system:
	$(MAKE) -f make/system.mk
