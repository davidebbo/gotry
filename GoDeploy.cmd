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

IF EXIST %GOROOT% (
    ECHO %GOROOT% already exist
) else (
    ECHO creating %GOROOT%
    MKDIR %GOROOT% 
    GOTO :EXTRACT
)

GOTO :BUILD

:EXTRACT
ECHO extracting go.zip to %WEBROOT_PATH%
UNZIP go.zip -d %WEBROOT_PATH%

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
