REM db_parms.sql checked out on 6/12/97 17:05:13 version 1.6
set termout off
REM ---- Var '&1' not used

REM ---- Enter the parameter name or wildcard to match:%
define prefix = '&2'

REM ---- Enter the Title for the top of the report:?
define app_name = '&3'

REM ---- Var '&4' not used

REM ---- Var &5 not used

REM ---- Enter the Output file name for the report:$report_name.lst
define output_file='&6'

REM ---- Var &7 not used

REM ----- Home for the utils
define tool_home='/home/marcm/dba_rpt'

rem
rem Created by Marc E. Marchioli
rem in 1990 For his personal use
rem
start &tool_home/pformat
start &tool_home/rptvars
ttitle left jobdate jobtime center '&app_name' right 'Page: ' format 999 sql.pno skip 1 -
center 'Database Parameters with Names like &prefix' skip 2

btitle center 'Report: db_parms'

set termout on
prompt
prompt ******** Running DBA Parameters Report
prompt
set termout off

set feedback off
set verify off

column  num             heading 'ID'                     format  999999999
column  name            heading 'Parameter|Name'         format  a45      
column  type            heading 'Type'                   format  a8 
column  value           heading 'Value'                  format  a50 word_wrapped
column  isdefault       heading 'Default|(Y/N)'          format  a7

spool &output_file
   
select 
  num,
  name,
  decode(type,1,'Boolean',2,'String',3,'Integer',4,'Filename',type) type,
  value,
  decode(isdefault,'TRUE','Y','FALSE','N') isdefault
from v$parameter 
where name like '&prefix'
order by name
;
spool off 
start &tool_home/ppcmd
exit
