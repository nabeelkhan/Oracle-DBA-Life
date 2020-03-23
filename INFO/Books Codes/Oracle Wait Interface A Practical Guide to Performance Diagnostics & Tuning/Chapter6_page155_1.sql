select hash_value, substr(sql_text,1,80)
from   v$sqlarea
where  substr(sql_text,1,40) in (select substr(sql_text,1,40)
                                 from   v$sqlarea
                                 having count(*) > 4
                                 group by substr(sql_text,1,40))
order by sql_text;
