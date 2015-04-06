@ECHO off

IF DEFINED WEBROOT_PATH (
    ECHO WEBROOT_PATH is %WEBROOT_PATH%
    GOTO :SETUP
)

ECHO set WEBROOT_PATH to D:\home\site\wwwroot
SET WEBROOT_PATH=D:\home\site\wwwroot

:SETUP
SET GOROOT=%WEBROOT_PATH%\go
SET GOPATH=%WEBROOT_PATH%\gopath
SET GOEXE=%GOROOT%\bin\go.exe
SET FOLDERNAME=azureapp
SET GOAZUREAPP=%WEBROOT_PATH%\gopath\src\%FOLDERNAME%
SET extract=false

IF EXIST %GOROOT% (
    ECHO %GOROOT% already exist
) else (
    ECHO creating %GOROOT%
    mkdir %GOROOT% 
    set extract=true
)

IF EXIST %GOPATH% (
    ECHO %GOPATH% already exist
) else (
    ECHO creating %GOPATH%\bin
    mkdir "%GOPATH%\bin"
    ECHO creating %GOPATH%\pkg
    mkdir "%GOPATH%\pkg"
    ECHO creating %GOPATH%\src
    mkdir "%GOPATH%\src"
    ECHO creating %GOAZUREAPP%
    mkdir %GOAZUREAPP%
    set extract=true
)

if %extract% == true (
    GOTO :EXTRACT
) else (
    GOTO :BUILD
)


:EXTRACT
ECHO extracting go.zip to %WEBROOT_PATH%
unzip go.zip -d %WEBROOT_PATH%

GOTO :BUILD

:BUILD
ECHO --------------------------------------------
ECHO GOROOT: %GOROOT%
ECHO GOPATH: %GOPATH%
ECHO GOEXE: %GOEXE%
ECHO GOAZUREAPP: %GOAZUREAPP%
ECHO --------------------------------------------
ECHO copying sourc code to %GOAZUREAPP%
CP gotry.go %GOAZUREAPP%
CP Web.config %WEBROOT_PATH%

ECHO Resolving dependencies
CD "%GOPATH%\src"
%GOEXE% get %FOLDERNAME%

ECHO Building ...
%GOEXE% build -o %WEBROOT_PATH%\%FOLDERNAME%.exe %FOLDERNAME%

ECHO cleaning up ...
CD %WEBROOT_PATH%
RMDIR /S /Q %GOPATH%

ECHO DONE!