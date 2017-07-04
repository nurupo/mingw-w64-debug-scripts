EXE_NAME=your-app-name.exe

all: i686 x86_64

i686:
	mkdir -p output/i686
	cp debug-*.bat output/i686
	sed -i "s|your-app-name.exe|$(EXE_NAME)|g" output/i686/debug-*.bat
	wget https://sourceforge.net/projects/mingw-w64/files/External%20binary%20packages%20%28Win64%20hosted%29/gdb/i686-w64-mingw32-gdb-7.1.90.20100730.zip
	echo "d393f4a5b205645aa6d021bc75cffad1fefe9f147fad87950e7f9f17f1758e70  i686-w64-mingw32-gdb-7.1.90.20100730.zip" | sha256sum -c -
	unzip i686-w64-mingw32-gdb-7.1.90.20100730.zip
	rm i686-w64-mingw32-gdb-7.1.90.20100730.zip
	mkdir output/i686/gdb
	cp mingw32/bin/gdb.exe output/i686/gdb
	cp mingw32/bin/libiconv-2.dll output/i686/gdb
	rm -rf ./mingw32

x86_64:
	mkdir -p output/x86_64
	cp debug-*.bat output/x86_64
	sed -i "s|your-app-name.exe|$(EXE_NAME)|g" output/x86_64/debug-*.bat
	wget https://sourceforge.net/projects/mingw-w64/files/External%20binary%20packages%20%28Win64%20hosted%29/gdb/x86_64-w64-mingw32-gdb-7.1.90.20100730.zip
	echo "e555b17ee9bcc607ff1aa46e089dab95a363f44c16ac92fb110ac39783c899f6  x86_64-w64-mingw32-gdb-7.1.90.20100730.zip" | sha256sum -c -
	unzip x86_64-w64-mingw32-gdb-7.1.90.20100730.zip
	rm x86_64-w64-mingw32-gdb-7.1.90.20100730.zip
	mkdir output/x86_64/gdb
	cp mingw64/bin/gdb.exe output/x86_64/gdb
	cp mingw64/bin/libiconv-2.dll output/x86_64/gdb
	rm -rf ./mingw64

clean:
	rm -f i686-w64-mingw32-gdb-7.1.90.20100730.zip x86_64-w64-mingw32-gdb-7.1.90.20100730.zip
	rm -rf ./output
