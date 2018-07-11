
this-dir := $(dir $(lastword $(MAKEFILE_LIST)))
include $(this-dir)/inc.functions.mk

all: security.fail2ban sys-utils/bad-bot-blocker security.rkhunter

security.fail2ban:
	$(call install-package, fail2ban)
	@ touch $(@)

# TODO: install bad-bot-blocker into sys-utils?? pros? cons?
sys-utils/bad-bot-blocker:
	- rm -rf $(@)
	git clone git@github.com:ginkgostreet/bad-bot-blocker.git $(@)

security.rkhunter:
	$(MAKE) -f $(this-dir)/rkhunter.mk
	@ touch $(@)
