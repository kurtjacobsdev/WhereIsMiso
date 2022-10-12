#!/bin/sh
set -e

echo $GOOGLE_PLIST_DECRYPT_PASSWORD
openssl enc -aes-256-cbc -d -in ../WhereIsMiso/GoogleService-Info.plist.encrypted -out ../WhereIsMiso/GoogleService-Info.plist -k $GOOGLE_PLIST_DECRYPT_PASSWORD

