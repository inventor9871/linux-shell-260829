#!/bin/bash
ver=4.7
DATE=$(date +%Y-%m-%d)
updir="/home"
twodir="mywp"
srcdir="$updir/$twodir"
DL=/root/WP
srcfile="wordpress-$ver-zh_TW.zip"
cd $DL
if [ ! -f "$srcfile" ]; then
    wget https://tw.wordpress.org/$srcfile
fi
rm -Rf wordpress
unzip $srcfile
cd $updir
cp -a $twodir $twodir.save.$DATE
cd $srcdir
rm -Rf wp-admin wp-includes
cp -R $DL/wordpress/wp-admin .
cp -R $DL/wordpress/wp-includes .
cp -Rf $DL/wordpress/wp-content/* wp-content/
cp $DL/wordpress/*.php .
echo "WordPress $ver upgrade completed."