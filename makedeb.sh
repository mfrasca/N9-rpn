#!/bin/bash

# good starting point contains exactly one .desktop file, and a src directory
if [ $(ls -d *.desktop | wc -l) != 1 ]
then
    echo "the current work directory should contain exactly one *.desktop file."
    exit 1
fi
if [ ! -f *.desktop ]
then
    echo "there is a *.desktop in the current directory, but it is not a file."
    exit 1
fi
if [ ! -d src ]
then
    echo "there is no src directory in the current work directory"
    exit 2
fi

PACKAGE_NAME=$(basename *.desktop .desktop)

# grab version from desktop file
VERSION=$(sed -ne 's/Version=[^0-9]*\([0-9\.]*\)/\1/p' $PACKAGE_NAME.desktop)

# make sure target dir is clean
rm -fr $PACKAGE_NAME-$VERSION 2>/dev/null

# copy template to target dir
cp -a $PACKAGE_NAME-template $PACKAGE_NAME-$VERSION
# remove placeholders, needed for storing directory structure in git, 
find $PACKAGE_NAME-$VERSION -name ".placeholder" -exec rm {} \;
# set version in control file
sed -i 's/VERSION/'$VERSION'/g' $PACKAGE_NAME-$VERSION/DEBIAN/control

# copy current files to target dir
cp -p $PACKAGE_NAME.desktop $PACKAGE_NAME-$VERSION/usr/share/applications/
cp -a src/* $PACKAGE_NAME-$VERSION/opt/$PACKAGE_NAME/

# don't distribute emacs backup files
find $PACKAGE_NAME-$VERSION -name "*~" -exec rm {} \;

# HERE we make the deb file - files inside deb must be owned by root
fakeroot bash -c 'chown -R root.root '$PACKAGE_NAME'-'$VERSION'; dpkg -b '$PACKAGE_NAME'-'$VERSION

# target dir is really a temporary dir, so remove it now
rm -fr $PACKAGE_NAME-$VERSION 2>/dev/null
