REM cnt_exts.sql checked out on 17/2/00 11:15:12 version 1.01
REM ---- Enter the Owner or wildcard of the tables to match:%
define owner = '&owner'
REM ---- Enter the tablespace name or wildcard string to match:%
define tablespace = '&tabspace'
REM ---- Enter the Title for the top of the report:?
define app_name = '&rep_tit'
REM ---- Enter the table name or wildcard string to match:%
define prefix = '&tab_nam'
REM ---- Enter Over how many extents per object should be reported:2
define num_exts = '&ext_num'
REM ---- Enter the name of the Output file for the report:$report_name.lst
define output_file='&out_fil'
REM ---- Enter order by preference (1=> number of extents, 2=> pct max extents):2
define order_by = '&ord_by'
set termout off
set feedback off
rem
rem Created by Nabeel Khan
rem in 2000 For his personal use
rem
column order_prompt_txt new_value order_prompt noprint
column order_where_txt new_value order_where noprint
select
decode('&order_by', '1', 'number of extents descending', '2', 'percent to max extents descending', 
			 'percent to max extents descending') order_prompt_txt,
decode('&order_by', '1', '5 desc, 1, 2, 3, 4, 8 desc', '2','8 desc, 1, 2, 3, 4','8 desc, 1, 2, 3, 4') order_where_txt 
from dual;
ttitle left jobdate jobtime center '&app_name' right 'Page: ' format 999 sql.pno skip 1 -
center 'Number of Extents greater than &num_exts allocated to Objects for Owners like &owner and Names like &prefix'
btitle center 'Report: cnt_exts'
set termout on
set feedback on
prompt 
prompt Created by Nabeel Khan
prompt in 2000 For his personal use
prompt
prompt ******** Running  DBA Count Extents 
prompt Greater than &num_exts Report
prompt Ordered by &order_prompt
prompt
set termout off
set verify off
set feedback off
break on report on owner on tablespace_name skip 2 on segment_type skip 1 
compute sum of kbytes on report
compute sum of kbytes on tablespace_name
compute sum of kbytes on segment_name
column  tablespace_name heading 'Tablespace|Name'        format  a23
column  segment_type    heading 'Segment| Type'          format  a9      
column  owner           heading  Owner                   format  a12 
column  segment_name    heading 'Segment| NAME'          format  a30
column  exts_per_file   heading 'Extents|per file'       format  9,999
column  num_extents     heading 'Number|of extents'      format  9,999
column  max_extents     heading 'Max Extents'            format  9,999
column  reach_max       heading 'Percent of|Max Extents' format  990
spool &output_file
select 
  de.OWNER,
  de.TABLESPACE_NAME,
  de.SEGMENT_TYPE,
  de.SEGMENT_NAME,
  max(extent_id)+1 num_extents,
  dt.max_extents,
  (max(extent_id)+1)/count(distinct de.file_id) exts_per_file,
  100*((max(extent_id)+1)/dt.max_extents) reach_max
from dba_extents de,
     dba_tables dt
  where de.tablespace_name like upper('&tablespace')
    and de.segment_name = dt.table_name
    and de.owner like upper('&owner')
    and dt.table_name like upper('&prefix')
    and de.owner = dt.owner
group by de.owner, de.tablespace_name, de.segment_type, de.segment_name, dt.max_extents
having max(extent_id)+1 > &num_exts
union
select 
  de.OWNER,
  de.TABLESPACE_NAME,
  de.SEGMENT_TYPE,
  de.SEGMENT_NAME,
  max(extent_id)+1 num_extents,
  di.max_extents,
  (max(extent_id)+1)/count(distinct de.file_id) exts_per_file,
  100*((max(extent_id)+1)/di.max_extents) reach_max
from dba_extents de,
     dba_indexes di
  where de.tablespace_name like upper('&tablespace')
    and de.segment_name = di.index_name
    and de.owner like upper('&owner')
    and di.table_name like upper('&prefix')
    and de.owner = di.owner
group by de.owner, de.tablespace_name, de.segment_type, de.segment_name, di.max_extents
having max(extent_id)+1 > &num_exts
order by &order_where
;
spool off 
exit
/
