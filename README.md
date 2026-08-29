# 看書(linux shell，臥龍小三 著)的筆記

## 第一章 sehll 簡介
- 檔名不一定要 .sh，只是方便知道是 sh (檔案 hello，就沒有.sh，一樣可以執行) 
- sh 第一行建議要 #!/bin/bash
(若沒寫，當下系統會「好心」用預設的 Shell 來幫你讀取並執行它)
- 執行方式有兩種，一種是設定權限(建議，之後自動化的時候比較方便)
```
# 設定權限
chmod +x hello

# 執行，在檔案前面加 ./
./hello
```
- 另一種不須改權限，直接執行，一般 USER 也可以
(G: 其實是叫你目前正在使用的這個 Shell 直接把該檔案裡面的文字拿來一行一行讀進來執行。這根本不是去「執行」一個程式，所以完全不需要執行權限)
```
# 執行，在檔案前面加 .，空一格
. hello
```
- /dev/null，是特殊檔案，會歸零
```
#!/bin/bash
cp /dev/null /var/log/apache2/access.log
# /var/log/apache2/access.log 很重要
```
- 定時每天6點執行 hello.sh
```
# 開啟 排程編輯器
crontab -e

# 每天6點，依照 「分 時 日 月 週」 的順序填入規則
0 6 * * * /bin/bash /root/hello.sh

#每十五分鐘執行(若 hello.sh 有 chmod +x，前面就不用加 /bin/bash )
*/15 * * * * /root/hello.sh

# 查看 排程編輯器
crontab -l
```
- 遠端抓檔案，並自動解壓縮(步驟就像我們平常的動作，寫在 sh 裡面)
```
#!/bin/bash
link="ftp://XXX.bash.tar.gz"
mkdir -p WORK/
cd WORRK/
wget $link
tar xvzf bash.tar.gz
```
最後別忘了改權限 並執行
```
chmod +x getfile.sh && ./getfile.sh
```
- Debian Linux 建立中文化環境 (1-3-gcin.sh)
要切換 root 執行
```
# 保留在使用者原來的位置
sudo su
# 直接切換成 root 位置
sudo -i
```

## 第二章 部署 sehll 
- 查看預設 shell
```
echo $SHELL

# 會發現 sh 連結到 bash 或 dash 
ls -la /bin/sh
```
- 使用者登入時，使用哪個 sh
```
cat /etc/passwd

# 第七欄 :/bin/bash 可以改成 /bin/nologin
sudo usermod -s /bin/nologin 使用者名稱
```

- 安裝修正檔，步驟如下
patch→設定→編譯→測試→安裝
```
# patch套用修正檔，看有幾個就要執行幾個
patch -p0 < ../bash44-001
patch -p0 < ../bash44-002

# 設定，預設安裝在 /usr/local
./configure

# 編譯，根據相依關係，自動判斷哪些檔案需要重新編譯或更新，並執行對應的指令
make

# 測試，確認無誤
make tests

# 安裝，root 安裝
sudo -
make install
```
- FreeBSD 預設是 tcsh
OpenBSD 預設是 ksh
Windows 可以使用 Cygwin、MSYS2 安裝 bash

## 第三章 基礎概念 
- 登入有兩種，主機登入、遠端登入
- **主機登入**是直接在電腦前面登入
ctrl + alt + F1~F7 (預設七個終端機)
- **遠端登入**
```
ssh 帳號@主機名稱或 IP

# 若沒有帳號，預設是用目前的帳號
```
- 登出，輸入 exit，或是 ctrl + d
- 檔案種類
```
- ，一般檔案，文字檔、二進位檔、執行檔
b ，設備檔，區塊檔，系統與硬體之間的溝通介面
d ，目錄
l ，連結檔，檔案捷徑的概念。
p ，pipe 管線檔，一個行程將資料寫入 pipe，再由另一個行程讀取。
s ，socket檔，和遠端主機通訊的管道。

```
- 兩種方式看檔案類型
```
ls -la /etc/passwd
# 最左邊的字元，就是檔案類型
# -rwx 或 drwx

file /etc/passwd
# 顯示 ASCII text
```
- 檔案路徑 有兩種，絕對路徑、相對路徑。
**絕對路徑**最前面一定有 /，例如 /etc。
**相對路徑**，若寫 etc/，表示在這目錄中的 etc/目錄。
```
# 查看目前路徑
pwd

# 切換到家目錄
cd ~

# 回到上一層
cd ..
```
- 檔案權限，三種身分，四種權限

