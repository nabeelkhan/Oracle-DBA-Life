select 0 ord, 'select',null,null,'rtrim('| |column_name | |')'
from user_tab_columns
where table_name = upper('&&TableName')
and column_id=1
union
select column_id ord, '| |' , ''';''' , '| |' ,'rtrim('| |column_name | |')'
from user_tab_columns
where table_name = upper('&TableName')
and column_id > 1
union
select 1000 ord, '| |' , ''';''' , null, 'from &TableName order by 1;'
from dual
order by ord
/
