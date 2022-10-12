#!/bin/sh
set -e

echo $CI_PROJECT_FILE_PATH
echo $CI_WORKSPACE
openssl enc -aes-256-cbc -d -in ../WhereIsMiso/GoogleService-Info.plist.encrypted -out ../WhereIsMiso/GoogleService-Info.plist -k $GOOGLE_PLIST_DECRYPT_PASSWORD

