

# # #
# TODO: 
# This is not a makefile
#
# Following tutorial from:
# https://www.howtogeek.com/devops/how-to-setup-basic-http-authentication-on-apache/
#

# was already installed but maybe call anyway to be idempotent
# apt-get install apache2-utils

# TODO: how to make non-interactive:
# maybe create a file with the password already hashed??
htpasswd -c /etc/apache2/.htpasswd reviewer

# TODO: maybe easier to use a different authentication database?
# >Alternatively, you can change Apache’s AuthBasicProvider option to allow for different methods of checking passwords



# If you want to enable authentication for everything, you’ll want to edit the main config file:

> /etc/apache2/apache2.conf

# If you instead want to authenticate a specific folder, you’ll want to edit that folder’s config file in sites-enabled. For example, the default config is at:

> /etc/apache2/sites-available/000-default.conf

# though yours will likely be named based on the route. If you need to make a new one, you can copy this default config and change the DocumentRoot.

<Directory "/var/www/html">
  AuthType Basic
  AuthName "Restricted Content"
  AuthUserFile /etc/apache2/.htpasswd
  Require valid-user
</Directory>


# Restart Apache:
service apache2 restart