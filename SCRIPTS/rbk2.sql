REM FILE NAME: 	RBK2.SQL
REM LOCATION: 	Object Management\Rollback Segment
REM FUNCTION: 	REPORT ON ROLLBACK SEGMENT STATISTICS
REM FUNCTION: 	USES THE ROLLBACK2 VIEW
REM TESTED ON: 	8.1.5, 8.1.7, 9.0.1
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


COLUMN segment_name     FORMAT A10              HEADING 'ROLLBACK'
COLUMN extents          FORMAT 9,999            HEADING 'EXTENTS'
COLUMN xacts            FORMAT 9,999            HEADING 'TRANS'
COLUMN hwmsize          FORMAT 9,999,999,999    HEADING 'LARGEST TRANS'
COLUMN rssize           FORMAT 9,999,999,999    HEADING 'CUR SIZE'
COLUMN waits            FORMAT 999              HEADING 'WAITS'
COLUMN wraps            FORMAT 999              HEADING 'WRAPS'
COLUMN extends          FORMAT 999              HEADING 'EXTENDS'
REM
SET FEEDBACK OFF VERIFY OFF lines 80 pages 58
REM
@title80 "ROLLBACK SEGMENT STATISTICS"
SPOOL rep_out\rbk2
REM
SELECT   *
    FROM rollback2
ORDER BY segment_name;
SPOOL OFF
SET LINES 80 PAGES 20 FEEDBACK ON VERIFY ON 
TTITLE OFF
CLEAR COLUMNS
