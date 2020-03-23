#!/bin/ksh

for i in `df -k|grep /u0|awk '{ print $4 }'`
do
   # Convert the file size to a numeric value
   filesize=`expr i`

   # If any filesystem has less than 100k, issue an alert
   if [ $filesize  -lt 100 ]
   then
      mailx -s "Oracle filesystem $i has less than 100k free."\
         don@burleson.cc\
         lawrence_ellison@oracle.com
   fi
done

