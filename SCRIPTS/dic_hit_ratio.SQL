select (1 - (sum(getmisses) / sum(gets))) * 100 "Hit Ratio for Dictonary"
from V$rowcache
/
