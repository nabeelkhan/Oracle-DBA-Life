set linesize 150
column OBJECT_NAME format a50
select OBJECT_TYPE, OBJECT_NAME, CREATED, LAST_DDL_TIME, TIMESTAMP, STATUS from dba_objects
where OBJECT_NAME like '&OBJ_NAM';
