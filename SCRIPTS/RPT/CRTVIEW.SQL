REM crtview.sql checked out on 3/27/96 17:05:12 version 1.3
set heading off
set verify off
set embedded on
set feedback off
set echo off
set pagesize 0
set arraysize 2
set space 0
set define '^'
column max_column_id new_value max_id noprint;
column sum_bytes new_value tot_bytes noprint;

select max(column_id) max_column_id
from all_tab_columns
where table_name = upper('^2')
and   owner = upper('^1');


set termout on
prompt REM Generating create SQL for: ^1..^2 
set termout off

select 
'CREATE OR REPLACE VIEW "'||upper('^1')||'"."'||upper('^2')||'"('
 from dual;
select
'       '||rpad('"'||column_name||'"',35,' ')||decode(column_id,^max_id,') AS',',')
from all_tab_columns
where table_name = upper('^2')
and   owner = upper('^1')
order by column_id;

select
text
from all_views
where view_name = upper('^2')
and   owner = upper('^1');
select ';'
from dual;
