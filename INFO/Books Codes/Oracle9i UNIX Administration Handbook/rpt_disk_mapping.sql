set pages 999;
set lines 80;

column mount_point heading 'MP';

break on mount_point skip 2;

select
   substr(file_name,1,4) mount_point,
   substr(file_name,21,20) file_name,
   tablespace_name
from
   dba_data_files
group by
   substr(file_name,1,4),
   substr(file_name,21,20) ,
   tablespace_name
;
