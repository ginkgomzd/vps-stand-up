
## install packages
apt install letsencrypt
# only one is needed: depending on your web server
apt install python3-certbot-nginx
apt install python3-certbot-apache

# get name of processes listening on :80 or :443
netstat -naptu |grep ':80\|443' |awk '{print $NF}'|cut -d"/" -f2|uniq

## verify install
systemctl status certbot.timer

## OPTION: NGINX or Apache
certbot --apache --agree-tos --preferred-challenges http -d ${STANDUP_FQDN}


# # #
# Standalone:
# Doubt this is the best option
#

## STOP Web Server for standalone verificaiton to work
service apache2 stop

# do not install cert
# standalone authentication
certbot certonly --standalone --agree-tos --preferred-challenges http -d ${STANDUP_FQDN}

#
# Legacy Example:
#
# interactive; Not included in target, all
conf.server.ssl:
	nslookup $(STANDUP_FQDN).
	certbot --apache --allow-subset-of-names -d $(STANDUP_FQDN) --webroot-path /var/www/html
	@ touch $(@)

#
# Not Needed on > 20.04
# 
repo.certbot:
	# Add the repo for CertBot/Let's Encrypt
	sudo add-apt-repository -y ppa:certbot/certbot
	touch repo.certbot
