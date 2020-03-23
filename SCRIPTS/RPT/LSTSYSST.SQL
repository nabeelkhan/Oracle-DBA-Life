REM lstsysst.sql checked out on 11/17/97 17:05:21 version 1.1
set termout off
REM ---- Enter the Statistic NAME  or wildcard to match:%
define stat_name = '&1'
 
REM ---- Enter the Statistic NUMBER or 0 for all/any:0
define stat_num = '&2'
 
REM ---- Enter Title for the top of the report:?
define app_name = '&3'
 
REM ---- Enter order by preference (1=> Statistic name; 2=> Class, Name; 3=> Value desc):1
define order_by_pref = '&4'
 
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

column where_txt new_value where_txt noprint
column order_by_txt new_value order_by_txt noprint
column order_by_prompt new_value order_by_prompt noprint
column break_txt new_value break_txt noprint

select decode('&stat_num', '0','', 'and statistic# = &stat_num') where_txt,
			 decode(&order_by_pref, '1', 'name', '2','class, name','value desc') order_by_txt,
			 decode(&order_by_pref, '1', 'report', '2','report on class skip 1','report') break_txt,
			 decode(&order_by_pref, '1', 'Statistic Name', '2','Statistic Class, Name','Statistic value descending') order_by_prompt
from dual;

set termout on
prompt
prompt ******** Reporting DB System Statistics
prompt      for &app_name 
prompt      for Statistic Name like &stat_name
prompt      &where_txt ordered by &order_by_prompt
prompt

set termout off
ttitle left jobdate jobtime center '&app_name' right 'Page: ' format 999 sql.pno skip 1 -
center 'Database System Statistics for Statistic name like &stat_name and Statistic number = &stat_num' skip 1 -
center 'ordered by &order_by_prompt' skip 1 -
center 'block size is &blocksize bytes' skip 1

btitle 'Report: lstsysst'

set feedback off
set verify off
set heading on

column name  heading 'Statistic Name' format a70
column value heading 'Value|times are 100th seconds' format 999,999,999,999,999,999,999,990

break on &break_txt

spool &output_file
select name, class, value
from
     v$sysstat
where name like '&stat_name' &where_txt
order by &order_by_txt
/
spool off
start &tool_home/ppcmd
exit
