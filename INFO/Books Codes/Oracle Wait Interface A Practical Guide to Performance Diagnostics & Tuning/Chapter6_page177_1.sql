-- Oracle9i Database and above
select * 
from   v$enqueue_stat 
where  cum_wait_time > 0
order by inst_id, cum_wait_time;

-- Oracle 7.1.6 to 8.1.7
select inst_id,
       ksqsttyp "Lock", 
       ksqstget "Gets", 
       ksqstwat "Waits"
from   x$ksqst
where  ksqstwat > 0
order by inst_id, ksqstwat;
