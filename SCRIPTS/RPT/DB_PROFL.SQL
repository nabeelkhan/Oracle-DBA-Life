REM db_profl.sql checked out on 12/22/97 17:05:21 version 1.1 created on 12/19/97 15:18:04
set termout off
REM ---- Enter the profile name  or wildcard to match:%
define prof_name = '&1'
 
REM ---- Enter the resource name or wildcard to match:%
define res_name = '&2'
 
REM ---- Enter Title for the top of the report:?
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
prompt ******** Reporting DB Profile Definitionsj
prompt      for &app_name 
prompt      for Profile Name like    &prof_name
prompt      and Resource name like   &res_name
prompt

set termout off
ttitle left jobdate jobtime center '&app_name' right 'Page: ' format 999 sql.pno skip 1 -
center 'Resource Profiles for profile name like &prof_name and resource name like &res_name' skip 1 -

btitle center 'Report: db_profl'

set feedback off
set verify off
set heading on


column profile  heading 'Profile Name' format a30
column resource_name heading 'Resource Name' format a32
column limit heading 'Limit' format a40


break on profile skip 1 

spool &output_file
select *
from
     dba_profiles 
where profile like upper('&prof_name')
	and resource_name like upper('&res_name')
order by profile, resource_name;
/
spool off
start &tool_home/ppcmd
exit
