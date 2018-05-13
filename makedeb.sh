#!/bin/bash

# make sure we know in which directory we are
cd $(dirname $0)

# grab version from desktop file
VERSION=$(sed -ne 's/Version=[^0-9]*\([0-9\.]*\)/\1/p' n9-app.desktop)

# make sure target dir is clean
rm -fr rpncalc-$VERSION 2>/dev/null

# copy template to target dir
cp -a rpncalc-template rpncalc-$VERSION
# remove placeholders, needed for storing directory structure in git, 
find rpncalc-$VERSION -name ".placeholder" -exec rm {} \;
# set version in control file
sed -i 's/VERSION/'$VERSION'/g' rpncalc-$VERSION/DEBIAN/control

# copy current files to target dir
cp -p n9-app.desktop rpncalc-$VERSION/usr/share/applications/
cp -a main.py qml img rpncalc-$VERSION/opt/rpncalc/

# don't distribute emacs backup files
find rpncalc-$VERSION -name "*~" -exec rm {} \;

# HERE we make the deb file - files inside deb must be owned by root
fakeroot bash -c 'chown -R root.root rpncalc-'$VERSION'/{opt,usr}; dpkg -b rpncalc-'$VERSION

# target dir is really a temporary dir, so remove it now
rm -fr rpncalc-$VERSION 2>/dev/null
