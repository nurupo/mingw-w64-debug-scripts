# MinGW-w64 Debug Scripts

Collection of gdb scripts that you can bundle with a debug build of your MinGW-w64 application for users to report the backtrace of crashes.

## Scripts

All scripts log sessions to `debug-logs\%timestamp%.txt` files.


### debug-automatic.bat

This is what an average user would want to use.

- It starts the application with gdb attached, logging all stdout and stderr output of you application, as well as the input and output of gdb, in a single file. Note that some streams might be buffered and appear in the file way later than they actually were printed.
- When the application terminates abnormally, e.g. a crash happens, gdb outputs the backtrace, which is logged to the file.
- If the user closes the application, gdb console window also closes.
- If the user closes the gdb console window, the application also closes.
- If the application terminated abnormally, the log file containing all the logged data is opened using the default program associated for opening `.txt` files.


### debug-manual.bat

This is aimed at users familiar with gdb.

- It starts gdb with the application loaded but not running yet, logging all stdout and stderr output of you application, as well as the output of gdb, in a single file. This allows to set a breakpoint and to do other things before running the application. Note that some streams might be buffered and appear in the file way later than they actually were printed.
- After the application terminates, abnormally or not, the gdb console window will remain, allowing to input commands into it for more in-depth debugging.
- After quitting the gdb session, the log file containing all the logged data is opened using the default program associated for opening `.txt` files.


## Usage

1. In each `.bat` file, replace `your-app-name.exe` with the relative path to the application that should be debugged
2. Bundle the script with your application
3. Place `gdb.exe` next to the scripts
4. Test that the scripts work

That's it!


### Getting gdb.exe

For the step 3, get `gdb.exe` from a reputable source (e.g. msys2) or build it yourself.
It's very easy to cross-compile `gdb.exe` so please do so instead of bundling random builds you find online.
For example, you can run the following to build gdb 9.2 on a Debian Buster Docker container:

```sh
ARCH="x86_64" #or i686
GDB_VERSION="9.2"
EXPAT_VERSION="2.2.9"
apt-get update
apt-get install -y --no-install-recommends \
                autoconf \
                automake \
                build-essential \
                ca-certificates \
                g++-mingw-w64-${ARCH//_/-} \
                gcc-mingw-w64-${ARCH//_/-} \
                pkg-config \
                texinfo \
                wget
# expat is needed by gdb for debugging dlls
wget https://github.com/libexpat/libexpat/releases/download/R_${EXPAT_VERSION//./_}/expat-$EXPAT_VERSION.tar.xz
tar -xf expat*.tar.xz
rm expat*.tar.xz
cd expat*
CFLAGS="-O2 -g0" ./configure --host="$ARCH-w64-mingw32" \
                             --prefix="$PWD/prefix"
make -j$(nproc)
make install
EXPAT_PREFIX="$PWD/prefix"
cd ..
wget http://ftp.gnu.org/gnu/gdb/gdb-$GDB_VERSION.tar.xz
tar -xf gdb*.tar.xz
rm gdb*.tar.xz
cd gdb*
mkdir build
cd build
CFLAGS="-O2 -g0" ../configure --host="$ARCH-w64-mingw32" \
                              --prefix="$PWD/prefix" \
                              --with-libexpat-prefix="$EXPAT_PREFIX"
make -j$(nproc)
make install
$ARCH-w64-mingw32-strip -s prefix/bin/gdb.exe
# grab prefix/bin/gdb.exe
```

# License

MIT
