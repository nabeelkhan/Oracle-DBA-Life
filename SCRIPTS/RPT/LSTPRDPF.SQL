REM lstprdpf.sql checked out on 6/12/97 17:05:18 version 1.5
set termout off
REM ---- Enter the User Name to list product user profile for or the wildcard to match:%
define user_name='&1'

REM ---- Enter the Product name (e.g. SQL*PLUS) or wildcard to Match:%
define product_name='&2'

REM ---- Enter the Title for the top of the report:?
define app_name = '&3'

REM ---- Var '&4' not used

REM ---- Var '&4' not used

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
center 'Product User Profile for Username like &user_name and Product Name like &product_name' skip 2

btitle center 'Report: lstprdpf'

set feedback off
set verify off
set heading on

set termout on
prompt
prompt ******** Running DBA List Product User Profile Report
prompt for User Name like:      &user_name
prompt and Product Name like:   &product_name
prompt 
set termout off

column userid heading 'User Name' format a12
column product heading 'Product' format a30
column attribute heading 'Action' format a30
column char_value heading 'Ability' format a15

break on product skip 1 on userid skip 1

spool &output_file
select product, userid, attribute, char_value
from system.product_profile
where userid like upper('&user_name')
  and product like upper('&product_name')
order by product, userid, attribute
/
spool off
start &tool_home/ppcmd
exit
