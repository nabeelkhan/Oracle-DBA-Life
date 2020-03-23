REM	The script tells you how often specific 
REM	tables are loaded into memory and the 
REM	number of times those tables have been 
REM	executed. The statistics are based on 
REM	the last start of the instance. Run 
REM	this script after the instance has been 
REM	running under a normal daily load. 


set termout off feedback off echo off pagesize 59
set linesize 79 newpage 0 space 1 escape off
col iname noprint new_val instance
col today noprint new_val datetime
select name iname from v$database;
select to_char(sysdate, 'Mon DD, YYYY HH24:MI') today from dual;
btitle ce '======================================================' skip 1 -
le 'table_usage.sql' col 70 'Page: 'FORMAT 999 sql.pno

ttitle center 'Database: ' instance ' - Table Usage Report' -
skip 1 col 62 datetime skip 2
set pagesize 60
col name format A28 heading "TABLE NAME"
col tablespace format A10
col KB format 99,999,999
col sharable_mem format 99,990 heading "SHARE MEM"
col loads format 9,990
col executions format 999,990
col own noprint
break on tablespace
SPOOL rep_out\TABLE_USAGE.LST

select c.loads, c.executions, c.owner||'.'||c.name name,
t.tablespace_name tablespace, s.bytes/1024 KB, c.sharable_mem
from dba_tables t,dba_segments s,v$db_object_cache c 
where c.type = 'TABLE'
and c.executions > 0
and c.name = t.table_name
and c.owner = t.owner
and c.name = s.segment_name
and c.owner = s.owner
order by 4, 1 desc, 2 desc, 3
/

spool off;

REM	exit;
