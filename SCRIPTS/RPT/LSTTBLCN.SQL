REM lsttblcn.sql checked out on 7/24/97 17:05:19 version 1.5
set termout off
REM ---- Enter the owner of the table or wildcard to match:%
define owner = '&1'
 
REM ---- Enter the tablespace name or wildcard to match:%
define tablespace_name = '&2'
 
REM ---- Enter Title for the top of the report:?
define app_name = '&3'
 
REM ---- Enter the table name or wildcard to match:%
define prefix = '&4'
 
REM ---- Enter the delta between counts (must be a multiple of 7 and > 0):7
define increment = '&5'
 
REM ---- Enter the Output file name for the report:$report_name.lst
define output_file='&6'
 
REM ---- Enter the order by preference ( 1=> by % growth, 2 => owner, table name):2
define order_by = '&7'
 
REM ----- Home for the utils
define tool_home='/home/marcm/dba_rpt'

rem
rem Created by Marc E. Marchioli
rem in 1996 For his personal use
rem Copyright 1996 The DataBase Group, Inc.
rem
rem Uses a table like
REM CREATE TABLE "SYSTEM"."WEEKLY_TABLE_COUNTS"(
REM        "OWNER"                            VARCHAR2(30)  NOT NULL,
REM        "TABLE_NAME"                       VARCHAR2(30)  NOT NULL,
REM        "TABLESPACE_NAME"                  VARCHAR2(30)  NOT NULL,
REM        "COUNT_DATE"                       DATE      NOT NULL,
REM        "REC_COUNT"                        NUMBER  (12,0)  NOT NULL)
REM STORAGE (
REM          INITIAL 102400 K
REM          NEXT 51200 K
REM          PCTINCREASE 50
REM         )   ;
REM
REM This table can be populated by a script to generate the insert
REM statement like
REM
REM insert into weekly_table_counts
REM select 'SCOTT','EMP','USERS',sysdate,count(*) from emp;
REM
set verify off
start &tool_home/pformat
start &tool_home/rptvars
column start_date new_value begin_date noprint
column last_date new_value last_count_date noprint
column order_txt new_value order_clause noprint
column break_txt new_value break_clause noprint
column tab_owner new_value tab_owner noprint
whenever SQLERR EXIT SQL.SQLCODE

set termout on
select decode(&order_by, '1', '5 desc, 2, 3', '1, 2, 5 desc, 3') order_txt,
       decode(&order_by, '1', 'tablespace_name on owner', 'tablespace_name skip 2 on owner skip 1') break_txt,
       owner tab_owner
from all_tables
where table_name = 'WEEKLY_TABLE_COUNTS';
prompt
prompt Checking dates in table &tab_owner..WEEKLY_TABLE_COUNTS for report parameters
prompt
set termout off


select max(wtc.count_date) start_date, max(wtc1.count_date) last_date
from weekly_table_counts wtc,
     weekly_table_counts wtc1
where wtc.owner = wtc1.owner
  and wtc.table_name = wtc1.table_name
  and wtc.count_date = wtc1.count_date + &increment
  and wtc.owner like upper('&owner')
 and wtc.table_name like upper('&prefix')
/

set termout on
prompt
prompt ******** Reporting on table growth
prompt      for &app_name 
prompt      for owner like &owner
prompt      and tablespace name like &tablespace_name
prompt      and table name like &prefix
prompt      from &last_count_date to &begin_date
prompt
set termout off
ttitle left jobdate jobtime center '&app_name' right 'Page: ' format 999 sql.pno skip 1 -
center 'Table growth from &last_count_date to &begin_date for owner like &owner and tablespace like &tablespace_name' skip 1 -
center 'and table name like &prefix' skip 2

btitle center 'Report: lsttblcn'

set feedback off
set verify off
set heading on


column tablespace_name heading 'Tablespace|Name' format a30
column owner heading 'Owner' format a20
column table_name heading 'Table Name' format a30
column rec_count heading 'Record|Count' format 999,999,990
column pct_growth heading 'Growth|or Change' format 9,999.90

break on &break_clause

spool &output_file
select wtc.tablespace_name, wtc.owner, wtc.table_name, wtc.rec_count,
decode(wtc1.rec_count, 0, decode(wtc.rec_count, 0, 0, 100), (wtc.rec_count - wtc1.rec_count)/wtc1.rec_count*100) pct_growth
from weekly_table_counts wtc,
     weekly_table_counts wtc1
where wtc.owner = wtc1.owner
  and wtc.table_name = wtc1.table_name
  and wtc.count_date = '&begin_date'
  and wtc1.count_date = '&last_count_date'
  and wtc1.rec_count != wtc.rec_count 
  and wtc.tablespace_name like upper('&tablespace_name')
  and wtc.owner like upper('&owner')
  and wtc.table_name like upper('&prefix')
order by &order_clause
/
spool off
start &tool_home/ppcmd
exit
