@echo off

echo --------------------------------
echo          WAS Copy Task
echo --------------------------------

rem example of the set up
rem WebSphereHome="C:\Program Files\IBM\WebSphere\AppServer1"
rem webAppName="sutanucNode01Cell\rui.ear\rui-1.4-xenos.war"


set WebSphereHome=%1%
set webAppName=%2%
set CURRENT_DIR=%cd%

echo WAS_HOME is %WebSphereHome%

echo WEB_APPAS is %webAppName%

REM was specific configuration

xcopy /E /Y /S %CURRENT_DIR%\target\assets\appl\* %WebSphereHome%\profiles\AppSrv01\installedApps\%webAppName%\assets\appl\

copy %CURRENT_DIR%\target\main.swf %WebSphereHome%\profiles\AppSrv01\installedApps\%webAppName%\assets\

copy %CURRENT_DIR%\target\firstlogin.swf %WebSphereHome%\profiles\AppSrv01\installedApps\%webAppName%\

copy %CURRENT_DIR%\target\login.swf %WebSphereHome%\profiles\AppSrv01\installedApps\%webAppName%

copy %CURRENT_DIR%\target\rsls\*.swf %WebSphereHome%\profiles\AppSrv01\installedApps\%webAppName%\rsls\

