#!/bin/zsh
set -e

which openssl
brew install openssl
echo 'export PATH="/usr/local/opt/openssl@3/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc

echo $CI_PROJECT_FILE_PATH
echo $CI_WORKSPACE
pwd
ls $CI_WORKSPACE
ls $CI_WORKSPACE/WhereIsMiso
openssl version
which openssl

openssl enc -aes-256-cbc -d -in $CI_WORKSPACE/WhereIsMiso/GoogleService-Info.plist.encrypted -out $CI_WORKSPACE/WhereIsMiso/GoogleService-Info.plist -k $GOOGLE_PLIST_DECRYPT_PASSWORD

