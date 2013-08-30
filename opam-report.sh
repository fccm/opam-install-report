#!/bin/bash

export OPAMROOT="/mnt/ramdisk/opam-report/.opam"

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
    opam install -y $PKG && echo "### OK for: $PKG" || echo "### FAIL for: $PKG"
    opam remove $PKG
    echo "====== end: $PKG"
    echo ""
done

