ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:15.0
INSTALL_TARGET_PROCESSES = ESign

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = SsignTheme
SsignTheme_FILES = Tweak.xm
SsignTheme_CFLAGS = -fobjc-arc
SsignTheme_FRAMEWORKS = UIKit Foundation

include $(THEOS_MAKE_PATH)/tweak.mk
