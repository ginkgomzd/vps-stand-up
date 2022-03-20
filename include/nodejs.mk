
default: install

# setup for node 10.x LTS
node-source-setup.sh:
	curl -sL https://nsolid-deb.nodesource.com/nsolid_setup_4.x > $@
	chmod ug+x $@

sources.list: node-source-setup.sh
	bash ./$<

install: sources.list
	apt-get update && apt-get -y install nsolid-dubnium nsolid-console

uninstall:
	apt-get purge nodejs

clean:
	rm node-source-setup.sh
