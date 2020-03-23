select count(object_name), OBJECT_TYPE, status from dba_objects
where OWNER = 'TABS'
--and OBJECT_TYPE = 'VIEW'
--and status <>'VALID'
group by OBJECT_TYPE, status
order by 3
/
