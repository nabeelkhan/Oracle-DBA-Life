REM lstdbsz7.sql checked out on 10/18/97 17:05:18 version 1.8
set termout off
REM ---- Enter the Owner of the tables or wildcard to match:%
define owner = '&1'

REM ---- Enter the table name or wildcard string:%
define prefix = '&2'

REM ---- Enter Title for the top of the report:?
define app_name = '&3'

REM ---- Enter Re-analyze switch to analyze TABLES (Y) or use existing statistics(N):n
define tab_val_switch = '&4'

REM ---- Enter the Re-analyze switch to analyze INDEXES (Y) (required to view index stats on first run):Y
define ind_val_switch = '&5'

REM ---- Enter the Output file name for the report:$report_name.lst
define output_file='&6'

REM ---- Enter the amount of rows for space available to report on (enter 0 for all tables):0
define min_rows = '&7'

REM ----- Home for the utils
define tool_home='/home/marcm/dba_rpt'

rem
rem Created by Marc E. Marchioli
rem in 1996 For The DataBase Group, Inc.
rem Copyright 1996 The DataBase Group, Inc.
rem
start &tool_home/pformat
start &tool_home/rptvars
column tab_where_txt new_value tab_where_clause noprint
column ind_where_txt new_value ind_where_clause noprint
column my_txt new_value my_txt noprint
column order_txt new_value order_clause noprint
column break_txt new_value break_clause noprint
column tab_val_txt new_value tab_val_txt noprint
column ind_val_txt new_value ind_val_txt noprint
column load_txt new_value load_clause noprint

select decode(&min_rows, 0, ' ',
'and decode(avg_row_len, 0, 0, ((empty_blocks*&blocksize)/avg_row_len)) <= &min_rows and empty_blocks is not null') tab_where_txt,
decode(&min_rows, 0, ' ',
'and decode((nvl(lf_rows_len,0)/decode(nvl(lf_rows,1),0,1)), 0, 0, ((ist.blocks - (ist.lf_blks + ist.br_blks))*&blocksize)/(lf_rows_len/lf_rows)
) <= &min_rows and used_space is not null') ind_where_txt,
decode(&min_rows, 0, ' ', 'and number of rows in space available < &min_rows') my_txt,
decode(&min_rows, 0, 'order by 1,2,3 desc', 'order by 10 desc, 1,2,3 desc') order_txt,
decode(&min_rows, 0, 'on report on owner skip 3 on ord_tablename skip 2 on typ on num_rows','on report') break_txt,
decode(upper('&tab_val_switch'), 'Y','Analyzing tables ',
                                  'Using old statistics for all_tables.') tab_val_txt,
decode(upper('&tab_val_switch'), 'Y','Tables analyzed.', ' ') load_txt,
decode(upper('&ind_val_switch'), 'Y','Analyzing Indexes ',
                                  'Using old statistics sotred in MY_INDEX_STATS.') ind_val_txt,
decode(upper('&ind_val_switch'), 'Y','Indexes analyzed.', ' ') load_txt
from dual;

ttitle left jobdate jobtime center '&app_name' right 'Page: ' format 999 sql.pno skip 1 -
center 'Table and Size for a block size of ' format 9999 blocksize ' bytes for Owner like &owner and Names like &prefix' skip 1 -
center 'Values are actual from table all_tables' skip 2

btitle center 'Report: lstdbsz7'

column buff fold_after 1

column owner noprint
column ord_tablename      heading 'Object Name' format a32 word_wrapped
column name             heading 'Table/Index|Name' format a20
column num_rows       heading 'Number|of Rows' format 99,999,990
column avg_row_len    heading 'Average|Row|Length|(b)' format 9,999
column next_extent    heading 'Next|Extent|(Kb)' format 9,999,990
column actual         heading 'Space|occupied|by data|(Kb)' format 99,999,990
column allocated      heading 'Space|Allocated|(Kb)' format 999,999,990
column rows_left      heading 'Rows for|Space|Available' format 99,999,990
column typ              noprint



define temp_file = mkdbsz7.sql

set pagesize 0
set linesize 255
set heading off
set feedback off
set verify off

set termout on
prompt
prompt Generating list of Actual Table Size and Record counts
prompt for all &app_name tables
prompt This will validate structure on indexes and analyze tables
prompt      for owner like      &owner
prompt      and table name like &prefix
prompt      &my_txt
prompt
prompt **** Please wait it may take a long time ****
prompt
select
'There are '||count(dbt.table_name)||' tables and ' buff
from all_tables dbt
where dbt.owner like upper('&owner')
  and dbt.table_name like upper('&prefix')
union
select
count(dbi.index_name)||' indexes for owner:  ''&owner'' with names like: ''&prefix''.' buff
from dba_indexes dbi
where dbi.owner like upper('&owner')
  and dbi.table_name like upper('&prefix')
order by 1 desc;
prompt
set termout off

