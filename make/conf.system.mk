
# TODO:
# all:

conf.system.gsl-logo:
	../bin/replace_file gsl-motd-logo.txt
	../bin/replace_file update-motd.d/00-0logo
	[ -x /usr/games/fortune ] || apt install fortune-mod fortunes-min fortunes fortunes-bofh-excuses
	touch conf.system.gsl-logo
