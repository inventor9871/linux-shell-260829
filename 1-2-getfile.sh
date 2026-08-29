#!/bin/bash
link="ftp://XXX.bash.tar.gz"
mkdir -p WORK/
cd WORK/
wget $link
tar -xvzf bash.tar.gz