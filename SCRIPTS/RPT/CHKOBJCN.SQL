REM chkobjcn.sql checked out on 12/22/97 17:05:21 version 1.1 created on 12/18/97 08:57:25
REM Reports on the types of objects for the wildcards
REM                   ^owner
REM                   ^prefix
REM                   ^tbsp_prefix
REM
REM Sets termout on before SQL runs
REM
column ord_col noprint
column buff fold_after 1
set termout on
prompt
select 1 ord_col,
'There are '||count(atb.table_name)||' tables, ' buff
from
	 all_tables atb
where atb.owner like upper('^owner')
  and atb.table_name like upper('^prefix')
  and atb.tablespace_name like upper('^tbsp_prefix')
union
select 2 ord_col,
count(ai.index_name)||' indexes' buff
from 
     all_indexes ai
where ai.owner like upper('^owner')
  and ai.table_name like upper('^prefix')
  and ai.tablespace_name like upper('^tbsp_prefix')
  and not exists (select null 
		  from all_constraints ac 
		  where ai.index_name = ac.constraint_name 
		    and ac.owner = ai.owner 
		    and ac.table_name = ai.table_name 
		    and constraint_type in ('P','U'))
  union
select 3 ord_col,
/* get the owners that have Referential constraints referencing the Primary/Unique keys for the wildcards */
count(ac.constraint_name)||' '||decode(constraint_type, 'C', 'Check', 'R', 'Referential', 'U', 'Unique key', 'P', 'Primary key',
constraint_type)||' constraints' buff
from 
	 all_indexes ai,
	 all_constraints ac
where ac.owner like upper('^owner')
  and ac.constraint_type in ('P','U')
  and ac.constraint_name = ai.index_name
  and ac.owner = ai.owner
  and ai.table_name like upper('^prefix')
  and ai.tablespace_name like upper('^tbsp_prefix')
group by constraint_type
union
select 4 ord_col,
/* get the constraints which have indexes with different names enforcing the constraint for the wildcards */
count(ac.constraint_name)||' '||decode(constraint_type, 'C', 'Check', 'R', 'Referential', 'U', 'Unique key', 'P', 'Primary key',
constraint_type)||' constraints ARE ENFORCED where INDEXE_NAME != CONSTRAINT_NAME' buff
from 
	all_constraints ac
where ac.owner like upper('^owner')
  and ac.table_name like upper('^prefix')
  and ac.constraint_type in ('P','U')
  and not exists (select null
 		  from all_indexes ai
           	  where ai.table_name = ac.table_name
		    and ai.owner = ac.owner
		    and ai.index_name = ac.constraint_name)
group by constraint_type
union
select 5 ord_col,
/* get the owners that have Referential constraints referencing the Primary/Unique keys for the wildcards */
count(ac.constraint_name)||' foreign key constraints referencing these primary/unique keys.' buff
from 
	all_indexes ai,
	all_constraints ac
where ac.r_owner like upper('^owner')
  and ai.owner = ac.r_owner
  and ac.constraint_type  = 'R'
  and ai.table_name like upper('^prefix')
  and ac.r_constraint_name = ai.index_name
  and ai.tablespace_name like upper('^tbsp_prefix')
union
select 6 ord_col,
'for owner:  ''^owner'' in tablespace name like: ''^tbsp_prefix'' with table_names like: ''^prefix''.' buff
from dual
order by 1;
prompt
