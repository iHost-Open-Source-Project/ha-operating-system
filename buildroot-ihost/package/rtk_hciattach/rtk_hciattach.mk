RTK_HCIATTACH_VERSION = 1.0.0
RTK_HCIATTACH_SITE = $(BR2_EXTERNAL_IHOST_PATH)/codes/rtk_hciattach
RTK_HCIATTACH_SITE_METHOD = local

define RTK_HCIATTACH_BUILD_CMDS
    $(MAKE) -C $(@D) CROSS_COMPILE=$(TARGET_CROSS) CC=$(TARGET_CC) 
endef

define RTK_HCIATTACH_INSTALL_TARGET_CMDS
    $(INSTALL) -m 0755 -t $(TARGET_DIR)/usr/bin -D $(@D)/rtk_hciattach
endef

$(eval $(generic-package))