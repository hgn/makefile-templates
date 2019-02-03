APP_NAME = app-bar

.DEFAULT_GOAL := release

# we need some global macros, and functions
# we don't want to repeat ourself all the time
include ../compiler-defines/setup.mak

# if the target is "debug" we include the
# default release CFLAGS, LDFLAGS, ...
ifeq ($(MAKECMDGOALS),debug)
	# enable sanitizer support just for debug
	# For release the overhead may be to high:
	# typical slowdown introduced by Memory
	# Sanitizer is 3x
	include ../compiler-defines/sanitizer.mak

	# and this again
	include ../compiler-defines/app-common.mak
	CFLAGS += -DBUILD_DEBUG
	# this is fine for debug, debug symbols
	# are already added (-g), we will strip
	# them out later, at install and bootup
	CFLAGS += -O1
else
	# NOTE: we do not check for release, we simple
	# treat every other (unknown) option as release
	# if the target is "release" we include the
	# default release CFLAGS, LDFLAGS, ...
	# we start with the same flags as debug
	include ../compiler-defines/app-common.mak
	# filter out some defaults we don't need for
	# release. This is an no-op example
	CFLAGS :=$(filter-out -O9,$(CFLAGS))
	CFLAGS += -DBUILD_RELEASE
	# this is fine for release, we can optimize
	# more aggresievely if required (so we have some
	# options, if we are running out of CPU cycles)
	CFLAGS += -O2
endif

# where to search for header files (own and libs)
DIR_HEADERS = -I../lib-foo

# when to link, where to find the libs and their name
# without .s and leading 'lib'
DIR_LIBS = -L../lib-foo/build
LIBS = -lfoo


# additional application specific flags for release
# build. E.g. we stick with c99 and pedantic
release: CFLAGS += -DNDEBUG
release: CFLAGS += -std=c99
release: compile-now

# application specific flags for debug builds
debug: CFLAGS += -DDEBUG
debug: CFLAGS += -g
debug: compile-now

ROOTDIR = $(realpath .)

# we build our *.o in a seperate directory
BUILD_DIR = $(ROOTDIR)/build

# all source files are located in the this
# directory, source them
APP_SRC = $(wildcard *.c)

# Delete all files that are normally created
# by running "make release" or "make debug"
clean:
	@rm -rf $(BUILD_DIR)
	@rm -rf $(APP_FULL_PATH)


# Please, do not change below this paragraph,
# unless you check that everything works:
# - modify (touch) a file and call make: is only
#   the touched file and the library re-builded?
# - make -j 16: is the dependency graph clean?
# - changing a header file should rebuild everything
# - if nothing is modified, nothing is re-builded
# - call "make release" and "make debug", the compile
#   switches should differ (CFLAGS)
# - this makefile does not realize debug/release state
#   changes. If you switch, you MUST call make clean
#   before.


# same but with full path
APP_SRC_FULL_PATH = $(patsubst %,$(ROOTDIR)/%,$(APP_SRC))
# object file list, with replaced BUILD_DIR 
APP_OBJ_FULL_PATH = $(patsubst $(ROOTDIR)/%,$(BUILD_DIR)/%,$(APP_SRC_FULL_PATH:%.c=%.o))

APP_FULL_PATH = $(BUILD_DIR)/$(APP_NAME)

compile-now: make-build-dir $(APP_FULL_PATH)

$(BUILD_DIR)/%.o: $(ROOTDIR)/%.c
	@echo $$CC
	$(CC) $(CPPFLAGS) $(CFLAGS) -c $< -o $@

.PHONY: make-build-dir objects compile-now release debug

$(APP_FULL_PATH): $(APP_OBJ_FULL_PATH)
	$(CC) $(DIR_HEADERS) $(DIR_LIBS) $(LIBS) $(LDFLAGS) -pipe -o $(APP_FULL_PATH) $(APP_OBJ_FULL_PATH)

make-build-dir:
	@mkdir -p $(BUILD_DIR)


