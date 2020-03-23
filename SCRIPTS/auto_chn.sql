REM FILE NAME: 	auto_chn.sql
REM LOCATION:   Object Management\Tables\Reports
REM FUNCTION:   Run CHAINING.sql for all of a specified users tables
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   v$parameter, dba_tables
REM
REM INPUTS:		&db    = part of spool location
REM            	tabown = Name of owner.
REM
REM This is a part of the Knowledge Xpert for Oracle Administration library. 
REM Copyright (C) 2001 Quest Software 
REM All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************
REM
REM  NOTES:    See CHAINING.sql header for additional info.
REM
REM***********************************************************************************


ACCEPT tabown prompt 'Enter table owner: '
SET termout off feedback off verify off echo off heading off pages 999 
SET embedded on
COLUMN value new_value db noprint
SELECT VALUE
  FROM v$parameter
 WHERE NAME = 'db_name';
SPOOL rep_out\auto_chn.gql
SELECT    'start chaining &tabown '
       || table_name
  FROM dba_tables
 WHERE owner = UPPER ('&tabown')
/
SPOOL rep_out\auto_chn
START rep_out\auto_chn.gql
SPOOL off 
UNDEF tabown
SET termout on feedback 15 verify on pagesize 20 linesize 80 space 1
SET embedded off
HO del rep_out\auto_chn.gql
PAUSE Press enter to continue
