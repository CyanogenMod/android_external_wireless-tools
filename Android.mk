#
# Copyright (C) 2009 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

ifneq ($(TARGET_SIMULATOR),true)

ifeq ($(BOARD_WPA_SUPPLICANT_DRIVER),WEXT)
  PRODUCT_WIRELESS_TOOLS ?= true
endif


ifeq ($(PRODUCT_WIRELESS_TOOLS), true)

LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)

IW_TOOLS := \
		iwconfig \
		iwlist \
		iwpriv \
		iwspy \
		iwgetid

LOCAL_SRC_FILES := \
		iwmulticall.c \
		iwlib.c \
		iwconfig.c \
		iwlist.c \
		iwspy.c \
		iwpriv.c \
		iwgetid.c

LOCAL_C_INCLUDES := bionic/libc/private
LOCAL_SHARED_LIBRARIES := libm
LOCAL_LDFLAGS=-Wl,-zmuldefs
LOCAL_MODULE := iwmulticall
LOCAL_MODULE_PATH := $(TARGET_OUT_OPTIONAL_EXECUTABLES)

LOCAL_MODULE_TAGS := eng optional

include $(BUILD_EXECUTABLE)

SYMLINKS := $(addprefix $(TARGET_OUT_OPTIONAL_EXECUTABLES)/,$(IW_TOOLS))
$(SYMLINKS): IW_BINARY := $(LOCAL_MODULE)
$(SYMLINKS): $(LOCAL_INSTALLED_MODULE)
	@echo "Symlink: $@ -> $(IW_BINARY)"
	@mkdir -p $(dir $@)
	@rm -rf $@
	$(hide) ln -sf $(IW_BINARY) $@

ALL_DEFAULT_INSTALLED_MODULES += $(SYMLINKS)

# We need this so that the installed files could be picked up based on the
# local module name
ALL_MODULES.$(LOCAL_MODULE).INSTALLED := \
    $(ALL_MODULES.$(LOCAL_MODULE).INSTALLED) $(SYMLINKS)

endif # PRODUCT_WIRELESS_TOOLS
endif # TARGET_SIMULATOR
