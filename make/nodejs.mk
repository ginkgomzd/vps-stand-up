
default: install

node-source-setup.sh:
	curl -sL https://deb.nodesource.com/setup_11.x > $@
	chmod ug+x $@

sources.list: node-source-setup.sh
	bash ./$<

install: sources.list
	apt-get update && apt-get install nodejs
