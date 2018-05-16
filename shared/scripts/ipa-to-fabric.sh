#!/bin/sh

#  ipa-to-fabric.sh
#  voluxe-customer
#
#  Created by Christoph on 5/14/18.
#  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.

# REQUIRED environment variables
# uncomment lines below for local testing
#ARCHIVE_PATH="/Users/hermiteer/Library/Developer/Xcode/Archives/2018-05-15/Dev 5-15-18, 2.57 PM.xcarchive"
#PROJECT_DIR="/Users/hermiteer/LuxeByVolvo/git/ios/voluxe-customer"
#PODS_ROOT="/Users/hermiteer/LuxeByVolvo/git/ios/voluxe-customer/Pods"
#SCHEME_NAME=Dev
GROUP_ALIAS=ios-daily-builds

# specify the keychain because Crashlytics doesn't seem to know
# how to do this when the script is run as part of scheme post-action
export CODE_SIGN_KEYCHAIN=~/Library/Keychains/login.keychain

# upload IPA to Fabric
"${PODS_ROOT}/Crashlytics/submit" 09254e520e351430e89eaaeb71ebd9fb51390026 3dda874af75effff80ba0d5ab56693101af04a461d75192e27c578ef99a33681 \
-debug YES \
-ipaPath "${ARCHIVE_PATH}/Products/Applications/${SCHEME_NAME}.ipa" \
-notesPath "${PROJECT_DIR}/release-notes.txt" \
-groupAliases "${GROUP_ALIAS}"
