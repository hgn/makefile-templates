# minimal set of warnings
CFLAGS += -Wall

# turn on all warnings
CFLAGS += -Wextra

# warn unsign/sign conversions
CFLAGS += -Wconversion -Wsign-conversion

# warn about uses of format functions
# that represent possible security problems.
# While not all programs correctly implement
# the printf hints (like glib's G_GNUC_PRINTF macro),
# adding this will at least call out simple printf
# format string vulnerabilities. Any programs whose
# builds become "noisy" as a result, should be fixed
# anyway.
CFLAGS += -Wformat
CFLAGS += -Wformat-security
# end exit here if problem occurs
CFLAGS += -Werror=format-security
# and exit if function is not known, this is shit
CFLAGS += -Werror=implicit-function-declaration

# warn for falltroughts. Search for __attribute__((fallthrough));
# if you have false positives
CFLAGS += -Wimplicit-fallthrough

# Warn whenever a switch statement does not have a
# default case
CFLAGS += -Wswitch-default

# It warns about cases where the compiler optimizes
# based on the assumption that signed overflow does
# not occur.
CFLAGS += -Wstrict-overflow

# Warn if floating-point values are used in equality
# comparisons.  In particular, instead of testing for
# equality, you should check to see whether the two
# values have ranges that overlap; and this is done
# with the relational operators, so equality
# comparisons are probably mistaken.
CFLAGS += -Wfloat-equal

# Warn whenever an object is defined whose size
# exceeds byte-size
CFLAGS += -Wlarger-than=10240

# Warn if the size of a function frame exceeds 10k
CFLAGS += -Wframe-larger-than=10240

# Warn if an undefined identifier is evaluated in an
# #if directive. Such identifiers are replaced with
# zero.
CFLAGS += -Wundef

# Warn when a function call is cast to a non-matching
# type. For example, warn if a call to a function
# returning an integer type is cast to a pointer type.
CFLAGS += -Wbad-function-cast

# Warn about constructions where there may be confusion
# to which if statement an else branch belongs. Here is
# an example of such a case:
#      if (a)
#        if (b)
#          foo ();
#      else
#        bar ();
CFLAGS += -Wdangling-else

# Warn if parentheses are omitted in certain contexts,
# such as when there is an assignment in a context where
# a truth value is expected
CFLAGS += -Wparentheses

# Warn about suspicious uses of logical operators in
# expressions. This includes using logical operators in
# contexts where a bit-wise operator is likely to be
# expected. Also warns when the operands of a logical
# operator are the same: if (a < 0 && a < 0) { … }
#CFLAGS += -Wlogical-op

# Warn if any functions that return structures or unions
# are defined or called. (In languages where you can return
# an array, this also elicits a warning.). Simple an
# allocated object
CFLAGS += -Waggregate-return

# Warn if padding is included in a structure, either to align
# an element of the structure or to align the whole structure.
# Sometimes when this happens it is possible to rearrange the
# fields of the structure to reduce the padding and so make
# the structure smaller.
# Let's the option enabled until someone complains.
CFLAGS += -Wpadded

# Warn if a function that is declared as inline cannot be
# inlined. Even with this option, the compiler does not warn
# about failures to inline functions declared in system
# headers.
CFLAGS += -Winline

# Warn about string constants that are longer than the “minimum
# maximum” length specified in the C standard.
# Just warn, probably an error.
CFLAGS += -Woverlength-strings

# Enable stack protector, -fstack-protector attempts
# to detect when a stack has # been overwritten and
# aborts the program. Ubuntu has had this enabled by
# default since Edgy. Some programs do not play nice
# with it, and can be worked around with
# -fno-stack-protector.
# fstack-protector-strong completely supersedes the earlier
# stack protector options. It only instruments functions
# that have addressable local variables or use alloca.
# -Wstack-protector flag here gives warnings for any
#  functions that aren't going to get protected
CFLAGS += -fstack-protector-strong
CFLAGS += -Wstack-protector
CFLAGS += --param ssp-buffer-size=4

# For ASLR
CFLAGS += -fPIE

# gnerates traps for signed overflow. This is a must
# for all libraries.
CFLAGS += -fwrapv

# Is recommended for hardening of multi-threaded C and
# C++ code. Without it, the implementation of thread
# cancellation handlers (introduced by pthread_cleanup_push)
# uses a completely unprotected function pointer on the stack.
# This function pointer can simplify the exploitation of
# stack-based buffer overflows even if the thread in question
# is never canceled.
CFLAGS += -fexceptions

# some flags just work for gcc
ifneq ($(cc-name),clang)
				# Look suspicious, allocate 0 and more the 10k. We
				# increase if this is required
				CFLAGS += -Walloc-zero
				CFLAGS += -Walloc-size-larger-than=10240

				# warn if something like occurs:
				#    if (some_condition())
				#        foo ();
				#        bar ();  // gotcha
				# FIXME: disabled for now, clang does not support it
				CFLAGS += -Wmisleading-indentation

				# Warn when an if-else has identical branches.
				# This warning detects cases like
				#     if (p != NULL)
				#       return 0;
				#     else
				#       return 0;
				CFLAGS += -Wduplicated-branches

				# Warn about duplicated conditions in an if-else-if
				# chain. For instance, warn for the following code:
				#    if (p->q != NULL) { … }
				#    else if (p->q != NULL) { … }
				CFLAGS += -Wduplicated-cond

				# The e compiler will warn for declarations of variable-length
				# arrays whose size is either unbounded, or bounded by an
				# argument that allows the array size to exceed byte-size bytes
				# > 512 looks way to large. We should disable VLAs altogether
				# see LKML for a security discussion about VLAs
				CFLAGS += -Wvla-larger-than=512
endif



# reproducible build, Warn when macros __TIME__, __DATE__
# or __TIMESTAMP__ are encountered as they might prevent
# bit-wise-identical reproducible compilations.
CPPFLAGS += -Wdate-time

# Buffer overflow checks. Compile-time protection against
# static sized buffer overflows. No known regressions or
# performance loss. This should be enabled system-wide
CPPFLAGS += -D_FORTIFY_SOURCE=2




# RELRO (read-only relocation). The options relro & now specified together are
# known as "Full RELRO". You can specify "Partial RELRO" by omitting the now
# flag. RELRO marks various ELF memory sections read­only (E.g. the GOT)
LDFLAGS += -Wl,-z,now -Wl,-z,relro -fpie -Wl,-pie -Wl,-z,defs

