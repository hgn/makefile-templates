
all: combi

.PHONY: combi

combi: release execute debug execute

export CC=clang-7
export AR=llvm-ar-7

# runtime variables, just to find the symbols
# and more strict
export LD_LIBRARY_PATH=./lib-foo/build/
export ASAN_OPTIONS=check_initialization_order=1
export ASAN_OPTIONS=symbolize=1
export ASAN_SYMBOLIZER_PATH=$(shell which llvm-symbolizer)

scan:
	scan-build-7 -o /tmp/myhtmldir make release

release: clean
	@echo "RELEASE"
	make -j 16 -C lib-foo release
	make -j 16 -C app-bar release
	@echo reproducable build check:
	md5sum lib-foo/build/libfoo.so
	# aptitude install devscripts
	#hardening-check lib-foo/build/libfoo.so

execute:
	./app-bar/build/app-bar

debug: clean
	@echo "DEBUG"
	make -j 16 -C lib-foo debug
	make -j 16 -C app-bar debug
	@echo reproducable build check:
	md5sum lib-foo/build/libfoo.so

clean:
	make -C app-bar clean
	make -C lib-foo clean
