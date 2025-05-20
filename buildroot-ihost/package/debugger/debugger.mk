DEBUGGER_VERSION = 1.0.0
DEBUGGER_SITE = $(BR2_EXTERNAL_IHOST_PATH)/package/debugger
DEBUGGER_SITE_METHOD = local

define DEBUGGER_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/home/root
	$(INSTALL) -m 0644 $(@D)/debugger.js $(TARGET_DIR)/home/root
endef

define DEBUGGER_INSTALL_INIT_SYSTEMD
	$(INSTALL) -m 0644 $(@D)/debugger.service $(TARGET_DIR)/usr/lib/systemd/system
endef


$(eval $(generic-package))
