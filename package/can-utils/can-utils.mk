################################################################################
#
# can-utils
#
################################################################################

CAN_UTILS_VERSION = 2025.01
CAN_UTILS_SITE = $(call github,linux-can,can-utils,v$(CAN_UTILS_VERSION))
CAN_UTILS_LICENSE = BSD-3-Clause or GPL-2.0
CAN_UTILS_LICENSE_FILES = LICENSES/BSD-3-Clause LICENSES/GPL-2.0-only.txt

$(eval $(cmake-package))
