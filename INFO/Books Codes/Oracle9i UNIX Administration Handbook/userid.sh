#*****************************************************************
#
# Copyright (c) 2002 by Donald K. Burleson
#
# Licensing information may be found at www.dba-oracle.com
#
#*****************************************************************

for HOST1 in `cat /usr/local/dba/sh/userid| cut -d":" -f1`
do
        echo " "
        echo "==============="
        echo "HOST= $HOST1"
        echo "==============="
        # Now, get the database names on each box...
        for DB in `remsh $HOST1 -n "cat /etc/oratab | grep :Y|cut -d":" -f1"`
        do
               echo "     "
               echo "     --------------"
               echo "     DB= $DB"
               echo "     --------------"
               #Now, we log into the database
               TWO_TASK=t:$HOST1:$DB
               export TWO_TASK DB
   su oracle -c "/usr/oracle/bin/sqlplus /<<!
select username from dba_users where username like '%UGA%';
exit; 
!"
         done
done
exit
