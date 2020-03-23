REM gnaltcmp.sql checked out on 12/22/97 18:03:06 version 1.2 created on 12/22/97 18:02:27
set termout off
set verify off
REM ---- Enter the owner of the table/index or wildcard to match:%
define owner = '&1'
 
REM ---- Enter the procedure/table/index/view name or wildcard to match:%
define obj_name = '&2'
 
REM ---- Enter the application name or comment for the script:?
define app_name = '&3'
 
REM ---- Var &4 Not used
 
REM ---- Var &5 Not used
 
REM ---- Enter the Output file name for the report:$report_name.sql
define output_file='&6'
 
REM ---- Var &7 not used
 
REM ----- Home for the utils
define tool_home='/home/marcm/dba_rpt'

rem
rem Created by Marc E. Marchioli
rem Copyright 1997 The DataBase Group, Inc.
rem
start &tool_home/pformat
start &tool_home/rptvars

set termout on
prompt
prompt ******** Generating a Compile Script in order of dependency
prompt ******** (script should only have to be run once)
prompt
prompt      for &app_name 
prompt      with owner name like &owner
prompt      and Proc/Table/Index/View name like &obj_name
prompt
set termout off

column buff fold_after 1

set heading off
set verify off
set feedback off

spool &output_file
select 'REM Compiling invalid objects for ' buff,
       'REM application &app_name' buff
from dual;
select 
		'Prompt Compiling '||initcap(object_type)||' '||owner||'.'||object_name buff,
    decode( OBJECT_TYPE, 'PACKAGE BODY', 
    'alter package ' || OWNER||'.'||OBJECT_NAME || ' compile body;', 
    'alter ' || OBJECT_TYPE || ' ' || OWNER||'.'||OBJECT_NAME || ' compile;') buff 
from 
     dba_objects dbo, 
     sys.order_object_by_dependency soobd 
where soobd.OBJECT_ID = dbo.OBJECT_ID(+)
  and STATUS = 'INVALID' 
  and OBJECT_TYPE in ( 'PACKAGE BODY', 'PACKAGE', 'FUNCTION', 'PROCEDURE', 
                      'TRIGGER', 'VIEW' ) 
  and owner like upper('&owner')
  and object_name like upper('&obj_name')
order by 
    DLEVEL DESC, 
    OBJECT_TYPE, 
    OBJECT_NAME; 
spool off
start &tool_home/ppcmd
exit
