REM lstbhobj.sql checked out on 12/14/97 17:05:18 version 1.9set termout off
REM ---- Enter the minmum number of instantiations to list:50
define min_entries = '&1'

REM ---- Var '&2' not used

REM ---- Enter the Title for the top of the report:?
define app_name = '&3'

REM ---- Var '&4' not used

REM ---- Var '&5' not used

REM ---- Enter the Output file name for the report:$report_name.lst
define output_file='&6'

REM ---- Var '&7' not used

REM ----- Home for the utils
define tool_home='/home/marcm/dba_rpt'

define temp_file=mkbhobj.sql

rem
rem Created by Marc E. Marchioli
rem Copyright The DataBase Group, Inc. - 1996
rem


set feedback off
set verify off
set heading on

set termout on
prompt
prompt ******** Running DBA List Block Hash Objects
prompt
prompt WARNING! Must be RUN by SYS to view X$ tables
prompt 
set termout off
set pagesize 0
set heading off
set linesize 132
column buff fold_after 1
pool &temp_file

select
'set define ''^''' buff,
'select '''' owner, '''' segment_name, '''' segment_type, '''' dbafil, '''' dbablk, '''' state_desc, '''' occurrances' buff,
'from dual;' buff,
'set embedded on' buff,
'set heading off' buff
from dual;
select
'start ^tool_home/getbhobj '||dbafil||' '||dbablk||' '||class||' '||count(*) buff
from x$bh
group by dbafil, dbablk, class
having count(*) > &min_entries
order by 1;
select
'select '' '',''Report: lstbhobj'' from dual;' buff
from dual;
spool off

set heading on

start &tool_home/pformat
start &tool_home/rptvars
ttitle left jobdate jobtime center '&app_name' right 'Page: ' format 999 sql.pno skip 1 -
center 'Object Instantiation from X$BH' skip 1 -
center 'High number of entries indicate very busy objects that may cause bottlenecks' skip 2


column owner heading Owner format a30
column segment_name heading Object format a30
column segment_type heading Type format a11
column dbafil heading 'File Id' format a7
column dbablk heading Block format a8
column state_desc heading State format a17
column occurrances heading Entries format a7

spool &output_file
start &temp_file
spool off
host rm &temp_file
set define '&'
start &tool_home/ppcmd
exit
