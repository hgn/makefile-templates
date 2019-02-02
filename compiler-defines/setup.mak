cc-name = $(shell $(CC) -v 2>&1 | grep -q "clang version" && echo clang || echo gcc)
