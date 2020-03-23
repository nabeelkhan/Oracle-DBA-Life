REM dbszv7.sql checked out on 10/18/97 17:05:13 version 1.12
set termout off
REM ---- Enter the Owner of the tables or wildcard to match:%
define owner = '&1'

REM ---- Enter the table name or wildcard string:%
define prefix = '&2'

REM ---- Enter Title for the top of the report:?
define app_name = '&3'

REM ---- Enter Re-count switch to count records (Y) or use previous run counts (N):y
define count_switch = '&4'

REM ---- Enter (c) to use current counts or (p) for projected counts (requires re-count = N):c
define proj_count = '&5'

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
column size_type new_value sizetype noprint
select decode('&proj_count','c','Current','C','Current','p','Projected','P','Projected') size_type
from dual;
ttitle left jobdate jobtime center '&app_name' right 'Page: ' format 999 sql.pno skip 1 -
center '&sizetype Table and Index Size for a block size of ' format 9999 blocksize ' bytes for Owner like &owner and Names like &prefix' skip 1 -
center 'Size (Kb) =  record length X number of rows / 1024  -- Sum of extents is actual size from Dictionary' skip 1 -
center 'Next Extent (Kb) =  growth_factor * record length * number of rows / 1024' skip 2

btitle center 'Report: dbszv7'

column owner noprint
column record_length    heading 'Length|(b)' format 99,999.9
column record_data    heading 'Data| (Kb)' format 9,999,999,990
column next_data    heading 'Next Extent|(Kb)' format 9,999,999,990
column tablename       heading 'Table|Name' format a27 word_wrapped
column rec_count       heading 'Number|of Rows' format 99,999,990
column typ             heading 'Type' format a5
column indexname       heading 'Index|Name' format a22
column buff fold_after 1
column actual		heading 'Sum of|Extents (Kb)' format 999,999,990



rem **** Variable dependent on ORACLE and possible versions
rem ****  all are in bytes!
define tab_fixed_header=57
define tab_variable_header=23
define tab_row_header=3
define tab_table_directory=4
define tab_row_directory=2
define ind_fixed_header=113
define ind_variable_header=23
define ind_entry_header=2
define ind_rowid_length=6

define report_nm   = 'Table Record Size Report'
define temp_file = mkdbsize.sql

set pagesize 0
set linesize 255
set heading off
set feedback off
set verify off

set termout on
prompt Generating list of Table Size and Record counts
prompt  for all &app_name tables for owner = &owner
prompt      and table name like &prefix
prompt
prompt Please wait . . . This may take sometime depending on size
prompt                   generally around 10 minutes
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
prompt Creating temporary table: TABLE_COUNTS
prompt  for record counts
prompt
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

rem *****
rem ***** delete all records from the table if it existed before
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

spool &temp_file
select
'set termout on' buff,
'Prompt Using old values in table:     '||USER||'.TABLE_COUNTS' buff
from dual
where upper('&count_switch') != 'Y';

select 
'set termout on' buff,
'Prompt Counting records for table:    "'||owner||'"."'||table_name||'"' buff,
'insert into table_counts(table_owner, table_name, rec_count, row_length, num_leq_250, num_gt_250, ' buff,
'table_bytes, table_growth, proj_count) select '''||owner||''' table_owner,' buff,
''''||table_name||''' table_name,count(rowid),0,0,0,0,10,count(rowid) from '||owner||'.'||table_name||';' buff,
'commit;' buff,
'update table_counts set table_bytes = (select sum(bytes)' buff,
'                                      from dba_extents' buff,
'                                      where segment_name = '''||table_name||''' and owner = '''||owner||'''' buff,
'                                        and segment_type = ''TABLE'')' buff,
'where table_name = '''||table_name||'''' buff,
'  and table_owner = '''||owner||''';' buff,
'update table_counts set num_leq_250 = (select count(a.column_name)' buff,
'                                      from dba_tab_columns a' buff,
'                                      where a.data_length <= 250' buff,
'                                        and table_name = '''||table_name||''' and owner = '''||owner||''')' buff,
'where table_name = '''||table_name||'''' buff,
'  and table_owner = '''||owner||''';' buff,
'update table_counts set num_gt_250 = (select count(a.column_name)' buff,
'                                      from dba_tab_columns a' buff,
'                                      where a.data_length > 250' buff,
'                                        and table_name = '''||table_name||''' and owner = '''||owner||''')' buff,
'where table_name = '''||table_name||'''' buff,
'  and table_owner = '''||owner||''';' buff,
'update table_counts set row_length = (select sum(to_number(decode(c.data_type,''NUMBER'',floor(NVL(c.data_precision,0)/2)+3,''DATE'',7,''LONG'',2049,c.data_length)))' buff,
'                                     from dba_tab_columns c' buff,
'                                     where table_name = '''||table_name||''' and owner = '''||owner||''')' buff,
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
'insert into table_counts(table_owner, table_name, rec_count, row_length, num_leq_250, num_gt_250, ' buff,
'table_bytes, table_growth, proj_count) select '''||owner||''' table_owner,' buff,
 ''''||index_name||''' table_name,0,0,0,0,sum(bytes),0,0' buff,
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
prompt
prompt Running script to count records for table: TABLE_COUNTS
prompt  this may take several minutes depending on
prompt  size of tables.
prompt
start &temp_file
host rm &temp_file

