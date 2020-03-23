select 
a.value "Disk Sort", b.value "Memory Sorts", 
round(100 * b.value) / decode((a.value + b.value),0,1, (a.value + b.value),2)  "Pct Memory Sorts"
from v$sysstat a, v$sysstat b
where a.name = 'sorts (disk)'
and   b.name = 'sorts (memory)'
/
