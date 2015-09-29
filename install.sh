#!/bin/bash
dir=`dirname "$0"`
cd "$dir"
PKG_NAME="extension-facebook"

haxelib remove "$PKG_NAME"
haxelib local "${PKG_NAME}.zip"