set termout on
prompt
prompt Temporary tables created and loaded
prompt
set termout off


break on report on owner skip 3 on tablename skip 2 on rec_count

compute sum of record_data next_data actual on tablename
compute sum of record_data next_data actual on owner
compute sum of record_data next_data actual on report

rem ***** Load the regular portrait page layout formats
start &tool_home/pformat
set heading on


set termout on
prompt Calculating &sizetype Database size for Tables and Indexes
set termout off
set embedded on

spool &output_file
rem *****
rem ***** Table and Index sizes based on information already collected
rem *****
select   tc.table_owner owner, tc.table_owner||'.'||tc.TABLE_NAME tablename, 
	 decode('&count_switch','y',rec_count,'Y',rec_count, decode('&proj_count','c',tc.rec_count,'C',tc.rec_count,
									    'p',tc.proj_count,'P',tc.proj_count,
									    tc.rec_count)) rec_count, 
	'Table' typ, '' indexname,
         tc.row_length record_length,
         greatest( round( &blocksize/1024 * 
	 decode('&count_switch','y',tc.rec_count,'Y',tc.rec_count,
	   decode('&proj_count','c',tc.rec_count,'C',tc.rec_count,'p',tc.proj_count,'P',tc.proj_count,tc.rec_count)) * 
	 (&tab_row_header + (1 * num_leq_250) + (3 * num_gt_250) + row_length +
	 + (&tab_row_directory))/((&blocksize - &tab_fixed_header -
          (&tab_variable_header * INI_TRANS) - &tab_table_directory ) - ((&blocksize -  &tab_fixed_header - (&tab_variable_header * INI_TRANS)) * PCT_FREE/100))),2*&blocksize/1024)
record_data,
         greatest( round( &blocksize/1024 * 
	 decode('&count_switch','y',tc.rec_count,'Y',tc.rec_count,
	   decode('&proj_count','c',tc.rec_count,'C',tc.rec_count,'p',tc.proj_count,'P',tc.proj_count,tc.rec_count)) * 
	 (tc.table_growth/100) * (&tab_row_header + (1 * num_leq_250) + (3 * num_gt_250) + row_length + (&tab_row_directory))/((&blocksize - &tab_fixed_header -
          (&tab_variable_header * INI_TRANS) - &tab_table_directory ) - ((&blocksize -  &tab_fixed_header - (&tab_variable_header * INI_TRANS)) * PCT_FREE/100))),2*&blocksize/1024)
         next_data,
        table_bytes/1024 actual
from 
      table_counts tc,
      all_tables dt
where tc.table_owner like upper('&owner')
  and dt.owner = tc.table_owner
  and tc.table_name like upper('&prefix')
  and dt.table_name = tc.table_name
