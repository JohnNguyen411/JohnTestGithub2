#!/bin/sh

#  increment_build.sh
#  voluxe-customer
#
#  Created by Christoph on 5/14/18.
#  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.

# plist location
# note that to test locally the script must be run
# from the project root aka the directory the project file is in
#PROJECT_DIR="/Users/hermiteer/LuxeByVolvo/git/ios/voluxe-customer"
PLIST=${PROJECT_DIR}/voluxe-customer/Resources/Info.plist

# ensure path is correct
if [ -f "$PLIST" ]
then
echo "Incrementing BUNDLE_VERSION on $PLIST"
else
echo "Could not find $PLIST"
exit
fi

# get the current bundle version from plist
BUNDLE_VERSION=$(defaults read ${PLIST} CFBundleVersion)
if [ "$BUNDLE_VERSION" == null ] || [ -z "$BUNDLE_VERSION" ]
then
BUNDLE_VERSION=0
fi

# increment by 1
BUNDLE_VERSION=$((BUNDLE_VERSION+1))
echo "BUNDLE_VERSION incremented to $BUNDLE_VERSION"

# update plist
plutil -replace CFBundleVersion -string ${BUNDLE_VERSION} ${PLIST}

# commit and push to git
cd "${PROJECT_DIR}"
git add "${PLIST}"
git commit -m "Bump build number to ${BUNDLE_VERSION}"
git push origin HEAD
