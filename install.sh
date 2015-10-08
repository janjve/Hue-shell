#! /bin/sh

INSTALL_DIR='/usr'
CONF_DIR='/etc/hue-shell'

if cp -v README.md /tmp/hue-shell-test-cp > /dev/null 2>&1 ; then
	CP='cp -v'
else
	CP='cp'
fi

# etc
mkdir -p $CONF_DIR
if [ -f $CONF_DIR/hue-shell.conf ]; then
        $CP -f $CONF_DIR/hue-shell.conf $CONF_DIR/hue-shell.conf.bak
fi
$CP -rf config/* $CONF_DIR

# lib
mkdir -p $INSTALL_DIR/lib/hue-shell
$CP base.sh $INSTALL_DIR/lib/hue-shell

# bin
$CP bin/hue* $INSTALL_DIR/bin

# Temp files. The should "survive" reboot.
TMP="$HOME/.config/hue-shell"
mkdir -p $TMP
TMP_FILES="$TMP/daemon.pid $TMP/hue-shell.pids $TMP/hue-shell-random.seed"
touch $TMP_FILES
chmod 666 $TMP_FILES

# doc
DOC='/usr/share/doc/hue-shell'
mkdir -p $DOC
$CP doc/* $DOC

# /etc/init.d
if [ -d '/etc/init.d' ]; then
	$CP startup/SysVinit /etc/init.d/hue-shell
fi

# systemd
if [ -d '/etc/systemd/system' ]; then
	$CP startup/systemd /etc/systemd/system/hue-shell.service
fi

# triggerhappy
if [ -d /etc/triggerhappy/triggers.d ]; then
	$CP triggerhappy/hue-shell.conf /etc/triggerhappy/triggers.d/
fi

# vim: set ts=8 sw=8 sts=8 et :
# sublime: tab_size 8;
