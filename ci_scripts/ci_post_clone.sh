#!/bin/sh
set -e

brew install openssl

echo $CI_PROJECT_FILE_PATH
echo $CI_WORKSPACE
pwd
ls $CI_WORKSPACE
ls $CI_WORKSPACE/WhereIsMiso
openssl version

openssl enc -aes-256-cbc -d -in $CI_WORKSPACE/WhereIsMiso/GoogleService-Info.plist.encrypted -out $CI_WORKSPACE/WhereIsMiso/GoogleService-Info.plist -k $GOOGLE_PLIST_DECRYPT_PASSWORD

