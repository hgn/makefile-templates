
all: release

release:
	make -C app-bar release
	make -C lib-foo release

debug:
	make -C app-bar debug
	make -C lib-foo debug

clean:
	make -C app-bar clean
	make -C lib-foo clean
