REM modobj.sql checked out on 12/22/97 17:05:21 version 1.2
set termout off
set verify off
REM ---- Enter the owner of the table/index or wildcard to match:%
define owner = '&1'
 
REM ---- Enter the table/index name or wildcard to match:%
define obj_name = '&2'
 
REM ---- Enter the application name for the script:?
define app_name = '&3'
 
REM ---- Enter the tablespace name the table/index resides in or wildcard to match:%
define tbsp_name = '&4'
 
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

set termout on
prompt
prompt ******** Modifying Table/Index to have next extent
prompt      equal to largest contiguous free space 
prompt      for &app_name 
prompt      for owner name like &owner
prompt      and Table/Index name like &obj_name
prompt      and Tablespace Name like &tbsp_name
prompt
set termout off

column kb new_value kb noprint
column object_type new_value object_type noprint
column query_table new_value query_table noprint
column col_name new_value col_name  noprint
column initial_extent new_value initial_extent  noprint
column next_extent new_value next_extent  noprint
column pct_increase new_value pct_increase noprint
column tablespace_name new_value tablespace_name  noprint

REM Get the segment size for the command string
select max(bytes)/1024 kb
from dba_free_space 
where tablespace_name in (select tablespace_name 
			  from all_tables 
			  where owner like upper('&owner') 
			   and table_name like upper('&obj_name')
                           and tablespace_name like upper('&tbsp_name')
			 union
			  select tablespace_name 
			  from all_indexes 
			  where owner like upper('&owner') 
			    and index_name like upper('&obj_name')
	                    and tablespace_name like upper('&tbsp_name'))
;

REM Get the object type for the command string
select object_type , decode(object_type, 'TABLE','all_tables','INDEX','all_indexes') query_table,
decode(object_type, 'TABLE', 'table_name', 'INDEX', 'index_name') col_name
from all_objects
where owner like upper('&owner')
  and object_name like upper('&obj_name');

select initial_extent/1024 initial_extent, next_extent/1024 next_extent, pct_increase, tablespace_name
from &query_table
where owner like upper('&owner')
  and &col_name like upper('&obj_name')
	and tablespace_name like upper('&tbsp_name');

spool &output_file
set termout on
prompt 
prompt Altering  &object_type &owner..&obj_name to have next extent of size &kb K 
prompt
prompt Old Storage ( Initial &initial_extent K
prompt .             Next    &next_extent K
prompt .             Pctincrease &pct_increase
prompt .           )
prompt Tablespace &tablespace_name
prompt
prompt New Storage ( Initial &initial_extent K
prompt .             Next    &kb K
prompt .             Pctincrease &pct_increase
prompt .           )
prompt Tablespace &tablespace_name
prompt

set verify on
alter &object_type &owner..&obj_name storage( next &kb K);
spool off
start &tool_home/ppcmd
exit
