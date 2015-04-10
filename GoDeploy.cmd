@ECHO off

IF DEFINED WEBROOT_PATH (
    ECHO WEBROOT_PATH is %WEBROOT_PATH%
    GOTO :SETUP
)

ECHO set WEBROOT_PATH to D:\home\site\wwwroot
SET WEBROOT_PATH=D:\home\site\wwwroot

:SETUP
SET GOROOT=D:\Program Files\go\1.4.2
SET GOPATH=%WEBROOT_PATH%\gopath
SET GOEXE="%GOROOT%\bin\go.exe"
SET FOLDERNAME=azureapp
SET GOAZUREAPP=%WEBROOT_PATH%\gopath\src\%FOLDERNAME%

IF EXIST %GOPATH% (
    ECHO %GOPATH% already exist
    
    ECHO Removing %GOAZUREAPP%
    RMDIR /S /Q %GOAZUREAPP%
) else (
    ECHO creating %GOPATH%\bin
    MKDIR "%GOPATH%\bin"
    ECHO creating %GOPATH%\pkg
    MKDIR "%GOPATH%\pkg"
    ECHO creating %GOPATH%\src
    MKDIR "%GOPATH%\src"
)

ECHO creating %GOAZUREAPP%
MKDIR %GOAZUREAPP%

ECHO --------------------------------------------
ECHO GOROOT: %GOROOT%
ECHO GOEXE: %GOEXE%
ECHO GOPATH: %GOPATH%
ECHO GOAZUREAPP: %GOAZUREAPP%
ECHO --------------------------------------------
ECHO copying sourc code to %GOAZUREAPP%
CP gotry.go %GOAZUREAPP%

ECHO Resolving dependencies
CD "%GOPATH%\src"
%GOEXE% get %FOLDERNAME%

ECHO Building ...
%GOEXE% build -o %WEBROOT_PATH%\%FOLDERNAME%.exe %FOLDERNAME%

ECHO cleaning up ...
CD %WEBROOT_PATH%
RMDIR /S /Q %GOPATH%

ECHO DONE!
