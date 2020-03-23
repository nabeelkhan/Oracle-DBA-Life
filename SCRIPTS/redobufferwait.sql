select r.value "Retries", e.value "Entries",
r.value/e.value*100 "Percentage"
from v$sysstat r, v$sysstat e
where r.name = 'redo buffer allocation retries'
and e.name='redo entries';

