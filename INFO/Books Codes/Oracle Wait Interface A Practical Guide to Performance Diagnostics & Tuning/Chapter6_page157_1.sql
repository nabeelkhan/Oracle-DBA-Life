SQL> oradebug setmypid
Statement processed.
SQL> oradebug dump heapdump 2
Statement processed.
SQL> oradebug tracefile_name
/u01/admin/webmon/udump/orcl_ora_17550.trc
SQL> exit

$ grep Bucket /u01/admin/webmon/udump/orcl_ora_17550.trc > tmp.lst
$ sed 's/size=/ksmchsiz>=/' tmp.lst > tmp2.lst
$ sed 's/ Bucket //' tmp2.lst | sort -nr > tmp.lst

# Create a shell script based on the following and run it to generate
# the reusable query for the database.
echo 'select ksmchidx, (case'
cat tmp.lst | while read LINE
do
  echo $LINE | awk '{print "when " $2 " then " $1}’
done
echo 'end) bucket#,'
echo '       count(*) free_chunks,'
echo '       sum(ksmchsiz) free_space,'
echo '       trunc(avg(ksmchsiz)) avg_chunk_size'
echo 'from   x$ksmsp'
echo "where  ksmchcls = 'free'"
echo 'group by ksmchidx, (case';
cat tmp.lst | while read LINE
do
  echo $LINE | awk '{print "when " $2 " then " $1'}
done
echo 'end);'
