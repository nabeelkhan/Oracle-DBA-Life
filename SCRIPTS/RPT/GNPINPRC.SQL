REM gnpinprc.sql checked out on 12/14/97 17:05:16 version 1.4
set termout off
REM ---- Enter the Owner of the objects or wildcard to match:%
define owner = '&1'
 
REM ---- Enter the object name or wildcard string:%
define prefix = '&2'
 
REM ---- Enter Title for the top of the report:?
define app_name = '&3'
 
REM ---- Enter minimum number of executions for the procedures/functions above this will be pinned:100
define max_execs = &4
 
REM ---- Var &5 not used
 
REM ---- Enter the Output file name for the report:$report_name.sql
define output_file='&6'
 
REM ---- Var &7 not used
 
REM ----- Home for the utils
define tool_home='/home/marcm/dba_rpt'
 
rem
rem Created by Marc E. Marchioli
rem Copyright 1996, 1997 The DataBase Group, Inc.
rem
start &tool_home/pformat
start &tool_home/rptvars

set termout on
prompt
prompt ******** Generating PL/SQL procedure to pin objects
prompt for all &app_name procedures, packages, and functions
prompt      for owner like      &owner
prompt      and procedure/function/package/trigger 
prompt                name like &prefix
prompt      and executions > &max_execs
prompt
set termout off
set feedback off
set verify off
set embedded on
set pagesize 0
set heading off
column buff fold_after 1

spool &output_file
select
'REM Generated on '||to_char(sysdate, 'Mon DD, YYYY HH24:MI:SS')||' for &app_name' buff,
'set serveroutput on' buff,
'begin' buff, 
'     /* Sharable Mem  Executions  Loads  Kept */' buff
from dual;

select
'     /*'||to_char(sharable_mem,'999,999,990')||to_char(executions, '999,999,990')||to_char(loads,'999,990')||'    '||kept||' */     sys.dbms_shared_pool.keep('''||owner||'.'||name||''||decode(type, 'TRIGGER',''', ''R'');' ,''');')
from v$db_object_cache vdo
where type <> 'NOT LOADED'
  and type in ('PACKAGE','FUNCTION','PROCEDURE', 'TRIGGER')
  and owner like upper('&owner')
  and name like upper('&prefix')
  and executions > &max_execs
order by executions desc, sharable_mem desc, loads desc;
select
'     exception' buff,
'          when OTHERS then' buff,
'               dbms_output.put_line(''Error occurred: ''||SQLERRM);' buff,
'end;' buff,
'.' buff,
'/' buff
from dual;
spool off
start &tool_home/ppcmd
exit
