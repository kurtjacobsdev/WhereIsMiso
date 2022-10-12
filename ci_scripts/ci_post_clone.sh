#!/bin/zsh
set -e

brew install openssl
echo 'export PATH="/usr/local/opt/openssl@3/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc

openssl enc -aes-256-cbc -d -in $CI_WORKSPACE/WhereIsMiso/GoogleService-Info.plist.encrypted -out $CI_WORKSPACE/WhereIsMiso/GoogleService-Info.plist -k $GOOGLE_PLIST_DECRYPT_PASSWORD

