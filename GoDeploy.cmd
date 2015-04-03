@echo off

IF DEFINED WEBROOT_PATH (
    echo WEBROOT_PATH is %WEBROOT_PATH%
    GOTO :SETUP
)

echo set WEBROOT_PATH to D:\home\site\wwwroot
SET WEBROOT_PATH=D:\home\site\wwwroot

:SETUP
SET GOROOT=%WEBROOT_PATH%\go
SET GOPATH=%WEBROOT_PATH%\gopath
SET GOEXE=%GOROOT%\go\bin\go.exe
SET extract=false

IF EXIST %GOROOT% (
    echo %GOROOT% already exist
) else (
    echo creating %GOROOT%
    mkdir %GOROOT% 
    set extract=true
)

IF EXIST %GOPATH% (
    echo %GOPATH% already exist
) else (
    echo creating %GOPATH%\bin
    mkdir "%GOPATH%\bin"
    echo creating %GOPATH%\pkg
    mkdir "%GOPATH%\pkg"
    echo creating %GOPATH%\src
    mkdir "%GOPATH%\src"
    set extract=true
)

if %extract% == true (
    GOTO :EXTRACT
) else (
    GOTO :BUILD
)


:EXTRACT
echo extracting go.zip to %WEBROOT_PATH%
unzip go.zip -d %WEBROOT_PATH%

GOTO :BUILD

:BUILD
echo --------------------------------------------
echo GOROOT: %GOROOT%
echo GOPATH: %GOPATH%
echo --------------------------------------------
%GOEXE% get -u > log.txt
%GOEXE% build gotry.go > log.txt

echo DONE!