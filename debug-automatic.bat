:: MIT License
::
:: Copyright 2014-2020 Maxim Biro <nurupo.contributions@gmail.com>
::
:: Permission is hereby granted, free of charge, to any person obtaining a copy
:: of this software and associated documentation files (the "Software"), to deal
:: in the Software without restriction, including without limitation the rights
:: to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
:: copies of the Software, and to permit persons to whom the Software is
:: furnished to do so, subject to the following conditions:
::
:: The above copyright notice and this permission notice shall be included in all
:: copies or substantial portions of the Software.
::
:: THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
:: IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
:: FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
:: AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
:: LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
:: OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
:: SOFTWARE.

:: User-friendly script for getting debug info on crashes. After a crash happens,
:: opens a text file containing the bt and app output.
::
:: Runs %app% with gdb attached. Redirects everything to debug-logs/<datetime>.txt.
:: If the app crashes, gdb prints the backtrace and exits immediately, terminating the
:: app and itself. After it exits, it will open the log file in whatever is set as a
:: default application to open .txt files. The user just has to provide developers
:: with contents of this file (it contains the backtrace and app's output).
:: If the application doesn't crash, gdb exits when the app exits and vice versa,
:: saving the user from frustration of typing "quit" into the gdb. In the case
:: when the app doesn't crash, the log file won't be opened.

@echo off

set app=your-app-name.exe
set config=.debug-automatic

for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set tmp=%%a
set timestamp=%tmp:~0,14%

if not exist debug-logs (mkdir debug-logs)
set logfile=debug-logs\%timestamp%.txt

echo set trace-commands on > %config%
echo target exec %app% >> %config%
echo file %app% >> %config%
:: on crash, gdb sets $_exitcode to something (we assume that it's something different
:: from -999)
echo set $_exitcode = -999 >> %config%
echo r >> %config%
:: check if we crashed
echo if $_exitcode != -999 >> %config%
echo     quit 0 >> %config%
echo else >> %config%
echo     bt >> %config%
echo     quit 75391 >> %config%
echo end >> %config%

gdb.exe -x %config% > %logfile% 2>&1

if %ERRORLEVEL% EQU 75391 explorer.exe %logfile%

del %config%
