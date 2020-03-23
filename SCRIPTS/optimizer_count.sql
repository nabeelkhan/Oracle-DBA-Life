 select optimizer_mode, optimizer_cost, count(*)  from v$sql group by
optimizer_mode, optimizer_cost
order by optimizer_cost


--select sql_text, optimizer_mode, optimizer_cost
--from v$sql where sql_text like '%LOOK_FOR_ME%';

/
