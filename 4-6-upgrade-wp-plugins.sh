#!/bin/bash
DIR="mywp1 mywp2"
pl_DIR="/root/WP/"
plugin="akismet"
ver="4.1.11"
for i in $DIR; do
  cd /home/$i/wp-content/plugins
  if [ ! -d "$plugin" ]; then
  rm -Rf $plugin
  fi
  if [ -f $plugin.*.zip ]; then
    rm -Rf $plugin.*.zip
  fi
  unzip $pl_DIR/$plugin.$ver.zip
  echo "$i $plugin upgrade completed."
done