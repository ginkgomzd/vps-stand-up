
export SHELL := sh

export DEBIAN_FRONTEND ?= noninteractive

help:
	@echo "\n"\
	"\t"VPS Stand-up Script "\n\n"\
	LAMP Server Configuration"\n"\
	"\n"\
	 'make stand-up' "\t"runs complete setup"\n"

prereqs:
	$(MAKE) -f make/prereqs.mk

system: prereqs sys-utils
	$(MAKE) -f make/system.mk

security: system
	$(MAKE) -f make/security.mk

sys-utils: prereqs
	$(MAKE) -f make/sys-utils.mk

server: prereqs sys-utils
	$(MAKE) -f make/server.mk

web-utils: prereqs
	$(MAKE) -f make/web-utils.mk

stand-up: system sys-utils server security
	$(MAKE) -f make/conf.system.mk
	@ touch conf.system
	$(MAKE) -f make/conf.security.mk
	@ touch conf.security
	$(MAKE) -f make/conf.server.mk
	@ touch conf.server
