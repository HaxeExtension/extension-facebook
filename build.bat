@ECHO OFF
SET EXTNAME="extension-facebook"

rmdir "project\obj" /s /q
lime rebuild . ios
rmdir "project\obj" /s /q
REM Build extension
zip -r %EXTNAME%.zip extension haxelib.json include.xml project ndll dependencies frameworks template
