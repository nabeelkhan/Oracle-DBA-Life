#!/bin/ksh


tmpdir=tmp.$$

mkdir $tmpdir.new

for f in $*
do
  sed -e 's/oldstring/newstring/g' < $f > $tmpdir.new/$f
done

# Make a backup first!
mkdir $tmpdir.old
mv $* $tmpdir.old/


cd $tmpdir.new
mv $* ../

cd ..
rmdir $tmpdir.new
