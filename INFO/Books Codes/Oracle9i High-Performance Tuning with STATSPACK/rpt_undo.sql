column c1 heading "Start|Time" format a15;
column c2 heading "End|Time"   format a15;
column c3 heading "Total|Undo|Blocks|Used" format 999,999;
column c4 heading "Total|Number of|Transactions|Executed" format 999,999;
column c5 heading "Longest|Query|(sec)" format 9,999;
column c6 heading "Highest|Concurrent|Transaction|Count" format 9,999;


select 
   TO_CHAR(Begin_Time,'DD-MON-YY HH24:MI')      c1,
   TO_CHAR(End_Time,'DD-MON-YY HH24:MI')        c2,
   SUM(Undoblks)                                c3,
   SUM(Txncount)                                c4,
   MAX(Maxquerylen)                             c5,
   MAX(Maxconcurrency)                          c6
from 
   stats$undostat
group by
   TO_CHAR(Begin_Time,'DD-MON-YY HH24:MI'),
   TO_CHAR(End_Time,'DD-MON-YY HH24:MI')
;