| 三種身分 | 四種權限 | 
| ------- | ------- | 
| u，自己 |r，讀取，代表數字 4 | 
| g，群組 |w，寫入，代表數字 2| 
| o，other其他人 |x，執行 與 進入，代表數字 1| 
| a，all 所有人 |s 特殊權限 | 

- 使用情況
```
# 目錄要讓他人進去就要加上
chmod o+x /hello/

# 全部人都可以執行，危險
chmod +x test.sh

# 應該限定自己可以執行
chmod u+x teet.sh
```

- 特殊權限看第一個數字，後面三個數字分別就是 u、g、o

|  數字 | 權限表示  |
| --- | --- |
| 0755 | 0，沒有特殊權限 | 
| 4755 | 4，表示可以代表檔案擁有者 | 
| 2755 | 2，表示可以代表檔案擁有群組 |
| 1755 |  1，只有自己可以刪除這個檔案 | 

- 特殊字元

```
*，表示任意的字元，可以是空字串。

ls -la /usr/bin/*
# 會列出所有檔案

ls -la /tmp/*.zip
# 列出所有.zip 檔


?，代表一個字元，不可是空的。

ls -la /usr/bin/????
# 會列出檔名長度為 4 的檔案

\，跳脫字元 

echo This is Jack\'s book.
# 就等於下面的
echo "This is Jack's book."

\，接續符號，有時程式碼太長想要換行就在最後輸入 \
echo " This is \
        Jack's book."
```

- IFS，分隔字元變數。預設是\n、空白、tab字元(3-1-ifs.sh)
```
#!/bin/bash
# IFS 改成 \n，遇到空白、tab 就不換行(有些檔案名有空白)

IFS=$'\n'
for f in $(ls)
do
    echo $f
done
```

- 字元集合

| 字元 | 意思 | 
| -------- | -------- | 
| [a-z]     | 英文字母小寫     | 
| [A-Z]     | 英文字母大寫     | 
| [a-zA-Z]     | 英文字母大寫、小寫     | 
| [0-9]     | 數字     | 
| [a-zA-Z0-9]     | 英文數字     | 
| e[rsx]     | 是er 或 es 或 ex     | 
| [!a-z]     | 不是小寫     | 

- 括號擴展
```
# 會建立 a、b、c 目錄，裡面又各建立 d、e、f 目錄
mkdir -p /tmp/{,b,c}/{d,e,f}

# bash 4.0 開始才有遞增遞減
echo {1..11..3}
# 印出 1 4 7 10，每個+3

echo {100..80..5}
# 100 95 90 85 80
```
- 序列擴展
```
echo {1..4}
# 1 2 3 4

echo {a..d}
# a b c d
```
- 系統預設開啟的檔案


| 檔案 | 代碼 | 
| -------- | -------- | 
| 標準輸入，stdin     | 0     | 
| 標準輸出，stdout     | 1     | 
| 標準錯誤，stderr     | 2     | 

- 轉向輸出 >，轉向輸入 <
```
sort < unsort.txt > sorted.txt
# 會將 unsort.txt 的資料先給 sort，之後再輸出給 sorted.txt

# 也可以
cat unsort.txt | sort > sorted.txt
```

