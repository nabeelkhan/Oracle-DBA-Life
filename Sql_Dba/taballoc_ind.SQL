CREATE TABLE TABLESPACE_ALLOC
AS SELECT TABLESPACE_NAME, SUM(BYTES) BYTES
FROM DBA_DATA_FILES
GROUP BY TABLESPACE_NAME
/
