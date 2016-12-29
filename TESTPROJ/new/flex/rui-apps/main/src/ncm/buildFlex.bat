@echo off
echo %FLEX_HOME%
rem Make sure prerequisite environment variables are set
if not "%FLEX_HOME%" == "" goto gotFlexHome
echo The FLEX_HOME environment variable is not defined
echo This environment variable is needed to run this program
goto exit
:gotFlexHome
rem set FLEX_HOME=%FLEX_HOME%\bin
echo FLEX_HOME = %FLEX_HOME%
if not exist "%FLEX_HOME%\bin\mxmlc.exe" goto noFlexHome
if not exist "%FLEX_HOME%\bin\compc.exe" goto noFlexHome
if not exist "%FLEX_HOME%\bin\asdoc.exe" goto noFlexHome
if not exist "%FLEX_HOME%\bin\fdb.exe" goto noFlexHome
goto okFlexHome
:noFlexHome
echo The FLEX_HOME environment variable is not defined correctly
echo This environment variable is needed to run this program
goto exit
:okFlexHome
set PATH="%PATH%";"%FLEX_HOME%\bin"
set CURRENT_DIR=%cd%
set MODULE=%1%
set COMPL_DIR=%CURRENT_DIR%\src
echo Current Directory %CURRENT_DIR%
echo COMPILATION Directory %COMPL_DIR%
if not exist "%COMPL_DIR%" goto noMxmlDir
rem set RSLS_ARGS = -runtime-shared-library-path=%CURRENT_DIR%\..\..\..\assembly\src\web\flex\libs\framework.swc,rsls/framework_3.0.0.477.swf -runtime-shared-library-path=%CURRENT_DIR%\..\..\..\assembly\src\web\flex\libs\rpc.swc,rsls/rpc_3.0.0.477.swf -runtime-shared-library-path=%CURRENT_DIR%\..\..\..\assembly\src\web\flex\libs\datavisualization.swc,rsls/datavisualization_3.0.0.477.swf -runtime-shared-library-path=%CURRENT_DIR%\target\local-libs\core-4.10.120.0.0.swc,rsls/core-4.10.120.0.0.swf
mxmlc -locale=en_US -source-path=%CURRENT_DIR%\..\..\locale/{locale} -include-resource-bundles=collections,containers,controls,core,effects,ncmResources,skins,styles -output=%CURRENT_DIR%\..\..\target\assets\appl\%MODULE%\ncmResources_en_US.swf
rem FOR %%f IN (%COMPL_DIR%\*.MXML) DO mxmlc -locale=en_US -source-path=%CURRENT_DIR%\..\..\locale/{locale} -include-resource-bundles=collections,core,effects,ncmResources,skins,styles -load-config=%CURRENT_DIR%\..\..\..\..\..\assembly\src\web\flex\flex-config.xml -runtime-shared-library-path=%CURRENT_DIR%\..\..\..\..\..\assembly\src\web\flex\libs\framework.swc,rsls/framework_3.0.0.477.swf -runtime-shared-library-path=%CURRENT_DIR%\..\..\..\..\..\assembly\src\web\flex\libs\rpc.swc,rsls/rpc_3.0.0.477.swf -runtime-shared-library-path=%CURRENT_DIR%\..\..\..\..\..\assembly\src\web\flex\libs\datavisualization.swc,rsls/datavisualization_3.0.0.477.swf -runtime-shared-library-path=%CURRENT_DIR%\..\..\target\local-libs\core-4.10.120.0.0.swc,rsls/core-4.10.120.0.0.swf -runtime-shared-library-path+=%CURRENT_DIR%\..\..\target\local-libs\ref-4.10.120.0.0.swc,rsls/ref-4.10.120.0.0.swf -runtime-shared-library-path+=%CURRENT_DIR%\..\..\target\local-libs\ncm-4.10.120.0.0.swc,rsls/ncm-4.10.120.0.0.swf -runtime-shared-library-path+=%CURRENT_DIR%\..\..\target\local-libs\gle-4.10.120.0.0.swc,rsls/gle-4.10.120.0.0.swf %%f
"%JAVA_HOME%\bin\java" -Xmx1024m -jar "%FLEX_HOME%\lib\compiler.jar" %CURRENT_DIR%/../../target/local-libs/core-4.10.120.0.0.swc,rsls/core-4.10.120.0.0.swf %CURRENT_DIR%/../../target/local-libs/ref-4.10.120.0.0.swc,rsls/ref-4.10.120.0.0.swf %CURRENT_DIR%/../../target/local-libs/gle-4.10.120.0.0.swc,rsls/gle-4.10.120.0.0.swf %CURRENT_DIR%/../../target/local-libs/ncm-4.10.120.0.0.swc,rsls/ncm-4.10.120.0.0.swf
if not exist "%CURRENT_DIR%\..\..\target\assets\appl\%MODULE%" mkdir %CURRENT_DIR%\..\..\target\assets\appl\%MODULE%
FOR %%f IN (%COMPL_DIR%\*.swf) DO MOVE /Y %COMPL_DIR%\*.swf %CURRENT_DIR%\..\..\target\assets\appl\%MODULE%
rem MOVE /Y %CURRENT_DIR%\..\..\locale\en_US\ncmResources_en_US.swf %CURRENT_DIR%\target\assets\appl\%MODULE%
:buildComplete
echo 
echo *****************  FLEX Build %1% Successfull  *******************************
rem pause
rem exit
goto endBUILD
:noMxmlDir
echo Following directory not found: %COMPL_DIR%
:endBUILD
rem pause
rem call cd ..
rem exit
:exit
rem pause
rem exit /b 1
