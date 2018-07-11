
this-dir := $(dir $(lastword $(MAKEFILE_LIST)))

conf.server.mysql:
	$(MAKE) -f $(this-dir)conf.server.mysql.mk
	$(this-dir)../bin/055-open-files-limit
	service mysql restart
	@ touch $(@)

conf.server.postfix:
	$(this-dir)../bin/070-postfix
