target = appletv
THEOS_DEVICE_IP = guest-room.local
DEBUG = 0
include $(THEOS)/makefiles/common.mk

FRAMEWORK_NAME = MAObjCRuntime

MAObjCRuntime_FILES = $(wildcard ../*.m)
MAObjCRuntime_PUBLIC_HEADERS = $(wildcard ../*.h)
MAObjCRuntime_INSTALL_PATH = /Library/Frameworks
MAObjCRuntime_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/framework.mk
