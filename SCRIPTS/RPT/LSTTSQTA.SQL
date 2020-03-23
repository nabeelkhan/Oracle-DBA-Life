REM lsttsqta.sql checked out on 6/12/97 17:05:18 version 1.4
set termout off
REM ---- Enter the User Name or the wildcard to match:%
define user_name='&1'

REM ---- Enter the Tablespace Name or wildcard to Match:%
define prefix='&2'

REM ---- Enter the Title for the top of the report:?
define app_name = '&3'

REM ---- Var '&4' not used

REM ---- Var '&5' not used

REM ---- Enter the Output file name for the report:$report_name.lst
define output_file='&6'

REM ---- Var '&7' not used

REM ----- Home for the utils
define tool_home='/home/marcm/dba_rpt'

rem
rem Created by Marc E. Marchioli
rem in 1996 For his personal use
rem Copyright 1995 The DataBase Group, Inc.
rem
start &tool_home/pformat
start &tool_home/rptvars
ttitle left jobdate jobtime center '&app_name' right 'Page: ' format 999 sql.pno skip 1 -
center 'Tablespace quotas for User Name like &user_name and Tablespace Name like &prefix' skip 2

btitle center 'Report: lsttsqta'

set feedback off
set verify off
set heading on

set termout on
prompt
prompt ******** Running DBA List Tablespace Quotas Report
prompt for User Name like:         &user_name
prompt and Tablespace Name like:   &prefix
prompt 
set termout off

column tablespace_name heading 'Tablespace Name' format a30
column username heading 'User Name' format a12
column kb heading 'Current|Kb' format 9,999,990
column max_kb heading 'Max Kb|(- => unlimited)' format 9,999,990
column blocks heading 'Current|Blocks' format 9,999,990
column logoff_pread heading 'Max|Blocks|(- => unlimited)' format 9,999,990

break on tablespace_name skip 1 on username
compute sum of kb on tablespace_name
compute sum of blocks on tablespace_name

spool &output_file
select tablespace_name, username, bytes/1024 Kb, max_bytes/1024 max_kb, blocks, max_blocks
from dba_ts_quotas
where username like upper('&user_name')
  and tablespace_name like upper('&prefix')
order by tablespace_name, username 
/
spool off
start &tool_home/ppcmd
exit