- 管線
```
grep '".*" 4[0-9][0-9]' access.log \
# 作用：從 access.log 檔案中篩選出包含雙引號內的內容，且後面接著 4 開頭的三位數錯誤碼（即 400 到 499）的日誌行。

| grep -o '".*" 4[0-9][0-9]' \
# 透過 -o（only-matching）參數，只抓出符合條件的那一段文字（也就是雙引號包住的請求內容加上後面的 4xx 狀態碼），把整行日誌中多餘的 IP、時間、User-Agent 等雜訊過濾掉。

| sort \
# 將剛才抓出來的文字進行排序。

| uniq -c  \
# 將相鄰的重複項目合併，並在每一行前方加上出現的次數（Count）。

| sort -n \
# 讓出現次數最少的排在最上面、最多的排在最下面

| tee allog.txt
# 將最終整理好的結果同時輸出到螢幕上，並儲存一份到 allog.txt 檔案中。
```

- 建立 ssh_keyfile，手動用 sshkey 登入伺服器
主機產生ssh_keyfile(公鑰、私鑰)。
私鑰留在自己的主機內 /home/user/.ssh/id_rsa
公鑰是 /home/user/.ssh/id_rsa.pub
公鑰 可以傳到任何伺服器 /home/user/.ssh/authorized_keys
```
#!/bin/bash
HOST=192.168.168.168

# 建立公私鑰
ssh-keygen -b 4096

# 在伺服器建立 ~/.ssh 目錄，需要輸入密碼
ssh $HOST mkdir -p '~/.ssh'

# 用登入密碼來建立 authorized_keys
cat ~/.ssh/id_rsa.pub | ssh $HOST "cat >> .ssh/authorized_keys"

# 修改權限
ssh $HOST chmod 700 '~/.ssh'
ssh $HOST chmod 600 '~/.ssh/*'
```

- ssh-copy-id，自動 sshkey 登入伺服器
```
#!/bin/bash
HOST=192.168.168.168
ssh-keygen -b 4096
ssh-copy-id $HOST
# 這時需要輸入登入密碼。
# ssh-copy-id 是屬於openssh-client 套件。
```

- gpg 加密、解密
```
# 加密，此時會產生檔名.gpg
echo 密碼 | gpg --batch --yes --passphrase-fd 0 --cipher-algo AES256 -c 哪個檔案

# 解密
echo 密碼 | gpg --batch --yes --passphrase-fd 0 -o "新的檔案" -d "加密檔案"

#簡單解密，直接問密碼
gpg -d secret.txt.gpg > secret.txt
```
- 背景執行，在執行程式後面加個 &
通常我都會另外開一個 terminal
```
./my-work.sh &

# 看哪些程式在背景執行
jobs

# 輸入 fg %1 可以把編號 1 的背景程式拉回前景繼續互動
```


## 第四章，shell 組成

- 簡單範例
```
#!/bin/bash
function showName(){
  echo "今天是$1, $2大大來自於$3"
}

name="$1"
ip='192.168.0.1'
today=$(date +%F)

# 這編寫 !=1，會噴錯，!= 兩邊都要有空格
if [ $# != 1 ]; then
 echo "Usage: ./$0 {使用者名稱}"
 exit
fi

showName $today $name $ip
sleep 5
echo
echo 'by'
```
- 執行方法
```
# 只有 ./test.sh 需要先改權限
chmod u+x test.sh
chmod 700 test.sh

# 其他都可以執行
. test.sh
bash test.sh
source test.sh
```

- 檢查語法
```
bash -v test.sh
bash -x test.sh
```
- login shell 與 執行 shell
當我們登入的時候就已經是個 shell(login)，而執行的 shell 又是另外開啟一個
```
#!/bin/bash
cd 'a dir'
touch hi.txt
```
./test.sh，是 執行shell，不會到 'a dir'目錄。
. test.sh、source test.sh，是叫 login shell 執行，執行完後就去 'a dir'。

- 查看在哪一個 shell
```
echo $SHLVL
# shell level

# 可以在呼叫一個 bash
bash
echo $SHLVL

# 退出 bash
exit

# 觀察記憶體中的行程
ps axf
```
- 登入、登出 的執行檔
登入→ /etc/profile (全部人通用的，會被使用者的覆蓋)
 →使用者的 ~/.bash_profile → ~/.bash_login → ~/.profile
