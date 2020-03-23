rep_out/waiters
start title132.sql "Database Layout " "dbmap.sql"
prompt ====================================== 
prompt Tablespace/Datafile Listing 
prompt ===================================== 
prompt 
prompt 
column "Location" format A60; 
column "Tablespace Name" format A15; 
column "Size(M)" format 999,990; 

break on "Tablespace Name" skip 1 nodup; 
compute sum of "Size(M)" on "Tablespace Name"; 

SELECT tablespace_name "Tablespace Name", 
file_name "Location", 
bytes/1048576 "Size(M)" 
FROM sys.dba_data_files 
order by tablespace_name; 

prompt 
prompt ====================================== 
prompt Redo Log Listing 
prompt ===================================== 
prompt 
prompt 
column "Group" format 999; 
column "File Location" format A50; 
column "Bytes (M)" format 99,990; 

break on "Group" skip 1 nodup; 


select a.group# "Group", 
b.member "File Location", 
(a.bytes/1024) "Bytes (K)" 
from v$log a, 
v$logfile b 
where a.group# = b.group# 
order by 1,2; 


prompt 
prompt ====================================== 
prompt Control File Listing 
prompt ===================================== 
prompt 
prompt 
column name format A80 heading "CONTROL FILE NAME" 
column status format a10 heading "STATUS"
select
name,
status
from
v$controlfile 
;

prompt 
prompt ====================================== 
prompt Rollback Listing 
prompt ===================================== 
prompt 
prompt 
column "Segment Name" format A15; 
column "Tablespace" format A15; 
Column "Initial (M)" Format 99,990; 
Column "Next (M)" Format 99,990; 
column "Min Ext." FORMAT 9999; 
column "Max Ext." FORMAT 99999999999; 
column "Status" Format A7; 

select segment_name "Segment Name", 
tablespace_name "Tablespace", 
(initial_extent/1024)/1024 "Initial (M)", 
(next_extent/1024)/1024 "Next (M)", 
min_extents "Min Ext.", 
max_extents "Max Ext.", 
status "Status" 
from sys.dba_rollback_segs 
order by tablespace_name, 
segment_name; 
spool off;
