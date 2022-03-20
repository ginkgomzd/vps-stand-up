
#
# https://github.com/mitchellkrogza/apache-ultimate-bad-bot-blocker/tree/master/Apache_2.4
#

#
# Update/Install from distro:
# Will preserve custom if exists
#
update: conf.bad-bot-blocker
	cd ${APACHE_ULTIMATE_BBB} && git pull
	cp ${APACHE_ULTIMATE_BBB}/custom.d/globalblacklist.conf ${APACHE_CONF}/custom.d/globalblacklist.conf
	$(info ${INSTALL_HELP})

APACHE_CONF ?= /etc/apache2
APACHE_ULTIMATE_BBB ?= ./apache-ultimate-bad-bot-blocker/Apache_2.4

define au-bbb-cp-custom
	$(eval filename := $(shell basename $1))
	test -f ${APACHE_CONF}/custom.d/${filename} || cp ${APACHE_ULTIMATE_BBB}/custom.d/${filename} ${APACHE_CONF}/custom.d/${filename}

endef

APACHE_ULTIMATE_BBB_CUSTOM_FILES = $(shell find ${APACHE_ULTIMATE_BBB}/custom.d -type f)

${APACHE_CONF}/custom.d:
	mkdir -p $@

conf.bad-bot-blocker: apache-ultimate-bad-bot-blocker ${APACHE_CONF}/custom.d
	$(foreach f,${APACHE_ULTIMATE_BBB_CUSTOM_FILES},$(call au-bbb-cp-custom,$f))

apache-ultimate-bad-bot-blocker:
	- rm -rf $@
	git clone https://github.com/mitchellkrogza/apache-ultimate-bad-bot-blocker.git $@

#
# From the README:
#

define INSTALL_HELP
************************************************
<img src="https://github.com/mitchellkrogza/apache-ultimate-bad-bot-blocker/blob/master/.assets/step-6.png"/>

**INCLUDE THE GLOBALBLACKLIST.CONF**

Include the globalblacklist.conf file in the beginning of a directory block just after your opening Options statements and before the rest of your host config example below. **Remove the "<<<<<< This needs to be added" part**

```
<VirtualHost *:80>

	ServerName local.dev
    ServerAlias www.local.dev
	DocumentRoot /var/www/html
	ErrorLog $${APACHE_LOG_DIR}/error.log
	CustomLog $${APACHE_LOG_DIR}/access.log combined

		<Directory "/var/www/html">
    		AllowOverride All
    		Options FollowSymLinks
			Include custom.d/globalblacklist.conf
  		</Directory>

</VirtualHost>

# vim: syntax=apache ts=4 sw=4 sts=4 sr noet
```

You can include globalblacklist.conf globally (for all virtual hosts) if you put the following configuration after virtual host configuration.

```
# ######################################
# GLOBAL! deny bad bots and IP addresses
# ######################################
#
# should be set after <VirtualHost>s see https://httpd.apache.org/docs/2.4/sections.html#merging
<Location "/">
	# AND-combine with preceding configuration sections  
	AuthMerging And
	# include black list
	Include custom.d/globalblacklist.conf
</Location>
```

************************************************
<img src="https://github.com/mitchellkrogza/apache-ultimate-bad-bot-blocker/blob/master/.assets/step-7.png"/>

**TEST YOUR APACHE CONFIGURATION**

Do an Apache2 Config Test

`sudo apache2ctl configtest`

If you get no errors then you followed my instructions so now you can make the blocker go live with a simple.

`sudo service apache2 reload`

or

`sudo service httpd reload`

The blocker is now active and working so now you can run some simple tests from another linux machine to make sure it's working.

************************************************
<img src="https://github.com/mitchellkrogza/apache-ultimate-bad-bot-blocker/blob/master/.assets/step-8.png"/>

*TESTING**

Run the following commands one by one from a terminal on another linux machine against your own domain name. 
**substitute yourdomain.com in the examples below with your REAL domain name**

`curl -A "googlebot" http://yourdomain.com`

Should respond with 200 OK

`curl -A "80legs" http://yourdomain.com`

`curl -A "masscan" http://yourdomain.com`

Should respond with 403 Forbidden

`curl -I http://yourdomain.com -e http://100dollars-seo.com`

`curl -I http://yourdomain.com -e http://zx6.ru`

Should respond with 403 Forbidden

The Apache Ultimate Bot Blocker is now WORKING and PROTECTING your web sites !!!

************************************************
<img src="https://github.com/mitchellkrogza/apache-ultimate-bad-bot-blocker/blob/master/.assets/step-9.png"/>

**UPDATING THE APACHE BAD BOT BLOCKER** is now easy thanks to the automatic includes for whitelisting your own domain names.

Updating to the latest version is now as simple as:

`sudo wget https://raw.githubusercontent.com/mitchellkrogza/apache-ultimate-bad-bot-blocker/master/Apache_2.4/custom.d/globalblacklist.conf -O /etc/apache2/custom.d/globalblacklist.conf`

`sudo apache2ctl configtest`

`sudo service apache2 reload` 

And you will be up to date with all your whitelisted domains included automatically for you now. 

************************************************
# AUTO UPDATING WITH CRON:

See the latest auto updater bash script for Apache 2.2 and 2.4 contributed by Luke Taylor @lutaylor at:

https://github.com/mitchellkrogza/apache-ultimate-bad-bot-blocker/blob/master/update-apacheblocker.sh

Relax now and sleep better at night knowing your site is telling all those baddies FORBIDDEN !!!

************************************************
## HOW TO MONITOR YOUR APACHE LOGS DAILY (The Easy Way):

With great thanks and appreciation to https://blog.nexcess.net/2011/01/21/one-liners-for-apache-log-files/

To monitor your top referer's for a web site's log file's on a daily basis use the following simple
cron jobs which will email you a list of top referer's / user agents every morning from a particular web site's log
files. This is an example for just one cron job for one site. Set up multiple one's for each one you
want to monitor. Here is a cron that runs at 8am every morning and emails me the stripped down log of
referers. When I say stripped down, the domain of the site and other referers like Google and Bing are
stripped from the results. Of course you must change the log file name, domain name and your email address in
the examples below. The second cron for collecting User agents does not do any stripping out of any referers but you
can add that functionality if you like copying the awk statement !~ from the first example.

##### Cron for Monitoring Daily Referers on Apache

`00 08 * * * tail -10000 /var/log/apache/mydomain-access.log | awk '$11 !~ /google|bing|yahoo|yandex|mywebsite.com/' | awk '{print $11}' | tr -d '"' | sort | uniq -c | sort -rn | head -1000 | mail -s "Top 1000 Referers for Mydomain.com" me@mydomain.com`

##### Cron for Monitoring Daily User Agents on Apache

`00 08 * * * tail -50000 /var/log/apache/mydomain-access.log | awk '{print $12}' | tr -d '"' | sort | uniq -c | sort -rn | head -1000 | mail -s "Top 1000 Agents for Mydomain.com" me@mydomain.com`

endef