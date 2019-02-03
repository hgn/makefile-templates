LIB_NAME = libfoo

.DEFAULT_GOAL := release

# Enable debugging information (using -g),
# even for optimized production builds. Having
# only partly usable debugging information (due
# to optimization) certainly beats having none at
# all. With GCC, generating debugging information
# does not alter code generation. It is possible
# to use tools such as eu-strip to separate debugging
# information before distributing binaries
CFLAGS += -g -grecord-gcc-switches

# we need some global macros, and functions
# we don't want to repeat ourself all the time
include ../compiler-defines/setup.mak

# if the target is "debug" we include the
# default release CFLAGS, LDFLAGS, ...
ifeq ($(MAKECMDGOALS),debug)
	# enable sanitizer support for release and
	# debug builds
	include ../compiler-defines/sanitizer.mak

	include ../compiler-defines/lib-common.mak
	CFLAGS += -DBUILD_DEBUG
else
	# NOTE: we do not check for release, we simple
	# treat every other (unknown) option as release
  # if the target is "release" we include the
  # default release CFLAGS, LDFLAGS, ...
  # we start with the same flags as debug
	include ../compiler-defines/lib-common.mak
	# filter out some defaults we don't need for
	# release. This is an no-op example
	CFLAGS :=$(filter-out -O9,$(CFLAGS))
	CFLAGS += -DBUILD_RELEASE
endif


# additional flags for release builds
release: CFLAGS += -DNDEBUG
release: CFLAGS += -std=c99 # our library is strictly C99
release: compile-now

# flags for debug builds
debug: CFLAGS += -DDEBUG
debug: CFLAGS += -g
debug: compile-now

ROOTDIR = $(realpath .)

# we build our *.o in a seperate directory
BUILD_DIR = $(ROOTDIR)/build

# all source files are located in the this
# directory, source them
LIB_SRC = $(wildcard *.c)

# Delete all files that are normally created
# by running "make release" or "make debug"
clean:
	@rm -rf $(BUILD_DIR)
	@rm -rf $(LIB_FULL_PATH)


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


# Default target is release, better safe then sorry
all: release

# same but with full path
LIB_SRC_FULL_PATH = $(patsubst %,$(ROOTDIR)/%,$(LIB_SRC))
# object file list, with replaced BUILD_DIR 
LIB_OBJ_FULL_PATH = $(patsubst $(ROOTDIR)/%,$(BUILD_DIR)/%,$(LIB_SRC_FULL_PATH:%.c=%.o))

LIB_SO_NAME = $(LIB_NAME).so
LIB_NAME_FULL = $(LIB_NAME).so
LIB_FULL_PATH = $(BUILD_DIR)/$(LIB_NAME_FULL)
LIB_STATIC_NAME_FULL = $(LIB_NAME).a
LIB_STATIC_FULL_PATH = $(BUILD_DIR)/$(LIB_STATIC_NAME_FULL)

compile-now: make-build-dir $(LIB_FULL_PATH)

$(BUILD_DIR)/%.o: $(ROOTDIR)/%.c
	$(CC) $(CPPFLAGS) $(CFLAGS) -c -fPIC $< -o $@

.PHONY: make-build-dir objects all compile-now release debug

$(LIB_FULL_PATH): $(LIB_OBJ_FULL_PATH)
	$(CC) $(LDFLAGS) -pipe -shared -fpic -fPIC -Wl,-soname,$(LIB_SO_NAME) -o $(LIB_FULL_PATH) $(LIB_OBJ_FULL_PATH) -lc
	# and an static archive as well
	$(AR) rcs $(LIB_STATIC_FULL_PATH) $(LIB_OBJ_FULL_PATH)

make-build-dir:
	@mkdir -p $(BUILD_DIR)


