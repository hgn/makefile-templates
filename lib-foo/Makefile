LIB_NAME = libfoo
LIB_VERSION = 1.0.0
LIB_VERSION_MAJOR = 1

# flags for release builds
release: CFLAGS += -DNDEBUG
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

LIB_SO_NAME = $(LIB_NAME).so.$(LIB_VERSION_MAJOR)
LIB_NAME_FULL = $(LIB_NAME).so
LIB_FULL_PATH = $(BUILD_DIR)/$(LIB_NAME_FULL)

compile-now: make-build-dir $(LIB_FULL_PATH)

$(BUILD_DIR)/%.o: $(ROOTDIR)/%.c
	$(CC) $(CFLAGS) -c -fPIC $< -o $@

.PHONY: make-build-dir objects all compile-now release debug

$(LIB_FULL_PATH): $(LIB_OBJ_FULL_PATH)
	$(CC) -shared -fPIC -Wl,-soname,$(LIB_SO_NAME) -o $(LIB_FULL_PATH) $(LIB_OBJ_FULL_PATH) -lc

make-build-dir:
	@mkdir -p $(BUILD_DIR)

clean:
	@rm -rf $(BUILD_DIR)
	@rm -rf $(LIB_FULL_PATH)
