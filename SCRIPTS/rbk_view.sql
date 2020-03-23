REM FILE NAME:  rbk_view.sql
REM FUNCTION:   create views required for rbk1 and rbk2 reports.
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   V$ROLLNAME,V$ROLLSTAT 
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


CREATE OR REPLACE VIEW rollback1
AS
   SELECT d.segment_name, extents, optsize, shrinks, aveshrink, aveactive,
          d.status
     FROM v$rollname n, v$rollstat s, dba_rollback_segs d
    WHERE d.segment_id = n.usn(+) AND d.segment_id = s.usn(+);

CREATE OR REPLACE VIEW rollback2
AS
   SELECT d.segment_name, extents, xacts, hwmsize, rssize, waits, wraps,
          EXTENDS
     FROM v$rollname n, v$rollstat s, dba_rollback_segs d
    WHERE d.segment_id = n.usn(+) AND d.segment_id = s.usn(+);
