REM lst_deps.sql checked out on 6/12/97 17:05:17 version 1.4
set termout off
REM ---- Enter the Owner of the objects or wildcard to match:%
define owner = '&1'
 
REM ---- Enter the object name or wildcard to Match:%
define prefix = '&2'
 
REM ---- Enter the Title for the top of the report:?
define app_name = '&3'
 
REM ---- Var '&4' not used
 
REM ---- Var '&5' not used
 
REM ---- Enter the Output file name for the report:$report_name.lst
define output_file='&6'
 
REM ---- Var '&7' not used
 
REM ----- Home for the utils
define tool_home='/home/marcm/dba_rpt'

rem Created by Marc E. Marchioli
rem in 1990 For his personal use
rem
start &tool_home/pformat
start &tool_home/rptvars
 
set feedback off
set verify off
set heading off

column buff fold_after 1
 
set termout on
prompt
prompt ******** Running DBA List Dependencies 
prompt Generating list of dependencies of objects (tables, views, procedures, functions)
prompt for owner like:       &owner
prompt and object name like: &prefix
prompt
select
'There are '||count(dbt.object_name)||' objects' buff,
'for owner:  ''&owner'' with names like: ''&prefix''.' buff
from all_objects dbt
where dbt.owner like upper('&owner')
  and dbt.object_name like upper('&prefix');

set termout off
set heading on
ttitle left jobdate jobtime center '&app_name' right 'Page: ' format 999 sql.pno skip 1 -
center 'Object Dependencies for Owner like &owner and Object Names like &prefix'

btitle center 'Report: lst_deps'

column parent_obj format a60 heading 'Object'
column ref_obj format a66 heading 'Referenced by'

break on parent_obj skip 1 on report

spool &output_file

select p.owner||'.'||p.object_name||' '||lower(p.status) parent_obj,
       lpad(' ',order#-1)||d.owner||'.'||d.object_name||' '||lower(d.status)  ref_obj
from sys.dependency$ sd,
     all_objects p,
     all_objects d
where p_obj# in (select object_id from all_objects sa 
	       where sa.owner like upper('&owner') 
	 	 and sa.object_name like upper('&prefix'))
  and p.object_id = p_obj#
  and d.object_id = d_obj#
  and order# != 0
order by p.object_name,order#;
spool off
start &tool_home/ppcmd
exit
