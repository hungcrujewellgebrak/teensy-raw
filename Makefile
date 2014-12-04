
# The name of your project (used to name the compiled .hex file)
TARGET = main

# configurable options
OPTIONS = -DF_CPU=72000000 -DUSB_SERIAL -DLAYOUT_US_ENGLISH

# options needed by many Arduino libraries to configure for Teensy 3.1
OPTIONS += -D__MK20DX256__ -DARDUINO=106 -DTEENSYDUINO=120

# Other Makefiles and project templates for Teensy 3.x:
#
# https://github.com/apmorton/teensy-template
# https://github.com/xxxajk/Arduino_Makefile_master
# https://github.com/JonHylands/uCee


#************************************************************************
# Location of Teensyduino utilities, Toolchain, and Arduino Libraries.
# To use this makefile without Arduino, copy the resources from these
# locations and edit the pathnames.  The rest of Arduino is not needed.
#************************************************************************

# path location for Teensy Loader, teensy_post_compile and teensy_reboot
TOOLSPATH_BASE = $(CURDIR)/tools

ifeq ($(OS),Windows_NT)
	TOOLSPATH = $(TOOLSPATH_BASE)/windows
else
	UNAME_S := $(shell uname -s)
	UNAME_M := $(shell uname -m)
    ifeq ($(UNAME_S),Linux)
		ifeq ($(UNAME_M),x86_64)
			TOOLSPATH = $(TOOLSPATH_BASE)/linux64
		else
			$(error Unsupported architecture)
		endif
	else
		ifeq ($(UNAME_S),Darwin)
			TOOLSPATH = $(TOOLSPATH_BASE)/mac
		else
			$(error Unsupported OS)
		endif
    endif
endif

COREPATH = teensy3

# path location for Arduino libraries
LIBRARYPATH = libraries

# path location for the arm-none-eabi compiler
COMPILERPATH = $(TOOLSPATH)/arm-none-eabi/bin

#************************************************************************
# Settings below this point usually do not need to be edited
#************************************************************************

# CPPFLAGS = compiler options for C and C++
CPPFLAGS = -Wall -c -g -Os -mcpu=cortex-m4 -mthumb -nostdlib -MMD $(OPTIONS) -Isrc -I$(COREPATH) -ffunction-sections -fdata-sections

# compiler options for C++ only
CXXFLAGS = -std=gnu++0x -felide-constructors -fno-exceptions -fno-rtti

# compiler options for C only
CFLAGS = -std=gnu99 

# linker options
LDSCRIPT = $(COREPATH)/mk20dx256.ld
LDFLAGS = -Os -Wl,--gc-sections -mcpu=cortex-m4 -mthumb -larm_cortexM4l_math -T$(LDSCRIPT)

# additional libraries to link
LIBS = -lm


# names for the compiler programs
AR = $(abspath $(COMPILERPATH))/arm-none-eabi-ar
CC = $(abspath $(COMPILERPATH))/arm-none-eabi-gcc
CXX = $(abspath $(COMPILERPATH))/arm-none-eabi-g++
OBJCOPY = $(abspath $(COMPILERPATH))/arm-none-eabi-objcopy
SIZE = $(abspath $(COMPILERPATH))/arm-none-eabi-size

# automatically create lists of the sources and objects
C_FILES := $(wildcard src/*.c)
CPP_FILES := $(wildcard src/*.cpp)
OBJS := $(C_FILES:.c=.o) $(CPP_FILES:.cpp=.o)

CORE_C_FILES := $(wildcard $(COREPATH)/*.c)
CORE_CPP_FILES := $(wildcard $(COREPATH)/*.cpp)
CORE_OBJS := $(CORE_C_FILES:.c=.o) $(CORE_CPP_FILES:.cpp=.o) 

LIB_C_FILES := $(wildcard $(LIBRARYPATH)/*.c)
LIB_CPP_FILES := $(wildcard $(LIBRARYPATH)/*.cpp)
LIB_OBJS := $(LIB_C_FILES:.c=.o) $(LIB_CPP_FILES:.cpp=.o) 

# the actual makefile rules (all .o files built by GNU make's default implicit rules)

all: $(TARGET).hex

upload: $(TARGET).hex
	$(abspath $(TOOLSPATH))/teensy_post_compile -file=$(basename $<) -path=$(CURDIR) -tools=$(abspath $(TOOLSPATH))
	-$(abspath $(TOOLSPATH))/teensy_reboot

core.a: $(CORE_OBJS)
	$(AR) rcs $@ $(CORE_OBJS)

libraries.a: $(LIB_OBJS)
	$(AR) rcs $@ $(LIB_OBJS)

$(TARGET).elf: $(OBJS) $(LDSCRIPT) core.a libraries.a
	$(CC) $(LDFLAGS) -o $@ $(OBJS) $(LIBS) core.a libraries.a

%.hex: %.elf
	$(SIZE) $<
	$(OBJCOPY) -O ihex -R .eeprom $< $@

# compiler generated dependency info
-include $(OBJS:.o=.d) $(LIB_OBJS:.o=.d) $(CORE_OBJS:.o=.d)

clean:
ifeq ($(OS),Windows_NT)
	del /q src\*.o >nul 2>&1
	del /q src\*.d >nul 2>&1
	del /q teensy3\*.o >nul 2>&1
	del /q teensy3\*.d >nul 2>&1
	del /q libraries\*.o >nul 2>&1
	del /q libraries\*.d >nul 2>&1
	del core.a >nul 2>&1
	del libraries.a >nul 2>&1
	del $(TARGET).elf >nul 2>&1
	del $(TARGET).hex >nul 2>&1
else
	rm -f src/*.d src/*.o
	rm -f teensy3/*.o teensy3/*.d
	rm -f libraries/*.o libraries/*.d
	rm -f core.a libraries.a
	rm -f $(TARGET).elf $(TARGET).hex
endif

