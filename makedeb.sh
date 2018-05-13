#!/bin/bash

# make sure we know in which directory we are
cd $(dirname $0)

# grab version from desktop file
VERSION=$(sed -ne 's/Version=[^0-9]*\([0-9\.]*\)/\1/p' n9-app.desktop)

# clean target dir
rm -fr rpncalc-$VERSION 2>/dev/null
# copy template to target dir, and set version in control file
cp -a rpncalc-template rpncalc-$VERSION
sed -i 's/VERSION/'$VERSION'/g' rpncalc-$VERSION/DEBIAN/control
# remove placeholders needed for directory structure in git
find rpncalc-$VERSION -name ".placeholder" -exec rm {} \;
find rpncalc-$VERSION -name "*~" -exec rm {} \;

# finally copy current files to target dir
cp -p n9-app.desktop rpncalc-$VERSION/usr/share/applications/
cp -a main.py qml img rpncalc-$VERSION/opt/rpncalc/

# and make deb file
fakeroot bash -c 'chown -R root.root rpncalc-'$VERSION'/{opt,usr}; dpkg -b rpncalc-'$VERSION

# target dir is really a temporary dir, so remove it now
rm -fr rpncalc-$VERSION 2>/dev/null
