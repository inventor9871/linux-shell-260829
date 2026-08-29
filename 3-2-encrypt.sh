#!/bin/bash
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 password file"
    exit 1
fi
pass=$1
file=$2
[ ! -f "$file" ] && echo "File not found!" && exit 2
echo $pass | gpg --batch --yes --passphrase-fd 0 --cipher-algo AES256 -c "$file"

# echo $pass | gpg --batch --yes --passphrase-fd 0 -o hello1 -d $file
# gpg -d hello.log.gpg > hello1
