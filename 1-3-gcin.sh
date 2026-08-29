#!/bin/bash
apt-get update
apt-get install -y gcin
cat <<EOF > /etc/X11/Xsession.d/99gcin
export GTK_IM_MODULE=gcin
export QT_IM_MODULE=gcin
export XMODIFIERS="@im=gcin"
gcin&
EOF
echo 'please relogin to desktop'