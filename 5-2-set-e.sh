#!/bin/bash
# set -e

echo "請輸入您的姓名"
read  -t 5 username
if [ $? > 128 ]; then
    echo "您沒有在5秒內輸入姓名，請重新執行程式"
    exit 1
fi
echo "您的名字是 ${username}"
echo test1 | grep 'ttt'; echo $? | echo test2
sleep 3
echo final