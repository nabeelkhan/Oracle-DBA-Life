select plan_hash_value, hash_value
from   v$sql
order by 1,2;
