#!/bin/bash

OS="mga"

### XXX be very carefull: rm -rf is arround!
BASEDIR="/tmp/opam-report"
#BASEDIR="/mnt/ramdisk/opam-report"

export OPAMROOT="$BASEDIR/.opam"

LOGDIR="$BASEDIR/logs-$OS-`date --iso`"
mkdir -p $LOGDIR

export LANG="en_US.UTF-8"
export LANGUAGE="en_US.UTF-8:en"

rm -rf $OPAMROOT
echo n | opam init
eval `opam config env`

PKG_LIST=`opam list --short`
for PKG in $PKG_LIST
do
  rm -rf $OPAMROOT
  echo n | opam init
  eval `opam config env`

    echo ""
    echo "====== begin: $PKG"
    opam install -y $PKG
    if [ "$?" = "0" ]; then STATUS="YEAH"; else STATUS="ARGH"; fi
    if [ "$STATUS" = "YEAH" ]; then echo "### OK for: $PKG"; fi
    if [ "$STATUS" = "ARGH" ]; then echo "### FAIL for: $PKG"; fi
    if [ "$STATUS" = "ARGH" ]; then
        PKG_LOG_DIR="`basename $OPAMROOT/system/build/$PKG*`"
        mkdir -p $LOGDIR/$PKG_LOG_DIR/
        echo "### copy logs to: $PKG_LOG_DIR/"
        cp $OPAMROOT/system/build/$PKG_LOG_DIR/$PKG-*.err $LOGDIR/$PKG_LOG_DIR/
        cp $OPAMROOT/system/build/$PKG_LOG_DIR/$PKG-*.out $LOGDIR/$PKG_LOG_DIR/
    fi
    opam remove $PKG
    echo "====== end: $PKG"
    echo ""
done

