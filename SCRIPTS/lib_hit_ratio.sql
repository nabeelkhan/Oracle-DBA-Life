select sum(pins) / (sum(pins) + sum(reloads)) * 100  "Library Hit Ratio"
from v$librarycache
--select sum(reloads) / sum(pins) "Reload Hit Ratio"
--from v$librarycache
/
