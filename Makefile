all: shoplist.exe

shoplist.exe: main.adb
	gnatmake -o shoplist.exe main.adb

