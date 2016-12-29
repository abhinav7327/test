@echo off

echo --------------------------------
echo           Copy Task
echo --------------------------------

set tomcatHome=%1%
set webAppName=%2%
set CURRENT_DIR=%cd%

xcopy /E /Y /S %CURRENT_DIR%\target\assets\appl\* %tomcatHome%\webapps\%webAppName%\assets\appl\

copy %CURRENT_DIR%\target\main.swf %tomcatHome%\webapps\%webAppName%\assets\

copy %CURRENT_DIR%\target\login.swf %tomcatHome%\webapps\%webAppName%

copy %CURRENT_DIR%\target\rsls\*.swf %tomcatHome%\webapps\%webAppName%\rsls\

