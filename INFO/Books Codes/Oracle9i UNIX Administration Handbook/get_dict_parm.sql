
set linesize 80
set pagesize 0
set echo off
set space 0;

set termout off

set feedback off;

set verify off;


spool /tmp/dump_&&2..ora
select 'cd '||value||'; df -k .|grep ora|awk ''{print $3}'''
from v$parameter
where name like '%dump%'
and value like '%/%'
;
spool off;

set linesize 500

spool /tmp/alert_log_dir_&&2..ora;

--select substr(value,2,length(value))
select value
from v$parameter
where
name = 'background_dump_dest'
;

spool off;

--*****************************************************
spool /tmp/log_archive_start_&&2..ora;

select 
value
from v$parameter
where
name = 'log_archive_start'
;

spool off;

--*****************************************************
spool /tmp/log_archive_dest_&&2..ora;

--select substr(value,2,length(value))
select 
   substr(value,1,instr(value,'/',-1))
from v$parameter
where
name = 'log_archive_dest'
;

spool off;
