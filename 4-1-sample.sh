#!/bin/bash
function showName(){
  echo "今天是$1, $2大大來自於$3"
}

name="$1"
ip='192.168.0.1'
today=$(date +%F)

if [ "$#" != 1 ]; then
 echo "Usage: ./$0 {使用者名稱}"
 exit
fi

showName "$today" "$name" "$ip"
sleep 5
echo
echo 'by'