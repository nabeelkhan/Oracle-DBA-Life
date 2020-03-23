REM FILE NAME:  grants.sql
REM LOCATION:  	SetUp
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************
REM
REM In order for the views used for monitoring to be created
REM these direct grants have to be made to the user who will be
REM doing the monitoring. It is suggested that the user
REM also be granted the DBA role or the MONITORER role
REM These grants must be made from the SYS user.
REM
REM***********************************************************************************
REM

GRANT SELECT ON dba_free_space TO &&monitoring_user WITH GRANT OPTION;
GRANT SELECT ON v_$rollstat TO &&monitoring_user WITH GRANT OPTION;
GRANT SELECT ON v_$rollname TO &&monitoring_user WITH GRANT OPTION;
GRANT SELECT ON v_$sgastat TO &&monitoring_user WITH GRANT OPTION;
GRANT SELECT ON v_$sqlarea TO &&monitoring_user WITH GRANT OPTION;
GRANT SELECT ON v_$lock TO &&monitoring_user WITH GRANT OPTION;
GRANT SELECT ON dba_users TO &&monitoring_user WITH GRANT OPTION;
GRANT SELECT ON v_$process TO &&monitoring_user WITH GRANT OPTION;
GRANT SELECT ON dba_source TO &&monitoring_user WITH GRANT OPTION;
GRANT SELECT ON dba_rollback_segs TO &&monitoring_user WITH GRANT OPTION;
GRANT SELECT ON v_$rowcache TO &&monitoring_user WITH GRANT OPTION;
GRANT SELECT ON v_$sysstat TO &&monitoring_user WITH GRANT OPTION;
GRANT SELECT ON v_$waitstat TO &&monitoring_user WITH GRANT OPTION;
GRANT SELECT ON v_$instance TO &&monitoring_user WITH GRANT OPTION;
GRANT SELECT ON v_$librarycache TO &&monitoring_user WITH GRANT OPTION;
GRANT SELECT ON v_$sga TO &&monitoring_user WITH GRANT OPTION;
GRANT SELECT ON v_$latchname TO &&monitoring_user WITH GRANT OPTION;
GRANT SELECT ON v_$latch TO &&monitoring_user WITH GRANT OPTION;
GRANT SELECT ON v_$parameter TO &&monitoring_user WITH GRANT OPTION;
GRANT SELECT ON dba_tablespaces TO &&monitoring_user WITH GRANT OPTION;
GRANT SELECT ON dba_indexes TO &&monitoring_user WITH GRANT OPTION;
GRANT SELECT ON dba_extents TO &&monitoring_user WITH GRANT OPTION;
GRANT SELECT ON dba_objects TO &&monitoring_user WITH GRANT OPTION;
GRANT SELECT ON dba_data_files TO &&monitoring_user WITH GRANT OPTION;
GRANT SELECT ON dba_tables TO &&monitoring_user WITH GRANT OPTION;
GRANT SELECT ON dba_tab_columns TO &&monitoring_user WITH GRANT OPTION;
GRANT SELECT ON dba_segments TO &&monitoring_user WITH GRANT OPTION;
GRANT SELECT ON v_$session TO &&monitoring_user WITH GRANT OPTION;
GRANT EXECUTE ON DBMS_SHARED_POOL TO &&monitoring_user;
GRANT EXECUTE ON DBMS_SQL TO &&monitoring_user;
GRANT CREATE PROCEDURE TO &&monitoring_user;
GRANT ALTER SYSTEM TO &&monitoring_user;
GRANT SELECT ON v_$timer TO &&monitoring_user WITH GRANT OPTION;
GRANT ANALYZE ANY TO &&monitoring_user WITH ADMIN OPTION;
GRANT ALTER TABLESPACE TO &&monitoring_user WITH ADMIN OPTION;
GRANT SELECT_CATALOG_ROLE TO &&monitoring_user;
