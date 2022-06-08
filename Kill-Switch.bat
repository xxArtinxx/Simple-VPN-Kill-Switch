@echo off

:: GetAdmin
:-------------------------------------
:: Verify permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

:: On Error No Admin
if '%errorlevel%' NEQ '0' (
    echo Getting administrative privileges...
    goto DoUAC
) else ( goto getAdmin )

:DoUAC
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"=""
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:getAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------


@echo off
:: CHANGE DEFAULT GW IP BELOW
set defgw=192.168.1.1


@For /f "tokens=3" %%1 in (
   'route.exe print 0.0.0.0 ^|findstr "\<0.0.0.0.*0.0.0.0\>"') Do set defgw=%%1
cls
:start
cls
echo.
color 0C
echo  it's Simple VPN Kill Switch, ver. 0.1 - by xxArtinxx

echo.
echo.
echo Your routers gateway is probably "%defgw%"
echo -if nothing appears or its incorrect, add it manually (Press '3')
echo.
echo USAGE: 
echo.
echo -Press "1" to Enable Kill Switch (IP "%defgw%")
echo -Press "2" to Disable Kill Switch (IP "%defgw%")
echo -Press "3" to manually set default gateway if its not detected above.
echo -Press "h" for Kill Switch Help
echo -Press "x" to exit Kill Switch.
echo.
set /p option=Your option: 
if '%option%'=='1' goto :option1
if '%option%'=='2' goto :option2
if '%option%'=='3' goto :option3
if '%option%'=='x' goto :exit
if '%option%'=='h' goto :help
echo Insert 1, 2, x or h
timeout 3
goto start
:option1
route delete 0.0.0.0 %defgw%
echo Default gateway "%defgw%" removed
timeout 3
goto start
:option2
route add 0.0.0.0 mask 0.0.0.0 %defgw%
echo Defaulte gateway "%defgw%" restored
timeout 3
goto start
:option3
echo
set /p defgw=your gw IP (e.g. 192.168.1.1): 
goto start
:help
cls
echo.
echo. 
echo ======================
echo This simple kill switch removes your default gateway
echo and blocks traffic from reaching the internet when
echo your VPN gets disconnected.
echo. 
echo Here is how you use it.
echo.
echo Step 1: Connect to Userver
echo Step 2: Enable Userver's Kill Switch (option "1")
echo.
echo Now Any internet traffic will pass through Userver only.
echo. 
echo - If your VPN gets disconnected so will your internet.
echo - Disable the Kill Switch and reconnect.
echo.
echo.
echo When you disconnect from Userver follow these steps
echo to reconnect or to browse the internet normally.
echo.
echo Step 1: Close any software that may leak your real IP
echo Step 2: Disable the Userver kill switch (Option "2")
echo Step 3: Reconnect to Userver and enable the kill switch (Option "1")
echo.
timeout /T -1
goto start
:exit
exit