start &tool_home/rptvars
set termout on
prompt
prompt &tab_val_txt
prompt &ind_val_txt
prompt
prompt
set termout off
create table my_index_stats(
        owner varchar2(30) not null,
        table_owner varchar2(30) not null,
        table_name varchar2(30) not null,
        index_name varchar2(30) not null,
        blocks number not null,
        height number,
        lf_rows number,
        lf_blks number,
        lf_rows_len number,
        lf_blk_len number,
        br_rows number,
        br_blks number,
        br_rows_len number,
        br_blk_len number,
        del_lf_rows number,
        del_lf_rows_len number,
        distinct_keys number,
        most_repeated_key number,
        btree_space number,
        used_space number,
        pct_used number,
        rows_per_key number,
        blks_gets_per_access number );
create unique index my_index_stats_ux1 on my_index_stats(owner, table_owner, table_name, index_name);
delete from my_index_stats
where owner like upper('&owner')
  and table_name like upper('&prefix')
  and upper('&ind_val_switch') = 'Y';
commit;

spool &temp_file
select
'set termout on' buff,
'Prompt Analyzing table:    "'||owner||'"."'||table_name||'"' buff,
'set termout off' buff,
'analyze table "'||owner||'"."'||table_name||'" compute statistics;' buff
from all_tables
where owner like upper('&owner')
and table_name like upper('&prefix')
and 'Y' = upper('&tab_val_switch')
order by owner, table_name;
select
'set termout on' buff,
'Prompt Validating index:    "'||owner||'"."'||index_name||'"' buff,
'set termout off' buff,
'analyze index "'||owner||'"."'||index_name||'" validate structure;' buff,
'insert into my_index_stats(OWNER, TABLE_OWNER, TABLE_NAME, INDEX_NAME, BLOCKS, HEIGHT, LF_ROWS, LF_BLKS, LF_ROWS_LEN, LF_BLK_LEN,' buff,
' BR_ROWS, BR_BLKS, BR_ROWS_LEN, BR_BLK_LEN, DEL_LF_ROWS, DEL_LF_ROWS_LEN, DISTINCT_KEYS, MOST_REPEATED_KEY, BTREE_SPACE,' buff,
' USED_SPACE, PCT_USED, ROWS_PER_KEY, BLKS_GETS_PER_ACCESS )' buff,
'select '''||owner||''', '''||table_owner||''','''||table_name||''','''||index_name||''', BLOCKS, HEIGHT, LF_ROWS, LF_BLKS, LF_ROWS_LEN, LF_BLK_LEN, ' buff,
' BR_ROWS, BR_BLKS, BR_ROWS_LEN, BR_BLK_LEN, DEL_LF_ROWS, DEL_LF_ROWS_LEN, DISTINCT_KEYS, MOST_REPEATED_KEY, BTREE_SPACE, ' buff,
' USED_SPACE, PCT_USED, ROWS_PER_KEY, BLKS_GETS_PER_ACCESS ' buff,
'from index_stats;' buff,
'commit;' buff
from all_indexes
where table_owner like upper('&owner')
  and table_name like upper('&prefix')
  and 'Y' = upper('&ind_val_switch')
order by table_owner, table_name, index_name;
spool off

set termout on
start &temp_file
host rm &temp_file

set termout on
prompt
prompt &load_clause
prompt
set termout off

break &break_clause

compute sum of record_data next_data allocated actual on ord_tablename
compute sum of record_data next_data allocated actual on owner
compute sum of record_data next_data allocated actual on report

rem ***** Load the regular portrait page layout formats
start &tool_home/pformat
set heading on


set termout on
prompt Calculating Actual size for Tables
set termout off
set embedded on

spool &output_file
rem *****
rem ***** Table and Index sizes based on information already collected
rem *****
select /*+ RULE */
        owner,
        owner||'.'||table_name ord_tablename,
        'Table' typ,
        table_name name,
        num_rows ,
        avg_row_len,
        (blocks)*&blocksize/1024 actual,
        (blocks+empty_blocks)*&blocksize/1024 allocated,
        next_extent/1024 next_extent,
        decode(avg_row_len, 0, 0, (empty_blocks*&blocksize)/avg_row_len) rows_left
from
      all_tables
where owner like upper('&owner')
  and table_name like upper('&prefix') &tab_where_clause
union
select /*+ RULE */
        ai.table_owner,
        ai.table_owner||'.'||ai.table_name table_name,
        'Index' typ,
        ' '||ist.index_name name,
        ist.lf_rows num_rows,
        decode(lf_rows, 0, 0, lf_rows_len/lf_rows)  avg_row_len,
        (ist.lf_blks + ist.br_blks)*&blocksize/1024 actual,
        ist.blocks*&blocksize/1024 allocated,
        ai.next_extent/1024 next_extent,
        decode((nvl(lf_rows_len,0)/decode(nvl(lf_rows,1),0,1)), 0, 0, ((ist.blocks - (ist.lf_blks + ist.br_blks))*&blocksize)/(lf_rows_len/lf_rows)) rows_left
from
        my_index_stats ist,
        all_indexes ai
where ist.table_name = ai.table_name
  and ist.table_owner = ai.table_owner
  and ist.index_name = ai.index_name
  and ist.owner = ai.owner
  and ai.table_owner like upper('&owner')
  and ai.table_name like upper('&prefix') &ind_where_clause
&order_clause
/
spool off
start &tool_home/ppcmd
exit
