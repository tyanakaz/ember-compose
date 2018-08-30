#!/bin/sh

cd .. 
ember new myapp
cp -a myapp/. app >/dev/null 2>&1
rm -rf myapp
