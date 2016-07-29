#!/bin/sh

set -e

git submodule init
git submodule update

ln -s vimrc ~/.vimrc
vim -c:VundleInstall -c:q
