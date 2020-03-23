REM	Free Space left in the tablespaces of the database 


col tablespace_name format a20 heading 'Tablespace'
col allocated format 99,999,999,999 heading 'Allocated'
col used format 99,999,999,999 heading 'Used'
col unused format 99,999,999,999 heading 'Unused'
col pct_used format 99.99 heading 'PCT Used'
spool tbsp_free.lst

select rtrim(a.tblsp) tablespace,
sum(to_use) allocated,
sum(to_use - nvl(free,0)) used,
sum(nvl(free,0)) unused,
sum(((to_use-(to_use - nvl(free,0)))*100)/to_use) pct_used
from tspace_alc a,
tspace_free b
where a.tblsp = b.tblsp (+)
group by a.tblsp;



REM	SPOOL rep_out\FREE_TAB_SPACE.LIST