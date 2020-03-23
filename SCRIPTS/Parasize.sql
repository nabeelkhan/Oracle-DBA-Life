select 'V$PARAMETER' "View name", name,
to_number(value,'99999999999999999') "Value"
from v$parameter
where name = 'log_buffer'
UNION
select 'V$SGASTAT' "View name", name, bytes
from v$sgastat
where name ='log_buffer'
;
