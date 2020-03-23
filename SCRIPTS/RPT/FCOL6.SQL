REM fcol6.sql checked out on 3/27/96 17:05:11 version 1.3
set verify off
rem break on table_name skip 1
column tab_name heading 'Occurs in Table' format a30
column col_name heading 'Column Name' format a30 word_wrapped

select dtc1.owner||'.'||dtc1.table_name tab_name, 
dtc1.column_name||', '||dtc2.column_name||', '||dtc3.column_name||', '||dtc4.column_name||', '||dtc5.column_name||', '||dtc6.column_name col_name
from all_tab_columns dtc1,
     all_tab_columns dtc2,
     all_tab_columns dtc3,
     all_tab_columns dtc4,
     all_tab_columns dtc5,
     all_tab_columns dtc6
where dtc1.column_name like upper('%&1%')
  and dtc2.column_name like upper('%&2%')
  and dtc3.column_name like upper('%&3%')
  and dtc4.column_name like upper('%&4%')
  and dtc5.column_name like upper('%&5%')
  and dtc6.column_name like upper('%&6%')
  and dtc1.table_name = dtc2.table_name
  and dtc1.owner = dtc2.owner
  and dtc1.table_name = dtc3.table_name
  and dtc1.owner = dtc3.owner
  and dtc1.table_name = dtc4.table_name
  and dtc1.owner = dtc4.owner
  and dtc1.table_name = dtc5.table_name
  and dtc1.owner = dtc5.owner
  and dtc1.table_name = dtc6.table_name
  and dtc1.owner = dtc6.owner
order by 1; 
exit
