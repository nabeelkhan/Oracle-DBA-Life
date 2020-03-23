REM dbblocks.sql checked out on 10/18/97 17:05:18 version 1.5
set termout off
REM ---- Enter the Owner of the tables or wildcard to match:%
define owner = '&1'

REM ---- Enter the table name or wildcard string:%
define prefix = '&2'

REM ---- Enter Title for the top of the report:?
define app_name = '&3'

REM ---- Enter Re-count switch to count records (Y) or use previous run counts (N):y
define count_switch = '&4'

REM ---- Enter the amount of rows for space available to report on (enter 0 for all tables):0
define min_rows = &5

REM ---- Enter the Output file name for the report:$report_name.lst
define output_file='&6'

REM ---- Var &7 not used

REM ----- Home for the utils
define tool_home='/home/marcm/dba_rpt'

rem
rem Created by Marc E. Marchioli
rem in 1996 For his personal use
rem Copyright 1996 The DataBase Group, Inc.
rem
start &tool_home/pformat
start &tool_home/rptvars
column tab_where_txt new_value tab_where_clause noprint
column ind_where_txt new_value ind_where_clause noprint
column my_txt new_value my_prompt noprint
column order_txt new_value order_clause noprint
column break_txt new_value break_clause noprint
column count_txt new_value count_clause noprint
column load_txt new_value load_clause noprint

select decode(&min_rows, 0, ' ',
'and (table_bytes-(tc.blocks*&blocksize))/(tc.blocks*&blocksize/rec_count) < &min_rows and (rec_count != 0 and tc.blocks is not null and tc.blocks != 0)') tab_where_txt,
       decode(&min_rows, 0, ' ',
'and (tci.table_bytes - (tci.blocks*&blocksize))/(tci.blocks*&blocksize/tct.rec_count) < &min_rows and (tct.rec_count != 0 and tci.blocks is not null and tci.blocks != 0)') ind_where_txt,
decode(&min_rows, 0, ' ', 'and number of rows in space available < &min_rows') my_txt,
decode(&min_rows, 0, 'order by 1,2,3 desc', 'order by 10, 1, 2, 3 desc') order_txt,
decode(&min_rows, 0, 'on report on owner skip 3 on ord_tablename skip 2 on rec_count','on report') break_txt,
decode(upper('&count_switch'), 'Y','Counting records to load table:  '||USER||'.TABLE_COUNTS',
				  'Using old values in table: '||USER||'.TABLE_COUNTS') count_txt,
decode(upper('&count_switch'), 'Y','Temporary tables created and loaded',
				  ' ') load_txt
from dual;

ttitle left jobdate jobtime center '&app_name' right 'Page: ' format 999 sql.pno skip 1 -
center 'Table and Index Size for a block size of ' format 9999 blocksize ' bytes for Owner like &owner and Names like &prefix' skip 1 -
center 'Data (Kb) =  database blocks  X blocksize  -- Sum of extents is allocated size from Dictionary' skip 1 -
center 'Blocks are the actual blocks occupied by data in the table' skip 2

btitle center 'Report: dbblocks'

column owner noprint
column avg_record_length    heading 'Average|Row|Length|(b)' format 9,999
column record_data    heading 'Estimated|Data|Size|(Kb)' format 99,999,990
column next_extent    heading 'Next|Extent|(Kb)' format 9,999,990
column tablename      heading 'Object Name' format a38 word_wrapped
column ord_tablename  noprint
column ord_ind        noprint
column rec_count       heading 'Number|of Rows' format 99,999,990
column typ             heading 'T' format a1
column indexname       heading 'Index Name' format a22
column buff fold_after 1
column allocated	heading 'Sum of|Extents (Kb)' format 999,999,990
column rows_left       heading 'Rows for|Space|Available' format 99,999,990
column actual		heading 'Blocks|Allocated|(Kb)' format 99,999,990



define report_nm   = 'Table Record Size Report'
define temp_file = mkdbblks.sql

set pagesize 0
set linesize 255
set heading off
set feedback off
set verify off

set termout on
prompt Generating list of Actual Table Size and Record counts
prompt for all &app_name tables
prompt **** Please wait it may take a long time **** 
prompt This will do a full table scan on all tables 
prompt      for owner like      &owner
prompt      and table name like &prefix
prompt      &my_prompt
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
prompt &count_clause
set termout off

create table table_counts(table_owner varchar2(30) not null,
                          table_name varchar2(30) not null,
			  rec_count  number not null,
			  row_length number not null,
			  num_leq_250 number not null,
			  num_gt_250 number not null,
			  table_bytes number,
			  table_growth number(2,0),
			  proj_count number,
			  blocks number);
create unique index table_counts_prim on table_counts(table_owner,table_name);
rem
rem In case this is an old table add the required column
rem must also make sure that dbszv7 has enough values or uses the table(column1, column2, ...) form
rem
alter table table_counts add (blocks number);

