-- ***************************************************************************
-- File: 4_5.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 4_5.lis

SELECT ds.owner owner, table_owner,
       SUBSTR(dc.table_type,1,6) table_type,
       ds.table_name table_name, synonym_name
FROM   dba_synonyms ds, user_catalog dc
WHERE  ds.table_name  = dc.table_name
ORDER BY ds.owner, table_owner, table_type, ds.table_name;

SPOOL OFF
