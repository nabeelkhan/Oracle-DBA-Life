REM -- In Oracle10g global cache waits are known as gc waits
REM -- Replace ‘global cache%’ with ‘gc%’ for Oracle10g

select name, value 
from   v$sysstat
where  name like '%global cache%';
















