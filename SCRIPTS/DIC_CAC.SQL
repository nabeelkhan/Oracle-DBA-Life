--Description: 
--Increase Shared pool size to reach a 90% hit ratio on Dictionary Cache. 
--Entries for dc_table_grants, d_user_grants, and dc_users should be under 5% each in the MISS RATE % column
select 
parameter, 
gets,
Getmisses , 
getmisses/(gets+getmisses)*100 "miss ratio",
(1-(sum(getmisses)/ (sum(gets)+sum(getmisses))))*100 "Hit ratio"
from v$rowcache
where gets+getmisses <>0
group by parameter, gets, getmisses ; 

