include $(THEOS)/makefiles/common.mk

ARCHS = arm64

BUNDLE_NAME = CustomControlCentrePref
CustomControlCentrePref_FILES = CCCRootListController.m
CustomControlCentrePref_INSTALL_PATH = /Library/PreferenceBundles
CustomControlCentrePref_FRAMEWORKS = UIKit
CustomControlCentrePref_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/CustomControlCentrePref.plist$(ECHO_END)
