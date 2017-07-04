:: MIT License
::
:: Copyright 2014-2017 Maxim Biro <nurupo.contributions@gmail.com>
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

:: Runs %app% with gdb attached. Similar to "gdb.exe -ex run %app%", except that it
:: duplicates all the output to debug-logs/<datetime>.txt.

@echo off

set app=your-app-name.exe
set config=.debug-interactive

for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set tmp=%%a
set timestamp=%tmp:~0,14%

if not exist debug-logs (mkdir debug-logs)
set logfile=debug-logs\%timestamp%.txt

echo set trace-commands on > gdb\%config%
echo set logging file %logfile% >> gdb\%config%
echo set logging on >> gdb\%config%
echo target exec %app% >> gdb\%config%
echo file %app% >> gdb\%config%

gdb\gdb.exe -x gdb\%config%

explorer.exe %logfile%

del gdb\%config%
