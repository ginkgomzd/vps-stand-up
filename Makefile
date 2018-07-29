
export SHELL := sh

export DEBIAN_FRONTEND ?= noninteractive

help:
	@echo "\n"\
	"\t"VPS Stand-up Script "\n\n"\
	Configure a LAMP server to Ginkgo St. Labs Hosting Specs"\n"\
	"\n"\
	 'make gsl-lamp' "\t"runs complete setup"\n"

.PHONY: prereqs
prereqs:
	$(MAKE) -f make/prereqs.mk

.PHONY: system
system: prereqs sys-utils
	$(MAKE) -f make/system.mk

.PHONY: security
security: system
	$(MAKE) -f make/security.mk

.PHONY: sys-utils
sys-utils: prereqs
	$(MAKE) -f make/sys-utils.mk

.PHONY: server
server: prereqs sys-utils
	$(MAKE) -f make/server.mk

.PHONY: web-utils
web-utils: prereqs
	$(MAKE) -f make/web-utils.mk

.PHONY: gsl-lamp
gsl-lamp: system sys-utils server security
	$(MAKE) -f make/conf.system.mk
	@ touch conf.system
	$(MAKE) -f make/conf.security.mk
	@ touch conf.security
	$(MAKE) -f make/conf.server.mk
	@ touch conf.server
