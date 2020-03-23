REM FILE NAME:  libcache.sql
REM LOCATION:   Database Tuning\Shared Pool Reports
REM FUNCTION:   Generate a library cache report 
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   v$librarycache
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


COLUMN namespace                        heading "Library Object"
COLUMN gets             format 99999999   heading " Gets"
COLUMN gethitratio      format 9999.99   heading " Get Hit%"
COLUMN pins             format 99999999   heading " Pins"
COLUMN pinhitratio      format 9999.99   heading " Pin Hit%"
COLUMN reloads          format 99999999   heading " Reloads"
COLUMN invalidations    format 99999999   heading " Invalidations"
COLUMN db               format a10
SET pages 58 lines 80 
START title80 "Library Caches Report"
SPOOL rep_out\libcache
SELECT namespace, gets, gethitratio * 100 gethitratio, pins,
       pinhitratio * 100 pinhitratio, reloads, invalidations
  FROM v$librarycache
/
SPOOL off
SET pages 22 lines 80
TTITLE off
UNDEF output
