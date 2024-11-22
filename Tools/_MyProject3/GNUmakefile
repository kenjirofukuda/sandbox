# @see https://www.gnustep.org/nicola/Tutorials/Renaissance/node4.html

include $(GNUSTEP_MAKEFILES)/common.make

APP_NAME = WindowApp
WindowApp_OBJC_FILES = MyApp.m
WindowApp_RESOURCE_FILES = \
  Menu-GNUstep.gsmarkup \
  Menu-OSX.gsmarkup \
  Window.gsmarkup
WindowApp_LOCALIZED_RESOURCE_FILES = \
  Window.strings
WindowApp_LANGUAGES = Italian

ifeq ($(FOUNDATION_LIB), apple)
  ADDITIONAL_INCLUDE_DIRS += -framework Renaissance
  ADDITIONAL_GUI_LIBS += -framework Renaissance
else
  ADDITIONAL_GUI_LIBS += -lRenaissance
endif

include $(GNUSTEP_MAKEFILES)/application.make

# openapp ./WindowApp.app -NSLanguages '(Italian)'
