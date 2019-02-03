
# Address sanitizer:
# If a bug is detected, the program will print an error
# message to stderr and exit with a non-zero exit code.
# AddressSanitizer exits on the first detected error.
#
# This is by design:
#
#   - This approach allows AddressSanitizer to produce
#     faster and smaller generated code (both by ~5%).
#   - Fixing bugs becomes unavoidable. AddressSanitizer
#     does not produce false alarms. Once a memory
#     corruption occurs, the program is in an inconsistent
#     state, which could lead to confusing results and
#     potentially misleading subsequent reports.
#
# Detects out-of-bounds access, use-after-free,
# use-after-scope, double-free/invalid-free and is adding
# support for memory leaks.
#
# Expected memory overhead: 3x
CFLAGS += -fsanitize=address


# various local undefined behaviors such as unaligned
# pointers, integral/floating point overflows, etc... 
#
# minimal slow-down - slight code size increase
CFLAGS += -fsanitize=undefined


# there are enough general purpose register nowadays.
# A meaningful stack trace if superior to saving just
# one register (we left x86 with their limited set of
# registers)
CFLAGS += -fno-omit-frame-pointer



# yes, required for linker too
LDFLAGS += -fsanitize=address
LDFLAGS += -fsanitize=undefined

# some flags just work for clang
ifeq ($(cc-name),clang)
				CFLAGS += -fsanitize-memory-track-origins
				LDFLAGS += -fsanitize-memory-track-origins
endif

