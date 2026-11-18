.DEFAULT_GOAL := help
SUBMAKE := $(MAKE) --no-print-directory

# Flutter commands share SDK and project state; keep every invocation sequential.
.NOTPARALLEL:

ifeq ($(OS),Windows_NT)
SHELL := cmd.exe
FVM_FLUTTER_SDK := $(wildcard $(CURDIR)/.fvm/flutter_sdk)
LOCAL_FLUTTER := $(if $(FVM_FLUTTER_SDK),$(FVM_FLUTTER_SDK)/bin/flutter.bat,flutter.bat)
LOCAL_DART := $(if $(FVM_FLUTTER_SDK),$(FVM_FLUTTER_SDK)/bin/dart.bat,dart.bat)
BLANK_LINE := @echo.
else
SHELL := /bin/bash
FVM_FLUTTER_SDK := $(wildcard $(CURDIR)/.fvm/flutter_sdk)
LOCAL_FLUTTER := $(if $(FVM_FLUTTER_SDK),$(FVM_FLUTTER_SDK)/bin/flutter,flutter)
LOCAL_DART := $(if $(FVM_FLUTTER_SDK),$(FVM_FLUTTER_SDK)/bin/dart,dart)
BLANK_LINE := @echo
endif

# Command-line overrides also apply inside the example directory.
FLUTTER := $(LOCAL_FLUTTER)
DART := $(LOCAL_DART)
EXAMPLE_DIR := example
DART_DIRS := lib test $(EXAMPLE_DIR)/lib $(EXAMPLE_DIR)/test $(EXAMPLE_DIR)/tool

# Machine output supplements the readable reporter and preserves test exit codes.
# MACHINE_OUT is relative to the repository root; example_<filename> is written
# beside it for the example suite so reports never overwrite each other.
CI ?= 0
MACHINE_OUT ?=
TEST_REPORTER := $(if $(filter 1,$(CI)),--reporter github,)
TEST_ARGS := $(TEST_REPORTER) \
             $(if $(MACHINE_OUT),--file-reporter="json:$(abspath $(MACHINE_OUT))",)
EXAMPLE_TEST_ARGS := $(TEST_REPORTER) \
             $(if $(MACHINE_OUT),--file-reporter="json:$(dir $(abspath $(MACHINE_OUT)))example_$(notdir $(MACHINE_OUT))",)

.PHONY: help bootstrap format format-check fix analyze test test-package test-example gen check aio capture-demos publish-dry-run

help:
	@echo "simple_heatmap_calendar - automation entrypoints"
	$(BLANK_LINE)
	@echo "  bootstrap       Resolve package and example dependencies"
	@echo "  gen             Generate example localizations"
	@echo "  capture-demos   Record README animations (requires WebP tools and bash)"
	@echo "  publish-dry-run Validate the package for pub.dev"
	@echo "  format          Format package and example Dart sources"
	@echo "  format-check    Verify Dart formatting without modifying files"
	@echo "  fix             Apply Dart fixes in package and example, then format"
	@echo "  analyze         Analyze the package and example"
	@echo "  test            Run package and example tests (CI=1, MACHINE_OUT=path optional)"
	@echo "  check           Resolve dependencies, check formatting, analyze, and test"
	@echo "  aio             Resolve dependencies, apply fixes, format, analyze, and test"

bootstrap:
	@"$(FLUTTER)" pub get
	@cd "$(EXAMPLE_DIR)" && "$(FLUTTER)" pub get

gen:
	@cd "$(EXAMPLE_DIR)" && "$(FLUTTER)" gen-l10n
	@"$(DART)" format $(EXAMPLE_DIR)/lib/l10n

format:
	@"$(DART)" format $(DART_DIRS)

format-check:
	@"$(DART)" format --output=none --set-exit-if-changed $(DART_DIRS)

fix:
	@"$(DART)" fix --apply
	@cd "$(EXAMPLE_DIR)" && "$(DART)" fix --apply
	@$(SUBMAKE) format

analyze:
	@"$(FLUTTER)" analyze
	@cd "$(EXAMPLE_DIR)" && "$(FLUTTER)" analyze

test:
	@$(SUBMAKE) -k test-package test-example

test-package:
	@"$(FLUTTER)" test $(TEST_ARGS)

test-example:
	@cd "$(EXAMPLE_DIR)" && "$(FLUTTER)" test $(EXAMPLE_TEST_ARGS)

publish-dry-run:
	@"$(FLUTTER)" pub publish --dry-run

# Keep composed workflows sequential, including under make -j.
check:
	@$(SUBMAKE) bootstrap
	@$(SUBMAKE) gen
	@$(SUBMAKE) format-check
	@$(SUBMAKE) analyze
	@$(SUBMAKE) test

aio:
	@$(SUBMAKE) bootstrap
	@$(SUBMAKE) gen
	@$(SUBMAKE) fix
	@$(SUBMAKE) analyze
	@$(SUBMAKE) test

capture-demos:
	@cd "$(EXAMPLE_DIR)" && "$(FLUTTER)" test tool/capture_demos.dart
	@bash $(EXAMPLE_DIR)/tool/encode_demos.sh
