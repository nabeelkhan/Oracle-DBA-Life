REM lstalsql.sql checked out on 12/14/97 17:05:18 version 1.7
set termout off
REM ---- Enter the minimum disk reads for the SQL statement (0 for all):50000
define min_disk_reads='&1'

REM ---- Enter the order by preference (1=> disk reads, 2=> reads/executions):1
define order_by_pref='&2'

REM ---- Enter the Title for the top of the report:?
define app_name = '&3'

REM ---- Enter the minimum disk reads/executions for the SQL statement (0 for all):10000
define disk_execs='&4'

REM ---- Var '&5' not used

REM ---- Enter the Output file name for the report:$report_name.lst
define output_file='&6'

REM ---- Var '&7' not used

REM ----- Home for the utils
define tool_home='/home/marcm/dba_rpt'

rem
rem Created by Marc E. Marchioli
rem Copyright The DataBase Group, Inc. ,1995, 1996, 1997 
rem
start &tool_home/pformat
start &tool_home/rptvars
column ord_txt new_value ord_prompt
column ord_by_txt new_value ord_by
column execs_where_txt new_value execs_where_txt
column execs_prompt_txt new_value execs_prompt_txt


select decode(&order_by_pref, '1', 'Disk Reads Descending', '2','Disk Reads/Executions Descending','Disk Reads Descending') ord_txt,
       decode(&order_by_pref, '1', 'disk_reads desc', '2','disk_reads/executions desc','Disk Reads') ord_by_txt,
       decode(&disk_execs, 0, '', 'and disk reads/executions > &disk_execs') execs_prompt_txt,
       decode(&disk_execs, 0, '', 'and executions != 0 and executions is not null and disk_reads/executions > &disk_execs') execs_where_txt
from dual;

ttitle left jobdate jobtime center '&app_name' right 'Page: ' format 999 sql.pno skip 1 -
center 'All SQL Text in v$sqlarea with disk reads > &min_disk_reads &execs_prompt_txt and ordered by &ord_prompt' skip 2

btitle center 'Report: lstalsql'

set feedback off
set verify off
set heading on


set termout on
prompt
prompt ******** Running DBA List All SQL from v$sqlarea
prompt with disk reads > &min_disk_reads
prompt &execs_prompt_txt
prompt and ordered by &ord_prompt
prompt
prompt WARNING! Requires access to V$ tables owned by 'SYS'
prompt 
set termout off

column load_time heading 'First Loaded' format a16
column users_executing heading '# |User' format 990
column executions heading 'Executions' format 9,999,990
column loads heading 'Loads' format 9990
column sql_text heading 'SQL Text' format a65 word_wrapped
column disk_reads heading 'Disk Reads' format 99,999,990
column ratio heading 'Reads/|Execs' format 999,990.9


spool &output_file
select substr(replace(first_load_time,'/',' '),1,16) load_time,disk_reads,executions,disk_reads/executions ratio,loads, sql_text
from v$sqlarea
where disk_reads > &min_disk_reads &execs_where_txt
order by &ord_by, to_date(first_load_time,'YYYY-MM-DD/HH24:MI:SS') desc;
spool off
start &tool_home/ppcmd
exit
