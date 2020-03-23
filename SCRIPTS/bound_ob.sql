REM FILE NAME:  bound_ob.sql
REM LOCATION:   Object Management\Tablespaces and DataFiles\Reports
REM FUNCTION:   Report on objects with extents bounded by freespace
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   sys.ts$,sys.uet$, sys.fet$, sys.fet$, sys.obj$,
REM             sys.sys_objects, sys.user$, sys.ts$
REM
REM  INPUTS: 	obj_own = the owner of the table.
REM          	obj_nam = the name of the table.
REM
REM This is a part of the Knowledge Xpert for Oracle Administration library. 
REM Copyright (C) 2001 Quest Software 
REM All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************
REM

SPOOL rep_out\bound_ob
START title132 "Objects With Extents Bounded by Free Space"
COLUMN e format a15 heading "TABLE SPACE"
COLUMN a format a6  heading "OBJECT|TYPE"
COLUMN b format a30 heading "OBJECT NAME"
COLUMN c format a10 heading "OWNER ID"
COLUMN d format 99,999,999 heading "SIZE|IN BYTES"
BREAK on e skip 1 on c 
SET feedback off
SET verify off
SET termout off
COLUMN bls new_value BLOCK_SIZE noprint
SELECT blocksize bls
  FROM sys.ts$
 WHERE NAME = 'SYSTEM';

SELECT   h.NAME e, g.NAME c, f.object_type a, e.NAME b,
         b.LENGTH * &&block_size d
    FROM sys.uet$ b,
         sys.fet$ c,
         sys.fet$ d,
         sys.obj$ e,
         sys.sys_objects f,
         sys.user$ g,
         sys.ts$ h
   WHERE b.block# =   c.block#
                    + c.LENGTH
     AND   b.block#
         + b.LENGTH = d.block#
     AND f.header_file = b.segfile#
     AND f.header_block = b.segblock#
     AND f.object_id = e.obj#
     AND g.user# = e.owner#
     AND b.ts# = h.ts#
ORDER BY 1, 2, 3, 4
/
COLUMN a clear
COLUMN b clear
COLUMN c clear
COLUMN d clear
SET feedback on 
SET verify on
SET termout on
TTITLE ''
TTITLE off
SPOOL off
CLEAR breaks
