
this-dir := $(dir $(lastword $(MAKEFILE_LIST)))

conf.server.mysql:
	$(this-dir)/../bin/050-mysql
	$(this-dir)/../bin/055-open-files-limit

conf.server.postfix:
	$(this-dir)/../bin/070-postfix
