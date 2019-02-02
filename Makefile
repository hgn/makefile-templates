
all: clean release clean debug

export CC=clang-7
export AR=llvm-ar-7

export LD_LIBRARY_PATH=./lib-foo/build/

scan:
	scan-build-7 -o /tmp/myhtmldir make release

release:
	make -j 16 -C lib-foo release
	make -j 16 -C app-bar release
	@echo reproducable build check:
	md5sum lib-foo/build/libfoo.so
	# aptitude install devscripts
	#hardening-check lib-foo/build/libfoo.so

debug:
	make -C app-bar debug
	make -C lib-foo debug

clean:
	make -C app-bar clean
	make -C lib-foo clean