關鍵規則：只要在前一個檔案被找到了，Bash 讀完之後就會「停下來」，不會繼續往下讀後面的檔案。

登出→ ~/.bash_logout，非高手請勿亂改。

- 執行新的 shell，會去讀取 /etc/bash.bashrc 及 ~/.bashrc

- 變數，等號兩邊不能有空格
```
# 簡單設定
myname='OL'

# 變數=$(執行程式)
Dday=$(date '+%Y%m%d')

# 取得變數，若左右還有字元，用 {} 隔開
echo $myname
echo 我愛${myname}很多
```
- 設定環境變數，但只要關閉這個shell，環境變數就沒了
```
export testVar="hello world"
echo $testVar
```
- 陣列，不用事先定義
```
a[0]=0
a[1]=1

# 顯示一定要加大括號
echo ${a[0]}

#顯示全部
files=(*)
echo ${files[*]}
```
- 標準輸入 0 /輸出 1 /錯誤 2
 \> 後面接檔名，而 >& 是接標準輸出
```
# 假設沒有 z 開頭的檔案，ls z* 畫面就會顯示找不到(就是錯誤)
ls z*

# 將錯誤導向檔案
ls z* 2> err.log

# > 後面接檔名，而 >& 是接標準輸出
ls z* > /dev/null
# 正確就去 /dev/null，但因為錯誤，所以還是會顯示

ls z* > /dev/null 2>&1
# 這樣就不會顯示錯誤
```

- 取出第幾欄位的資料，cut -d' '，(用空格來分欄位)
```
date | cut -d' ' -f3
# 取出第三欄位的資料

tail /etc/passwd | cut -d':' -f7
#取出第七欄位，登入的shell
```
- 命令列的參數

| 參數  | 代表值  | 
| -------- | -------- | 
| $0     | 執行檔名     |
| \$1~$n     | 後面的參數     |
| $#    | 參數的總數     |
| $?    | 會記錄上次執行結果，0代表成功  |

- 判斷真假，中括號要有空格
```
[ 3 -gt 2 ] 
# 回傳 0，表示 true

[ -f /etc/passwd ]
# 回傳 0，表示 true
```
- 條件判斷，兩種寫法
```
# then 沒有接在 if 後面

if 命令為真
then
    做動作
fi
```
```
# then 接在 if 後面，要用分號 ;

if 命令為真; then
    做動作
fi

# 如果沒有 xx.zip，就去下載
if [ ! -f xx.zip ]; then
    wget https://ooo/xx.zip
fi
```
- for 迴圈
```
for 變數名自己取 in 範圍
do
    做動作
done
-----------------------

for char1 in A B C D
do
    echo "$char1"
done
```
找出所有的檔案
```
#!/bin/bash
shopt -s nullglob dotglob
# shopt shell 的 option選項
# -s 打開(set)，-u 關閉(unset)
# nullglob，如果找不到任何檔案，它會直接展開成「空字串（什麼都沒有）」。
# dotglob，能抓隱藏檔
# 這在寫腳本防呆時非常重要！

files=(*)
for f in ${files[@]}; 
do
    echo $f
done
```
- while 迴圈
```
while 條件
do
    做動作
done

----------------------

#!/bin/bash
# IFS設定為無，可以順利取得含有空白的檔名
IFS=

while read -r line; do
  echo "$line"
done < <(ls ./*)
# <(程式碼) 將結果轉向輸入
```
- 升級 wordpress(4-5-upgrade-wp.sh)
刪除兩個舊目錄，wp-admin、wp-includes
貼上三個新目錄，wp-admin、wp-includes、wp-content
貼上所有的php

- 升級 WP 模組(4-6-upgrade-wp-plugins.sh)
刪除舊的模組，wp-content/plugins/old模組
貼上新的模組，wp-content/plugins/new模組







- ex
```
#!/bin/bash
```


| Column  | Column  | 
| -------- | -------- | 
| Text     | Text     | 
