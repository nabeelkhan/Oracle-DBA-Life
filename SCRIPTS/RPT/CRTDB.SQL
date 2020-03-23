REM crtdb.sql checked out on 3/27/96 17:05:12 version 1.3
set define '^'
column max_dfile_id new_value max_id noprint;
column max_name_len new_value max_len noprint;
column max_lfile_name new_value max_lname noprint;

select max(file_id) max_dfile_id, max(length(file_name))+2 max_name_len
from dba_data_files
where tablespace_name = 'SYSTEM';

set termout on
prompt REM Generating create SQL for database ^1
set termout off

select 
'CREATE DATABASE ^1' buff,
'	CONTROLFILE REUSE' buff,
'       '||log_mode buff,
'	DATAFILE'
from v$database;
select
'       '''||rpad(file_name||'''',^max_len,' ')||'SIZE '||bytes||decode(file_id,^max_id,'',',')
from dba_data_files
where tablespace_name = 'SYSTEM'
order by file_id;
select
'	LOGFILE'
from dual;
