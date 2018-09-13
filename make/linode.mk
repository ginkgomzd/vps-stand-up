
# specify the linode instance to target
# default: microscope, infrastructure development instance
LIN_LABEL ?= microscope
LIN_IMAGE_ID ?= linode/ubuntu18.04
#LIN_IMAGE_ID ?= private/4200184
LIN_ROOT_PASS ?= q?IK]qzqFu_[R*v)T85V^!L9Wpj8CEZG
LIN_REGION ?= us-central
LIN_VPS_TYPE ?= g6-standard-2
LIN_SSH_AUTHORIZED_KEYS ?= $(shell cat ~/.ssh/id_rsa.pub)

DEBIAN_FRONTEND ?= noninteractive
this-dir := $(dir $(lastword $(MAKEFILE_LIST)))

define linodes
	linode-cli linodes
endef

define linode_raw_format
	--text --no-headers
endef

define linode_get_vps
	$(linodes) list $(linode_raw_format) --label $(LIN_LABEL)
endef
define linode_get_host_id
	$(linodes) list $(linode_raw_format) --label $(LIN_LABEL) --format id
endef
define linode_get_host_ipv4
  $(linodes) list $(linode_raw_format) --label $(LIN_LABEL) --format ipv4
endef
define linode_get_disk_id
	# ER... TODO
endef

host:
	# LIN_LABEL: ${LIN_LABEL}
	@$(linode_get_vps)

host-id:
	@$(linode_get_host_id)

linode-cli:
	which linode-cli

host-status: LIN_HOST_ID = $(shell $(linode_get_host_id))
host-status:
	@ $(linodes) view $(linode_raw_format) --format status $(LIN_HOST_ID)

disks: LIN_HOST_ID = $(shell $(linode_get_host_id))
disks:
	$(linodes) disks-list $(LIN_HOST_ID)

image:
	linode-cli images view $(LIN_IMAGE_ID)

define sleep_until_offline
	# Confirming offline:
	@while [ 'offline' != "$$THE_STATUS" ] ; \
	do THE_STATUS="$$($(linodes) view $(linode_raw_format) --format status $(LIN_HOST_ID))"; sleep 2; done
endef
define sleep_until_running
	# Confirming running:
	@while [ 'running' != "$$THE_STATUS" ] ; \
	do THE_STATUS="$$($(linodes) view $(linode_raw_format) --format status $(LIN_HOST_ID))"; sleep 2; done
endef

rebuild-beater: LIN_HOST_ID = $(shell $(linode_get_host_id))
rebuild-beater:
	$(linodes) shutdown $(LIN_HOST_ID)
	$(sleep_until_offline)
	$(linodes) rebuild --root_pass "$(LIN_ROOT_PASS)" --image $(LIN_IMAGE_ID) --authorized_keys "$(LIN_SSH_AUTHORIZED_KEYS)" --booted false $(LIN_HOST_ID)
	$(sleep_until_offline)
	# booting
	$(linodes) boot $(LIN_HOST_ID)
	# clear known_hosts
	ssh-keygen -f "$$HOME/.ssh/known_hosts" -R $(shell $(linode_get_host_ipv4))

create-vps:
	$(linodes) create --label $(LIN_LABEL) \
	--image $(LIN_IMAGE_ID) --type $(LIN_VPS_TYPE) --region $(LIN_REGION) \
	--root_pass "$(LIN_ROOT_PASS)" --authorized_keys "$(LIN_SSH_AUTHORIZED_KEYS)" \
	--backups_enabled true --booted false

apt-upgrade: LIN_HOST_ID = $(shell $(linode_get_host_id))
apt-upgrade: LIN_HOST_IP = $(shell $(linode_get_host_ipv4))
apt-upgrade:
	$(sleep_until_running)
	ssh root@$(LIN_HOST_IP) 'apt-get update; DEBIAN_FRONTEND=$(DEBIAN_FRONTEND) apt-get -y upgrade'

reboot: LIN_HOST_ID = $(shell $(linode_get_host_id))
reboot:
	$(linodes) reboot  $(LIN_HOST_ID)

resize-disk: LIN_HOST_ID = $(shell $(linode_get_host_id))
resize-disk:
	$(linodes) shutdown $(LIN_HOST_ID)
	$(sleep_until_offline)
	DISK_ID=`$(linodes) disks-list $(LIN_HOST_ID) --text --no-headers | grep -v swap | cut -f1` && \
	$(linodes) disk-resize --size 40000 $(LIN_HOST_ID) $$DISK_ID
	# booting
	$(linodes) boot $(LIN_HOST_ID)

deploy-stand-up: LIN_HOST_IP = $(shell $(linode_get_host_ipv4))
deploy-stand-up:
	rsync -rz . root@$(LIN_HOST_IP):~/stand-up
	ssh root@$(LIN_HOST_IP) 'DEBIAN_FRONTEND=$(DEBIAN_FRONTEND) apt-get install make'
