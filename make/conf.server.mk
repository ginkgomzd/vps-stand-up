
this-dir := $(dir $(lastword $(MAKEFILE_LIST)))

REPLACE_CMD := $(this-dir)../bin/replace_file
PATCH_FILE_CMD := $(this-dir)../bin/patch_file

conf.server.mysql: conf.server.mysql.file-limits
	$(MAKE) -f $(this-dir)conf.server.mysql.mk
	@ touch $(@)

conf.server.postfix:
	$(this-dir)../bin/070-postfix