union
select tct.table_owner owner, tct.table_owner||'.'||tct.table_name tablename, 
       decode('&count_switch','y',tct.rec_count,'Y',tct.rec_count, 
	 decode('&proj_count','c',tct.rec_count,'C',tct.rec_count,'p',tct.proj_count,'P',tct.proj_count,tct.rec_count)) rec_count, 
       'Index' typ, tci.table_name indexname,
       tci.row_length record_length,
       greatest( round( &blocksize/1024 * 1.05 * 
       decode('&count_switch','y',tct.rec_count,'Y',tct.rec_count, 
	 decode('&proj_count','c',tct.rec_count,'C',tct.rec_count,'p',tct.proj_count,'P',tct.proj_count,tct.rec_count)) * 
       (&ind_entry_header + &ind_rowid_length + (1 * tci.num_leq_250) + (3 * tci.num_gt_250) + tci.row_length+ decode(dbi.UNIQUENESS,'NONUNIQUE',&ind_rowid_length,0) )/
                   (floor((&blocksize - &ind_fixed_header - (&ind_variable_header * INI_TRANS))/(&ind_entry_header + &ind_rowid_length + (1 *
                   tci.num_leq_250) + (3 * tci.num_gt_250) + tci.row_length+ decode(dbi.UNIQUENESS,'NONUNIQUE',&ind_rowid_length,0) )) * (&ind_entry_header + &ind_rowid_length + (1 * tci.num_leq_250) + (3
                   * tci.num_gt_250) + tci.row_length+ decode(dbi.UNIQUENESS,'NONUNIQUE',&ind_rowid_length,0) ))),2*&blocksize/1024) record_data,
       greatest( round( &blocksize/1024 * 1.05 * 
       decode('&count_switch','y',tct.rec_count,'Y',tct.rec_count, 
	 decode('&proj_count','c',tct.rec_count,'C',tct.rec_count,'p',tct.proj_count,'P',tct.proj_count,tct.rec_count)) *
       (tci.table_growth/100) * (&ind_entry_header + &ind_rowid_length + (1 * tci.num_leq_250) + (3 * tci.num_gt_250) + tci.row_length+ decode(dbi.UNIQUENESS,'NONUNIQUE',&ind_rowid_length,0) )/
                   (floor((&blocksize - &ind_fixed_header - (&ind_variable_header * INI_TRANS))/(&ind_entry_header + &ind_rowid_length + (1 *
                   tci.num_leq_250) + (3 * tci.num_gt_250) + tci.row_length+ decode(dbi.UNIQUENESS,'NONUNIQUE',&ind_rowid_length,0) )) * (&ind_entry_header + &ind_rowid_length + (1 * tci.num_leq_250) + (3
                   * tci.num_gt_250) + tci.row_length+ decode(dbi.UNIQUENESS,'NONUNIQUE',&ind_rowid_length,0) ))),2*&blocksize/1024) next_data,
       tci.table_bytes/1024 actual
from 
     table_counts tci,
     table_counts tct,
     dba_indexes dbi
where tct.table_owner like upper('&owner')
  and tct.table_name like upper('&prefix')
  and dbi.table_name = tct.table_name
  and dbi.index_name = tci.table_name
  and tci.table_owner = tct.table_owner
order by 1,2,4 desc
/
set heading off
column my_label format a70
column ratio format 99,999.99
select  'Ratio of allocated size to calculated size for tables:' my_label,
	(sum(table_bytes)/1024)/sum(greatest( round( &blocksize/1024 * tc.rec_count * 
	 (&tab_row_header + (1 * num_leq_250) + (3 * num_gt_250) + row_length +
	 + (&tab_row_directory))/((&blocksize - &tab_fixed_header -
          (&tab_variable_header * INI_TRANS) - &tab_table_directory ) - ((&blocksize -  &tab_fixed_header - (&tab_variable_header * INI_TRANS)) * PCT_FREE/100))),2*&blocksize/1024)) ratio
from 
      table_counts tc,
      all_tables dt
where tc.table_owner like upper('&owner')
  and dt.owner = tc.table_owner
  and tc.table_name like upper('&prefix')
  and dt.table_name = tc.table_name
group by 'Ratio of allocated size to calculated size for tables:'
union
select 'Ratio of allocated size to calculated size for indexes:' my_label,
       (sum(tci.table_bytes)/1024)/sum(greatest( round( &blocksize/1024 * 1.05 * tct.rec_count * 
       (&ind_entry_header + &ind_rowid_length + (1 * tci.num_leq_250) + (3 * tci.num_gt_250) + tci.row_length+ decode(dbi.UNIQUENESS,'NONUNIQUE',&ind_rowid_length,0) )/
                   (floor((&blocksize - &ind_fixed_header - (&ind_variable_header * INI_TRANS))/(&ind_entry_header + &ind_rowid_length + (1 *
                   tci.num_leq_250) + (3 * tci.num_gt_250) + tci.row_length+ decode(dbi.UNIQUENESS,'NONUNIQUE',&ind_rowid_length,0) )) * (&ind_entry_header + &ind_rowid_length + (1 * tci.num_leq_250) + (3
                   * tci.num_gt_250) + tci.row_length+ decode(dbi.UNIQUENESS,'NONUNIQUE',&ind_rowid_length,0) ))),2*&blocksize/1024))  ratio
from 
     table_counts tci,
     table_counts tct,
     dba_indexes dbi
where tct.table_owner like upper('&owner')
  and tct.table_name like upper('&prefix')
  and dbi.table_name = tct.table_name
  and dbi.index_name = tci.table_name
  and tci.table_owner = tct.table_owner
group by 'Ratio of allocated size to calculated size for indexes:'
;
spool off
start &tool_home/ppcmd
exit
