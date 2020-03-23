REM NAME:       RBK1.SQL
REM LOCATION:   Object Management\Rollback Segment
REM FUNCTION:   REPORT ON ROLLBACK SEGMENT STORAGE
REM FUNCTION:   USES THE ROLLBACK1 VIEW
REM TESTED ON:  8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


COLUMN tablespace_name  FORMAT a10           HEADING 'TABLESPACE'
COLUMN segment_name     FORMAT A10           HEADING 'ROLLBACK'
COLUMN extents          FORMAT 999           HEADING 'CUR|EXTENTS'
COLUMN optsize          FORMAT 999,999,999   HEADING 'OPTL|SIZE'
COLUMN shrinks          FORMAT 999           HEADING 'SHRINKS'
COLUMN aveshrink        FORMAT 999,999,999   HEADING 'AVE|SHRINK'
COLUMN aveactive        FORMAT 999,999,999   HEADING 'AVE|TRANS'
COLUMN status           FORMAT A8            HEADING 'STATUS'
REM
SET FEEDBACK OFF VERIFY OFF LINES 80 PAGES 58
@title80 "ROLLBACK SEGMENT STORAGE"
SPOOL rep_out\rbk1
REM
SELECT   *
    FROM rollback1
ORDER BY segment_name;
SPOOL OFF
CLEAR COLUMNS
TTITLE OFF
SET FEEDBACK ON VERIFY ON LINES 80 PAGES 22
