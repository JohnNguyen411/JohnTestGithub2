#!/bin/sh

#  xcarchive-to-ipa.sh
#  voluxe-customer
#
#  Created by Christoph on 5/14/18.
#  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.

# REQUIRED environment variables
# uncomment lines below for local testing
#ARCHIVE_PATH="/Users/hermiteer/Library/Developer/Xcode/Archives/2018-05-15/Dev 5-15-18, 11.18 AM.xcarchive"
#PROJECT_DIR="/Users/hermiteer/LuxeByVolvo/git/ios/voluxe-customer"

# Currently we only support signing for development builds.
# This is extracted into a variable to make it easier to
# change or specify this from an argument.
EXPORT_PLIST_TYPE=development

# export archive as IPA
xcodebuild \
-exportArchive \
-archivePath "${ARCHIVE_PATH}" \
-exportPath "${ARCHIVE_PATH}/Products/Applications" \
-exportOptionsPlist "${PROJECT_DIR}/export/export-options-${EXPORT_PLIST_TYPE}.plist"
