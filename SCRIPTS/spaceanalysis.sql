REM	A script to track the space utilization of 
REM	your database over time 

REM	You must create a table and run this script first
REM	CREATE TABLE space_check
REM	(
REM	TS_NAME VARCHAR2(100),
REM	free_space VARCHAR2(100),
REM	timestamp DATE,
REM	total_space VARCHAR2(100));

insert into NK_DBA.space_check select a.tablespace_name, sum(a.bytes) free_space, 
sysdate timestamp , sum(b.bytes) total_space 
from dba_data_files a, dba_free_space b 
where a.tablespace_name = b.tablespace_name group by a.tablespace_name;

commit;

REM	===============================================
REM	Then run this script
REM	===============================================
REM BY NK 04/04/2005

SPOOL rep_out\analyze.lis
set pagesize 199
REM set feed off;
PROMPT ************************************
PROMPT * Tablespace Growth Analysis 
PROMPT ************************************
column tablespace_name format a15 
column col1 format 9999999.99 heading 'Today'
column col2 format 9999999.99 heading '1 wk ago'
column col3 format 999.99 heading '% dif '
column col4 format 9999999.99 heading '2 wks ago'
column col5 format 999.99 heading '% dif '
column col6 format 9999999.99 heading '3 wks ago'
column col7 format 999.99 heading '% dif '
column col8 format 9999999.99 heading '4 wks ago'
column col9 format 999.99 heading '% tot';
select distinct a.tablespace_name,
a.free_space/a.total_space*100 col1,
b.free_space/b.total_space*100 col2,
((a.free_space/a.total_space)/(b.free_space/b.total_space)-1)*100 col3,
c.free_space/c.total_space*100 col4,
((b.free_space/b.total_space)/(c.free_space/c.total_space)-1)*100 col5,
d.free_space/d.total_space*100 col6,
((c.free_space/c.total_space)/(d.free_space/d.total_space)-1)*100 col7,
e.free_space/e.total_space*100 col8,
((b.free_space/b.total_space)/(e.free_space/e.total_space)-1)*100 col9
from NK_DBA.space_check a, NK_DBA.space_check b, NK_DBA.space_check c, NK_DBA.space_check d,
NK_DBA.space_check e 
where trunc(a.timestamp) = trunc(sysdate)
and trunc(b.timestamp(+)) = trunc(sysdate-7)
and b.tablespace_name (+) = a.tablespace_name
and trunc(c.timestamp(+)) = trunc(sysdate-14)
and c.tablespace_name (+) = a.tablespace_name
and trunc(d.timestamp(+)) = trunc(sysdate-21)
and d.tablespace_name (+) = a.tablespace_name
and trunc(e.timestamp(+)) = trunc(sysdate-28)
and e.tablespace_name (+) = a.tablespace_name
order by tablespace_name
/

spool off;

REM	exit
