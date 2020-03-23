select name
from   v$datafile
where  file# = <cursor P1>
union all
select a.name
from   v$tempfile a, v$parameter b
where  b.name = 'db_files'
and    a.file# + b.value = <cursor P1>;


