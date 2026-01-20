# Variablen von Xcode oder Fallbacks
CONFIGURATION ?= Debug
SRCROOT ?= $(CURDIR)
TARGET_BUILD_DIR ?= $(SRCROOT)/build/$(CONFIGURATION)

# Pfade
BINDIR = $(TARGET_BUILD_DIR)/bin
PSPDIR = $(BINDIR)
APP_BUNDLE_PATH = $(TARGET_BUILD_DIR)/$(CONTENTS_FOLDER_PATH)

OLD_C_STD = -std=gnu89
CFLAGS_FOR_PLT = $(OTHER_CFLAGS) $(OLD_C_STD) -g -Wno-implicit-function-declaration

BINS = ftable gencos genex10 genex14 henon imageplt lwplt makeplthead xplt xpltwin

# --- Architektur-Check für Homebrew-Pfade ---
ARCH := $(shell uname -m)

ifeq ($(ARCH),arm64)
    BREW_PREFIX ?= /opt/homebrew
else
    BREW_PREFIX ?= /usr/local
endif

MAGICK_PATH := $(BREW_PREFIX)/bin/magick
PS2PDF_PATH := $(BREW_PREFIX)/bin/ps2pdf

CONVERT := $(shell if [ -x $(MAGICK_PATH) ]; then echo $(MAGICK_PATH); else which magick 2>/dev/null; fi)
PSTOPDF := $(shell if [ -x $(PS2PDF_PATH) ]; then echo $(PS2PDF_PATH); else which ps2pdf 2>/dev/null; fi)

.PHONY: all plt_build install_and_fix clean

all: plt_build install_and_fix

plt_build:
	@echo "--- Kompiliere plt mit Standard $(OLD_C_STD) ---"
	@if [ ! -d "$(SRCROOT)/plt-2.5a" ]; then \
		echo "ERROR: Verzeichnis plt-2.5a nicht gefunden!"; \
		exit 1; \
	fi
	$(MAKE) -C $(SRCROOT)/plt-2.5a \
		CC="$(CC)" \
		CFLAGS="$(CFLAGS_FOR_PLT)" \
		XINCDIR="/opt/X11/include"

install_and_fix:
	@echo "--- Installation in $(TARGET_BUILD_DIR) ---"
	mkdir -p "$(BINDIR)"
	$(MAKE) -C $(SRCROOT)/plt-2.5a install \
		BINDIR="$(BINDIR)" \
		PSPDIR="$(PSPDIR)" \
		PREFIX="$(APP_BUNDLE_PATH)" \
		GV="/usr/bin/gv" \
		LPR="/usr/bin/lpr" \
		CONVERT="$(CONVERT)" \
		PSTOPDF="$(PSTOPDF)" \
		EPSTOPDF="/usr/bin/epstopdf"
		
	@if [ -f "$(BINDIR)/lwcat" ]; then \
		echo "Fixing lwcat..."; \
		sed -i '' "s%-[^}]*/plt.pro%-$(BINDIR)/plt.pro%g" "$(BINDIR)/lwcat"; \
	fi

	@for bin in $(BINS); do \
		if [ -f "$(SRCROOT)/plt-2.5a/$$bin" ]; then \
			cp -f "$(SRCROOT)/plt-2.5a/$$bin" "$(BINDIR)/"; \
			if file "$(BINDIR)/$$bin" | grep -q "Mach-O"; then \
				echo "Codesigning $$bin..."; \
				codesign --force --options runtime --entitlements $(SRCROOT)/debug.entitlements --sign - "$(BINDIR)/$$bin"; \
			fi \
		fi \
	done

clean:
	@if [ -d "$(SRCROOT)/plt-2.5a" ]; then $(MAKE) -C $(SRCROOT)/plt-2.5a clean; fi
	rm -rf "$(TARGET_BUILD_DIR)"
