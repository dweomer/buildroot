################################################################################
#
# libsigrok
#
################################################################################

LIBSIGROK_VERSION = 0.5.2
LIBSIGROK_SITE = http://sigrok.org/download/source/libsigrok
LIBSIGROK_LICENSE = GPL-3.0+
LIBSIGROK_LICENSE_FILES = COPYING
LIBSIGROK_INSTALL_STAGING = YES
LIBSIGROK_DEPENDENCIES = libglib2 libzip host-pkgconf
LIBSIGROK_CONF_OPTS = --disable-java --disable-python
# We're patching configure.ac
LIBSIGROK_AUTORECONF = YES

ifeq ($(BR2_PACKAGE_BLUEZ5_UTILS),y)
LIBSIGROK_CONF_OPTS += --with-libbluez
LIBSIGROK_DEPENDENCIES += bluez5_utils
else
LIBSIGROK_CONF_OPTS += --without-libbluez
endif

ifeq ($(BR2_PACKAGE_HIDAPI),y)
LIBSIGROK_CONF_OPTS += --with-libhidapi
LIBSIGROK_DEPENDENCIES += hidapi
else
LIBSIGROK_CONF_OPTS += --without-libhidapi
endif

ifeq ($(BR2_PACKAGE_LIBSERIALPORT),y)
LIBSIGROK_CONF_OPTS += --with-libserialport
LIBSIGROK_DEPENDENCIES += libserialport
else
LIBSIGROK_CONF_OPTS += --without-libserialport
endif

ifeq ($(BR2_PACKAGE_LIBFTDI1),y)
LIBSIGROK_CONF_OPTS += --with-libftdi
LIBSIGROK_DEPENDENCIES += libftdi1
else
LIBSIGROK_CONF_OPTS += --without-libftdi
endif

ifeq ($(BR2_PACKAGE_LIBUSB),y)
LIBSIGROK_CONF_OPTS += --with-libusb
LIBSIGROK_DEPENDENCIES += libusb
else
LIBSIGROK_CONF_OPTS += --without-libusb
endif

ifeq ($(BR2_PACKAGE_GLIBMM),y)
LIBSIGROK_DEPENDENCIES += glibmm
endif

ifeq ($(BR2_PACKAGE_LIBSIGROKCXX),y)
LIBSIGROK_CONF_ENV = CXXFLAGS="$(TARGET_CXXFLAGS) -std=c++17"
LIBSIGROK_CONF_OPTS += --enable-cxx
# host-doxygen is used by C++ bindings to parse libsigrok symbols
LIBSIGROK_DEPENDENCIES += \
	glibmm \
	host-doxygen \
	host-python3
else
LIBSIGROK_CONF_OPTS += --disable-cxx
endif

ifeq ($(BR2_PACKAGE_HAS_UDEV),y)
LIBSIGROK_UDEV_RULES = \
	60-libsigrok.rules \
	$(if $(BR2_PACKAGE_SYSTEMD_LOGIND), \
		61-libsigrok-uaccess.rules, \
		61-libsigrok-plugdev.rules \
	)
define LIBSIGROK_INSTALL_UDEV_RULES
	$(foreach rule, $(LIBSIGROK_UDEV_RULES), \
		$(INSTALL) -D -m 0644 $(@D)/contrib/$(rule) \
			$(TARGET_DIR)/usr/lib/udev/rules.d/$(rule)$(sep) \
	)
endef
LIBSIGROK_POST_INSTALL_TARGET_HOOKS += LIBSIGROK_INSTALL_UDEV_RULES
endif

$(eval $(autotools-package))
