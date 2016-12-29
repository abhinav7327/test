@echo off

echo --------------------------------
echo    Xenos Maven Build System
echo --------------------------------

if ""%1""=="""" (%M2_HOME%\bin\mvn -help) else (%M2_HOME%\bin\mvn %*)
