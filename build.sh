#!/bin/bash
dir=`dirname "$0"`
cd "$dir"
PKG_NAME="extension-facebook"

rm -rf project/obj
lime rebuild . ios
rm -rf project/obj

rm -f "$PKG_NAME.zip"
zip -r "$PKG_NAME.zip" extension haxelib.json include.xml project ndll dependencies frameworks template