rem *****
rem ***** delete all records matching the criteria
rem ***** from the table if they existed before this run
rem *****
delete /*+ RULE */
from table_counts tc
where table_owner like upper('&owner')
  and table_name in  (select table_name
		      from all_tables at
		      where at.owner = tc.table_owner
		        and at.table_name like upper('&prefix')
		      union
		      select index_name
		      from all_indexes ai
		      where ai.table_owner like upper('&owner')
		        and ai.table_name like upper('&prefix')
		      )
and 'Y' = upper('&count_switch');
commit;
set termout off
spool &temp_file
select
'Prompt Counting records for table:    "'||owner||'"."'||table_name||'"' buff,
'insert into table_counts(TABLE_OWNER, TABLE_NAME, REC_COUNT, ROW_LENGTH, NUM_LEQ_250, NUM_GT_250, TABLE_BYTES,' buff,
'TABLE_GROWTH, PROJ_COUNT) select '''||owner||''', ' buff,
''''||table_name||''', count(rowid),0,0,0,0,10,count(rowid) from '||owner||'.'||table_name||';' buff,
'commit;' buff,
'update table_counts set table_bytes = (select sum(bytes)' buff,
'                                      from dba_extents' buff,
'                                      where segment_name = '''||table_name||''' and owner = '''||owner||'''' buff,
'                                        and segment_type = ''TABLE'')' buff,
'where table_name = '''||table_name||'''' buff,
'  and table_owner = '''||owner||''';' buff,
'update table_counts set row_length = (select sum(to_number(decode(c.data_type,''NUMBER'',floor(NVL(c.data_precision,0)/2)+3,''DATE'',7,''LONG'',2049,c.data_length)))' buff,
'                                     from dba_tab_columns c' buff,
'                                     where table_name = '''||table_name||''' and owner = '''||owner||''')' buff,
'where table_name = '''||table_name||'''' buff,
'  and table_owner = '''||owner||''';' buff,
'Prompt Counting blocks allocated for table:    "'||owner||'"."'||table_name||'"' buff,
'update table_counts set blocks = ( select count(distinct substr(rowid,0,8)||substr(rowid,15,4))' buff,
'                                   from '||owner||'.'||table_name||')' buff,
'where table_name = '''||table_name||'''' buff,
'  and table_owner = '''||owner||''';' buff,
'commit;' buff
from all_tables
where owner like upper('&owner')
and table_name like upper('&prefix')
and table_name != '%DUMMY%'
and 'Y' = upper('&count_switch')
order by owner,table_name;
select 
'Prompt Computing  data for indexes:    "'||owner||'"."'||table_name||'"."'||index_name||'"' buff,
'insert into table_counts(TABLE_OWNER, TABLE_NAME, REC_COUNT, ROW_LENGTH, NUM_LEQ_250, NUM_GT_250, TABLE_BYTES,' buff,
'TABLE_GROWTH, PROJ_COUNT) select '''||owner||''', ' buff,
 ''''||index_name||''', 0,0,0,0,sum(bytes),0,0' buff,
 'from dba_extents' buff,
 'where segment_name = '''||index_name||''' and owner = '''||owner||'''' buff,
 'and segment_type = ''INDEX'';' buff,
'commit;' buff,
'update table_counts set num_leq_250 = (select count(a.column_name)' buff,
'                                      from dba_ind_columns a' buff,
'                                      where a.column_length <= 128' buff,
'                                        and index_name = '''||index_name||''' and table_owner = '''||owner||''')' buff,
'where table_name = '''||index_name||'''' buff,
'  and table_owner = '''||table_owner||''';' buff,
'update table_counts set num_gt_250 = (select count(a.column_name)' buff,
'                                      from dba_ind_columns a' buff,
'                                      where a.column_length > 128' buff,
'                                        and index_name = '''||index_name||''' and table_owner = '''||owner||''')' buff,
'where table_name = '''||index_name||'''' buff,
'  and table_owner = '''||table_owner||''';' buff,
'update table_counts set row_length = (select sum(to_number(decode(c.data_type,''NUMBER'',floor(NVL(c.data_precision,0)/2)+3,''DATE'',7,''LONG'',2049,c.data_length)))' buff,
'                                     from dba_tab_columns c, dba_ind_columns di' buff,
'                                     where c.table_name = '''||table_name||''' and c.owner = '''||owner||'''' buff,
'                                       and di.index_name = '''||index_name||''' and di.index_owner = '''||owner||'''' buff,
'                                       and di.table_name = c.table_name' buff,
'                                       and di.column_name = c.column_name)' buff,
'where table_name = '''||index_name||'''' buff,
'  and table_owner = '''||table_owner||''';' buff,
'update table_counts set rec_count = (select count(*)' buff,
'                                     from dba_tab_columns c, dba_ind_columns di' buff,
'                                     where c.table_name = '''||table_name||''' and c.owner = '''||owner||'''' buff,
'                                       and di.index_name = '''||index_name||''' and di.index_owner = '''||owner||'''' buff,
'                                       and di.table_name = c.table_name' buff,
'                                       and di.column_name = c.column_name' buff,
'                                       and c.nullable = ''N'')' buff,
'where table_name = '''||index_name||'''' buff,
'  and table_owner = '''||table_owner||''';' buff,
 'commit;' buff
from dba_indexes
where owner like upper('&owner')
 and table_name like upper('&prefix')
 and table_name != '%DUMMY%'
 and table_type = 'TABLE'
 and 'Y' = upper('&count_switch')
order by owner,table_name
/
spool off

termout on
start &temp_file
host rm &temp_file

set termout on
prompt &load_clause
set termout off

break &break_clause

compute sum of record_data next_data allocated actual on ord_tablename
compute sum of record_data next_data allocated actual on owner
compute sum of record_data next_data allocated actual on report

rem ***** Load the regular portrait page layout formats
start &tool_home/pformat
set heading on


set termout on
prompt Calculating Actual size for Tables and Indexes
set termout off
set embedded on

spool &output_file
rem *****
rem ***** Table and Index sizes based on information already collected
rem *****
select /*+ RULE */
	tc.table_owner owner, tc.table_owner||'.'||tc.TABLE_NAME ord_tablename, 'T' ord_ind,
                               tc.table_owner||'.'||tc.TABLE_NAME tablename, 
	 tc.rec_count rec_count, 
         decode(rec_count,0,0,tc.blocks*&blocksize/rec_count) avg_record_length,
         greatest( round( &blocksize/1024 * tc.rec_count * 
	 (&tab_row_header + (1 * num_leq_250) + (3 * num_gt_250) + row_length +
	 + (&tab_row_directory))/((&blocksize - &tab_fixed_header -
          (&tab_variable_header * INI_TRANS) - &tab_table_directory ) - ((&blocksize -  &tab_fixed_header - (&tab_variable_header * INI_TRANS)) * PCT_FREE/100))),2*&blocksize/1024)
record_data,
        table_bytes/1024 allocated,
	tc.blocks*&blocksize/1024 actual,
	dt.next_extent/1024 next_extent,
	decode(rec_count,0,0,(table_bytes-(tc.blocks*&blocksize))/(tc.blocks*&blocksize/rec_count)) rows_left
from 
      all_tables dt,
      table_counts tc
where tc.table_owner like upper('&owner')
  and dt.owner = tc.table_owner
  and tc.table_name like upper('&prefix')
  and dt.table_name = tc.table_name &tab_where_clause
union
select /*+ RULE */
	tct.table_owner owner, tct.table_owner||'.'||tct.table_name ord_tablename, 'I' ord_ind,
       'Index - '||tci.table_name table_name,
	 tct.rec_count rec_count, 
       decode(tct.rec_count, 0 , 0, tci.blocks*&blocksize/tct.rec_count) avg_record_length,
       greatest( round( &blocksize/1024 * 1.05 * tct.rec_count * 
       (&ind_entry_header + &ind_rowid_length + (1 * tci.num_leq_250) + (3 * tci.num_gt_250) + tci.row_length+ decode(dbi.UNIQUENESS,'NONUNIQUE',&ind_rowid_length,0) )/
                   (floor((&blocksize - &ind_fixed_header - (&ind_variable_header * INI_TRANS))/(&ind_entry_header + &ind_rowid_length + (1 *
                   tci.num_leq_250) + (3 * tci.num_gt_250) + tci.row_length+ decode(dbi.UNIQUENESS,'NONUNIQUE',&ind_rowid_length,0) )) * (&ind_entry_header + &ind_rowid_length + (1 * tci.num_leq_250) + (3
                   * tci.num_gt_250) + tci.row_length+ decode(dbi.UNIQUENESS,'NONUNIQUE',&ind_rowid_length,0) ))),2*&blocksize/1024) record_data,
       tci.table_bytes/1024 allocated,
       tci.blocks*&blocksize/1024 actual,
       dbi.next_extent/1024 next_extent,
       decode(tct.rec_count, 0, 0, (tci.table_bytes - (tci.blocks*&blocksize))/(tci.blocks*&blocksize/tct.rec_count)) rows_left
from 
     dba_indexes dbi,
     table_counts tci,
     table_counts tct
where tct.table_owner like upper('&owner')
  and tct.table_name like upper('&prefix')
  and dbi.table_name = tct.table_name
  and dbi.index_name = tci.table_name
  and tci.table_owner = tct.table_owner &ind_where_clause
&order_clause
/
spool off
start &tool_home/ppcmd
exit
