col parameter_name for a20
col parameter_value for a20
select advisor_name,
       parameter_name,
       parameter_value,
from   dba_advisor_def_parameters
where  parameter_name like 'DBIO%';











