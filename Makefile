ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:15.0

include $(THEOS)/makefiles/common.mk

LIBRARY_NAME = SsignTheme
SsignTheme_FILES = SsignTheme.m
SsignTheme_CFLAGS = -fobjc-arc
SsignTheme_FRAMEWORKS = UIKit Foundation

include $(THEOS_MAKE_PATH)/library.mk
