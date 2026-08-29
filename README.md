# 看書(linux shell，臥龍小三 著)的筆記

## 第一章
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
# 保留原來的位置
su -
# 直接切換成 root 位置
sudo -i
```










- ex
```
#!/bin/bash

```
