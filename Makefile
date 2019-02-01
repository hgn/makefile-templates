
all: clean release clean 

export CC=clang-7

scan:
	scan-build-7 -o /tmp/myhtmldir make release

release:
	make -C app-bar release
	make -C lib-foo release
	@echo reproducable build check:
	md5sum lib-foo/build/libfoo.so
	# aptitude install devscripts
	hardening-check lib-foo/build/libfoo.so

debug:
	make -C app-bar debug
	make -C lib-foo debug

clean:
	make -C app-bar clean
	make -C lib-foo clean
