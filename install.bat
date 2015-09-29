@echo off
SET dir=%~dp0
cd %dir%
SET EXTNAME="extension-facebook"

haxelib remove %EXTNAME%
haxelib local %EXTNAME%.zip
