################################################################################
#
# libevent-openipc
#
################################################################################

LIBEVENT_OPENIPC_VERSION = e8313084f9e8b064433cb10eb9a79bf87407fab6
LIBEVENT_OPENIPC_SITE = $(call github,libevent,libevent,$(LIBEVENT_OPENIPC_VERSION))
LIBEVENT_OPENIPC_INSTALL_STAGING = YES
LIBEVENT_OPENIPC_LICENSE = BSD-3-Clause, OpenBSD
LIBEVENT_OPENIPC_LICENSE_FILES = LICENSE
LIBEVENT_OPENIPC_CONF_OPTS = \
	-DEVENT__DISABLE_BENCHMARK=ON \
	-DEVENT__DISABLE_SAMPLES=ON \
	-DEVENT__DISABLE_TESTS=ON \
	-DCMAKE_BUILD_TYPE=Release


define LIBEVENT_OPENIPC_REMOVE_PYSCRIPT
	rm $(TARGET_DIR)/usr/bin/event_rpcgen.py
endef

define LIBEVENT_OPENIPC_DELETE_UNUSED
	rm -r $(TARGET_DIR)/usr/lib/libevent-2.2.so
	rm -f $(TARGET_DIR)/usr/lib/libevent-2.2.so.1.0.0
	rm -f $(TARGET_DIR)/usr/lib/libevent-2.2.so.1
	rm -f $(TARGET_DIR)/usr/lib/libevent.so
endef

# libevent installs a python script to target - get rid of it if we
# don't have python support enabled
ifneq ($(BR2_PACKAGE_PYTHON)$(BR2_PACKAGE_PYTHON3),y)
LIBEVENT_OPENIPC_POST_INSTALL_TARGET_HOOKS += LIBEVENT_OPENIPC_REMOVE_PYSCRIPT
endif

ifeq ($(BR2_PACKAGE_OPENSSL),y)
LIBEVENT_OPENIPC_DEPENDENCIES += host-pkgconf openssl
LIBEVENT_OPENIPC_CONF_OPTS += -DEVENT__DISABLE_OPENSSL=OFF
else
LIBEVENT_OPENIPC_CONF_OPTS += -DEVENT__DISABLE_OPENSSL=ON
endif

ifeq ($(BR2_PACKAGE_MBEDTLS_OPENIPC),y)
LIBEVENT_OPENIPC_DEPENDENCIES += host-pkgconf mbedtls-openipc
LIBEVENT_OPENIPC_CONF_OPTS += -DEVENT__DISABLE_MBEDTLS=OFF
else
LIBEVENT_OPENIPC_CONF_OPTS += -DEVENT__DISABLE_MBEDTLS=ON
endif

LIBEVENT_OPENIPC_POST_INSTALL_TARGET_HOOKS += LIBEVENT_OPENIPC_DELETE_UNUSED

$(eval $(cmake-package))
