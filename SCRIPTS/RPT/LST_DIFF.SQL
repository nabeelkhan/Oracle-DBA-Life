REM lst_diff.sql checked out on 8/27/97 17:05:17 version 1.9
set termout off
REM ---- Enter the Reference Owner of the tables (wildcards not accepted):?
define ref_owner = '&1'

REM ---- Enter the reference database name (include '@' for link name e.g. @PROD ):@PROD
define ref_db = '&2'

REM ---- Enter the Title for the top of the report:?
define app_name = '&3'

REM ---- Enter Other Owner to compare with (wildcards not accepted):?
define oth_owner = '&4'

REM ---- Enter the other database name (include '@' for link name e.g. @TEST ):@TEST
define oth_db = '&5'

REM ---- Enter the Output file name for the report:$report_name.lst
define output_file='&6'

REM ---- Enter the Object Name criteria (applies to all objects) - (quotes on UNIX => \"in ('EMP','DEPT')\" , \"like 'PM%'\"):"like '%'"
define clause="&7"

REM ----- Home for the utils
define tool_home='/home/marcm/dba_rpt'

rem
rem Created by Marc E. Marchioli
rem in 1996 For his personal use
rem from a procedure developed by Randy Lewis
rem
start &tool_home/pformat
start &tool_home/rptvars

set feedback off
set verify off
set heading off

column buff fold_after 1

set termout on
prompt
prompt ******** Running DBA List Object Difference Report
prompt for Reference owner:      &ref_owner at &ref_db
prompt and Other owner:          &oth_owner at &oth_db
prompt and object name           &clause
select
'There are '||count(dbv.object_name)||' objects at &ref_db' buff,
'for owner:  ''&ref_owner'''
from all_objects&ref_db dbv
where dbv.owner like upper('&ref_owner')
  and dbv.object_name &clause
union
select
'There are '||count(dbo.object_name)||' objects at &oth_db' buff,
'for owner:  ''&oth_owner'''
from all_objects&oth_db dbo
where dbo.owner like upper('&oth_owner')
  and dbo.object_name &clause
;
prompt 
set termout off
set heading on

column ord noprint
column action heading 'Action' format a55
column table_name heading 'Object' format a60
column index_name heading 'Index' format a29
column column_name heading Column format a29
column length heading Type format a14
column nulls heading Null? format a9
column db_link heading 'DB Link' format a15
column synonym_name heading 'Synonym Owner.Name' format a25
break on ord skip 3 on action skip 2 
ttitle left jobdate jobtime center '&app_name' right 'Page: ' format 999 sql.pno skip 1 -
center 'Show difference between Table, Column, View, Sequence, Trigger definitions ' skip 1 -
center 'at &ref_db for Owner &ref_owner and &oth_owner at &oth_db with  Object names &clause' skip 2

btitle center 'Report: lst_diff'

spool &output_file
select  1 ord, 'Add Table to &ref_db' action, a.object_name table_name
from
	all_objects&oth_db a
where
	   a.object_name &clause
       and a.object_type = 'TABLE'
       and a.owner = upper('&oth_owner')
       and not exists
           (select  1
              from  all_objects&ref_db b
              where b.object_name = a.object_name
                and b.object_type = 'TABLE'
                and b.owner = upper('&ref_owner')
	   )
union
select  2 ord, 'Delete Table from &ref_db' action, a.object_name table_name
from
	all_objects&ref_db a
where
	a.object_name &clause
       and a.object_type = 'TABLE'
       and a.owner = upper('&ref_owner')
       and not exists
           (select  1
              from  all_objects&oth_db b
              where b.object_name = a.object_name
                and b.object_type = 'TABLE'
                and b.owner = upper('&oth_owner')
	    )
union
select  3 ord, 'Add View to &ref_db' action, a.view_name table_name
from
	all_views&oth_db a
where
	a.view_name &clause
       and a.owner = upper('&oth_owner')
       and not exists
           (select  1
              from  all_views&ref_db b
              where b.view_name = a.view_name
                and b.owner = upper('&ref_owner')
	    )
union
select  4 ord, 'Delete View from &ref_db' action, a.view_name table_name
from
	all_views&ref_db a
where
	a.view_name &clause
       and a.owner = upper('&ref_owner')
       and not exists
           (select  1
              from  all_views&oth_db b
              where b.view_name = a.view_name
                and b.owner = upper('&ref_owner')
	    )
union
select  5 ord, 'Changed View from &ref_db at &oth_db' action, a.view_name table_name
from
	all_views&ref_db a
where
	a.view_name &clause
       and a.owner = upper('&ref_owner')
       and exists
           (select  1
              from  all_views&oth_db b
              where b.view_name = a.view_name
                and b.owner = upper('&oth_owner')
		and b.text_length <> a.text_length
	    )
union
select  6 ord, 'Add Sequence to &ref_db' action, a.sequence_name table_name
from
	all_sequences&oth_db a
where
	a.sequence_name &clause
       and a.sequence_owner = upper('&oth_owner')
       and not exists
           (select  1
              from  all_sequences&ref_db b
              where b.sequence_name = a.sequence_name
                and b.sequence_owner = upper('&ref_owner')
	    )
union
select  7 ord, 'Delete Sequence from &ref_db' action, a.sequence_name table_name
from
	all_sequences&ref_db a
where
	a.sequence_name &clause
       and a.sequence_owner = upper('&ref_owner')
       and not exists
           (select  1
              from  all_sequences&oth_db b
              where b.sequence_name = a.sequence_name
                and b.sequence_owner = upper('&oth_owner')
	    )
union
select  8 ord, 'Modified Sequence in &oth_db from &ref_db' action, a.sequence_name table_name
from
	all_sequences&ref_db a
where
	a.sequence_name &clause
       and a.sequence_owner = upper('&ref_owner')
       and exists
           (select  1
              from  all_sequences&oth_db b
              where b.sequence_name = a.sequence_name
                and b.sequence_owner = upper('&oth_owner')
		and (
		     nvl(b.min_value,9) <> nvl(a.min_value,8)
		  or nvl(b.max_value,9) <> nvl(a.max_value,8)
		  or b.increment_by <> a.increment_by
		  or nvl(b.cycle_flag,'Y') <> nvl(a.cycle_flag,'N')
		  or nvl(b.order_flag,'Y') <> nvl(a.order_flag,'N')
		  or b.cache_size <> a.cache_size
		     )
	    )
order by 1,2,3;
set embedded on
select  1 ord, 'Add Procedure to &ref_db' action, a.name table_name
from
	all_source&oth_db a
where
	a.name &clause
       and a.type in ('FUNCTION','PACKAGE','PACKAGE BODY','PROCEDURE')
       and a.owner = upper('&oth_owner')
       and not exists
           (select  1
              from  all_source&ref_db b
              where b.name = a.name
		and b.type = a.type
		and b.owner = upper('&ref_owner')
	    )
union
select  2 ord, 'Delete Procedure in &ref_db' action, a.name table_name
from
	all_source&ref_db a
where
	a.name &clause
       and a.type in ('FUNCTION','PACKAGE','PACKAGE BODY','PROCEDURE')
       and a.owner = upper('&ref_owner')
       and not exists
           (select  1
              from  all_source&oth_db b
              where b.name = a.name
		and b.type = a.type
		and b.owner = upper('&oth_owner')
	    )
union
select  distinct 3 ord, 'Procedure in &oth_db and &ref_db differ' action, a.name table_name
from
        all_source&oth_db a
where
        a.name &clause
       and a.type in ('FUNCTION','PACKAGE','PACKAGE BODY','PROCEDURE')
       and a.owner = upper('&oth_owner')
       and exists
           (select  1
              from  all_source&ref_db b
              where b.name = a.name
                and b.type = a.type
                and b.line (+) = a.line
                and b.owner = upper('&ref_owner')
                and nvl(b.text,'Y') <> nvl(a.text,'N')
            )
order by 1,2,3;
select  1 ord, 'Add Trigger to &ref_db' action, a.trigger_name table_name
from
	all_triggers&oth_db a
where
	a.trigger_name like '%'
       and a.owner = upper('&oth_owner')
       and not exists
           (select  1
              from  all_triggers&ref_db b
              where b.trigger_name = a.trigger_name
		and b.trigger_type = a.trigger_type
		and b.owner = upper('&ref_owner')
	    )
union
select  2 ord, 'Delete Trigger in &ref_db' action, a.trigger_name table_name
from
	all_triggers&ref_db a
where
	a.trigger_name like '%'
       and a.owner = upper('&ref_owner')
       and not exists
           (select  1
              from  all_triggers&oth_db b
              where b.trigger_name = a.trigger_name
		and b.trigger_type = a.trigger_type
		and b.owner = upper('&oth_owner')
	    )
union
select  3 ord, 'Trigger in &oth_db and &ref_db differ' action, a.trigger_name table_name
from
        all_triggers&oth_db a
where
        a.trigger_name like '%'
       and a.owner = upper('&oth_owner')
       and exists
           (select  1
              from  all_triggers&ref_db b
              where b.trigger_name = a.trigger_name
                and b.owner = upper('&ref_owner')
                and ( b.trigger_type <> a.trigger_type
                   or b.triggering_event <> a.triggering_event
                   or b.table_owner <> a.triggering_event
                   or b.table_name <> a.table_name
                   or b.referencing_names <> a.referencing_names
                   or b.when_clause <> a.when_clause
                   or b.status <> a.status
                   or b.description <> a.description
		    )
            )
order by 1,2,3;
select 1 ord, 'Add Index to &ref_db' action, a.index_name table_name
from
	all_indexes&oth_db a
where a.table_name &clause
  and a.owner = upper('&oth_db')
  and not exists
	(select null
	 from all_indexes&ref_db b
	 where b.table_name = a.table_name
	   and b.owner = a.owner
	   and b.index_name = a.index_name
	   and b.table_owner = a.table_owner)
union
select 2 ord, 'Remove Index from &ref_db' action, a.index_name table_name
from
	all_indexes&ref_db a
where a.table_name &clause
  and a.owner = upper('&ref_db')
  and not exists
	(select null
	 from all_indexes&oth_db b
	 where b.table_name = a.table_name
	   and b.owner = a.owner
	   and b.index_name = a.index_name
	   and b.table_owner = a.table_owner)
union
select 3 ord, 'Index differs in Uniqueness in &oth_db' action, a.index_name index_name
from
	all_indexes&oth_db a
where a.table_name &clause
  and a.owner = upper('&oth_owner')
  and exists
        (select null
         from all_indexes&ref_db c
         where c.table_name = a.table_name
           and c.owner = a.owner
           and c.index_name = a.index_name
           and c.table_owner = a.table_owner)
  and not exists
	(select null
	 from all_indexes&ref_db b
	 where b.table_name = a.table_name
	   and b.owner = a.owner
	   and b.index_name = a.index_name
	   and b.table_name = a.table_name
	   and b.owner = a.owner
	   and b.table_owner = a.table_owner
	   and b.uniqueness = a.uniqueness )
order by 1, 2, 3;
column action heading 'Action' format a35
column table_name heading 'Object' format a29
break on action on table_name on index_name skip 1
select 1 ord, 'Columns different in index on &ref_db' action, a.table_name, a.index_name, column_name
from 
	all_ind_columns&oth_db a
where a.table_name &clause
  and a.index_owner = upper('&oth_owner')
  and exists
	(select null
	 from all_indexes&ref_db c
	 where c.table_name = a.table_name
	   and c.owner = a.index_owner
	   and c.index_name = a.index_name
	   and c.table_owner = a.table_owner)
  and not exists
	(select null
	 from all_ind_columns&ref_db b
	  where b.table_name = a.table_name
	    and b.index_owner = a.index_owner
	    and b.index_name = a.index_name
	    and b.table_name = a.table_name
	    and b.table_owner = a.table_owner
	    and b.column_position = a.column_position
	    and b.column_name = a.column_name)
order by 1, 2, 3, 4, 5;
break on ord skip 3 on action skip 2 on table_name skip  1
select 3 ord, 'Column Change on &ref_db' action, a.table_name, a.column_name,
decode(nullable,'Y','','N','NOT NULL') nulls,
data_type||decode(data_type,'NUMBER',decode(nvl(data_precision,-1),'-1',decode(nvl(data_scale,-1),'-1','','(38'),'('||
data_precision), 'DATE','', 'LONG','', 'LONG RAW','','MLSLABEL','','RAW','','ROWID','','('||data_length)||
decode(data_type,'NUMBER', decode(nvl(data_scale,-1), '-1','', ','||data_scale||')') ,'DATE','', 'LONG','', 'LONG RAW','',
'MLSLABEL','','RAW','','ROWID','',')') length
from
	all_tab_columns&oth_db a
where a.table_name &clause
  and a.owner = upper('&oth_owner')
  and exists
	(select  1
	from  all_tab_columns&ref_db b
	where b.table_name    = a.table_name
	  and b.column_name   = a.column_name
	  and b.owner = upper('&ref_owner')
	  and (
	  	nvl(b.data_type,'(') <> nvl(a.data_type,')')
		or nvl(b.data_length,999) <> nvl(a.data_length,998)
--	     or decode(b.data_type,'NUMBER',decode(nvl(b.data_precision,-1),'-1',nvl(b.data_scale,-1), b.data_precision), nvl(b.data_length,999)) <> 
--	      decode(a.data_type,'NUMBER',decode(nvl(a.data_precision,-1),'-1',nvl(a.data_scale,-1), a.data_precision), nvl(a.data_length,998))
	     or nvl(b.nullable,'(')    <> nvl(a.nullable,')')
	      )     
	 )
union
select 4 ord, 'Columns to be Added to &ref_db' action, c.table_name, c.column_name, 
decode(nullable,'Y','','N','NOT NULL') nulls,
data_type||decode(data_type,'NUMBER',decode(nvl(data_precision,-1),'-1',decode(nvl(data_scale,-1),'-1','','(38'),'('||
data_precision), 'DATE','', 'LONG','', 'LONG RAW','','MLSLABEL','','RAW','','ROWID','','('||data_length)||
decode(data_type,'NUMBER', decode(nvl(data_scale,-1), '-1','', ','||data_scale||')') ,'DATE','', 'LONG','', 'LONG RAW','',
'MLSLABEL','','RAW','','ROWID','',')') length
from
	all_tab_columns&oth_db c
where c.table_name &clause
  and c.owner = upper('&oth_owner')
  and exists
	(select  1
	from  all_objects&ref_db g
	where g.object_name = c.table_name
	  and g.object_type = 'TABLE'
	  and g.owner = upper('&ref_owner')
	)
  and not exists
	(select  1
	from  all_tab_columns&ref_db d
	where d.table_name    = c.table_name
	  and d.column_name   = c.column_name
	  and d.owner = upper('&ref_owner')
	)
union
select 5 ord, 'Columns to be Deleted from &ref_db' action, e.table_name, e.column_name, 
decode(nullable,'Y','','N','NOT NULL') nulls,
data_type||decode(data_type,'NUMBER',decode(nvl(data_precision,-1),'-1',decode(nvl(data_scale,-1),'-1','','(38'),'('||
data_precision), 'DATE','', 'LONG','', 'LONG RAW','','MLSLABEL','','RAW','','ROWID','','('||data_length)||
decode(data_type,'NUMBER', decode(nvl(data_scale,-1), '-1','', ','||data_scale||')') ,'DATE','', 'LONG','', 'LONG RAW','',
'MLSLABEL','','RAW','','ROWID','',')') length
from
	all_tab_columns&ref_db e
where e.table_name &clause
  and e.owner = upper('&ref_owner')
  and exists
	(select  1
	from  all_objects&oth_db h
	where h.object_name = e.table_name
	  and h.object_type = 'TABLE'
	  and h.owner = upper('&oth_owner')
	)
  and not exists
	(select  1
	from  all_tab_columns&oth_db f
	where f.table_name    = e.table_name
	  and f.column_name   = e.column_name
	  and f.owner = upper('&oth_owner')
	)
order by 1,2,3,5;
break on ord skip 3 on action skip 2 
select 1 ord, 'Synonym Missing from &oth_db' action, a.owner||'.'||a.synonym_name synonym_name, 
	a.owner||'.'||a.table_name table_name, a.db_link
from all_synonyms&ref_db a
where a.table_name &clause
  and a.owner = upper('&ref_owner')
  and not exists
	(select null
	 from all_synonyms&oth_db b
	 where b.owner = a.owner
	   and b.synonym_name = a.synonym_name
	)
union
select 2 ord, 'Synonym exists in &oth_db and not in &ref_db' action, a.owner||'.'||a.synonym_name synonym_name, 
	a.owner||'.'||a.table_name table_name, a.db_link
from all_synonyms&oth_db a
where a.table_name &clause
  and a.owner = upper('&oth_owner')
  and not exists
	(select null
	 from all_synonyms&ref_db b
	 where b.owner = a.owner
	   and b.synonym_name = a.synonym_name
	)
union
select 3 ord, 'Synonyms differ in &oth_db' action, a.owner||'.'||a.synonym_name synonym_name, 
	a.owner||'.'||a.table_name table_name, a.db_link
from all_synonyms&oth_db a
where a.table_name &clause
  and a.owner =  upper('&oth_owner')
  and not exists
	(select null
	 from all_synonyms&ref_db b
	 where b.owner = a.owner
	   and b.synonym_name = a.synonym_name
	   and nvl(b.table_owner, '-') = nvl(a.table_owner, '-')
	   and nvl(b.db_link, '-') = nvl(a.db_link, '-')
	)
order by 1,2,3,4;
spool off
start &tool_home/ppcmd
exit
