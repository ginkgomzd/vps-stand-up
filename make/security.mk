
this-dir := $(dir $(lastword $(MAKEFILE_LIST)))
include $(this-dir)/inc.functions.mk

all: security.fail2ban security.bad-bot-blocker security.rkhunter

security.fail2ban:
	$(call install-package, fail2ban)
	@ touch security.fail2ban

# TODO: install bad-bot-blocker into sys-utils?? pros? cons?
security.bad-bot-blocker:
	git clone git@github.com:ginkgostreet/bad-bot-blocker.git sys-utils/bad-bot-blocker

security.rkhunter:
	$(MAKE) -f $(this-dir)/rkhunter.mk
	@ touch security.rkhunter
