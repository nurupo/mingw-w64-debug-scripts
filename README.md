# MinGW-w64 Debug Scripts

A bundle that includes a working MinGW-w64 `gdb` program and a small collection of gdb scripts that you can bundle with a debug build of your MinGW-w64 application for users to report the backtrace of crashes.

## Scripts

### debug-automatic.bat

This is what your average user would want to use.

- It starts your application with gdb attached, logging all stdout and stderr output of you application, as well as the input and output of gdb, in a single file. Note that some streams might be buffered and appear in the file way later than they actually were printed.
- When the application terminates abnormally, e.g. a crash happens, gdb outputs the backtrace, which is logged to the file.
- If the user closes the application, gdb console window also closes.
- If the user closes the gdb console window, the application also closes.
- If the application terminated abnormally, the log file containing all the logged data is opened using the default program associated for opening `.txt` files.


### debug-manual.bat

This is aimed more at users familiar with gdb.

- It starts gdb with your application loaded but not running yet, logging all stdout and stderr output of you application, as well as the output of gdb, in a single file. This allows you to set a breakpoint and to do other things before running the application. Note that some streams might be buffered and appear in the file way later than they actually were printed.
- After the application terminates, abnormally or not, the gdb console window will remain, allowing you to input commands into it for more in-depth debugging.
- After quitting the gdb session, the log file containing all the logged data is opened using the default program associated for opening `.txt` files.

## Usage

Run

```sh
make EXE_NAME=your-app-name.exe
```
to produce bundles for `i686` and `x86_64` architectures.

You may manually specify `i686` and `x86_64` targets, if you want just one of them.

This should create `output` directory with the following directory structure

```sh
.
├── i686
│   ├── debug-automatic.bat
│   ├── debug-manual.bat
│   └── gdb
│       ├── gdb.exe
│       └── libiconv-2.dll
└── x86_64
    ├── debug-automatic.bat
    ├── debug-manual.bat
    └── gdb
        ├── gdb.exe
        └── libiconv-2.dll
```

Put contents of `i686` directory alongside your `i686` exe file and contents of `x86_64` directory alongside your `x86_64` exe file, and you should be able to just run the bat scripts.

# License

MIT
