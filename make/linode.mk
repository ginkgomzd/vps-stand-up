
# specify the linode instance to target
# default: microscope, infrastructure development instance
LIN_LABEL ?= microscope
LIN_IMAGE_ID ?= linode/ubuntu16.04lts
#LIN_IMAGE_ID ?= private/4200184
LIN_ROOT_PASS ?= q?IK]qzqFu_[R*v)T85V^!L9Wpj8CEZG

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

endef

linode-cli:
	which linode-cli

host:
	@$(linode_get_vps)

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
	$(linodes) rebuild --root_pass "$(LIN_ROOT_PASS)" --image $(LIN_IMAGE_ID) --authorized_keys "$(shell cat ~/.ssh/id_rsa.pub)" --booted false $(LIN_HOST_ID)
	$(sleep_until_offline)
	# Resizing Disk
	DISK_ID=`$(linodes) disks-list $(LIN_HOST_ID) --text --no-headers | grep -v swap | cut -f1` && \
	$(linodes) disk-resize --size 40000 $(LIN_HOST_ID) $$DISK_ID
	# booting
	$(linodes) boot $(LIN_HOST_ID)

resize-disk: LIN_HOST_ID = $(shell $(linode_get_host_id))
resize-disk:
	$(linodes) shutdown $(LIN_HOST_ID)
	$(sleep_until_offline)
	DISK_ID=`$(linodes) disks-list $(LIN_HOST_ID) --text --no-headers | grep -v swap | cut -f1` && \
	$(linodes) disk-resize --size 40000 $(LIN_HOST_ID) $$DISK_ID
	# booting
	$(linodes) boot $(LIN_HOST_ID)
