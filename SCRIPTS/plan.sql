REM FILE NAME:  plan.sql
REM LOCATION:   Application Tuning\Utilities
REM FUNCTION:   Format explain plan output
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   plan_table
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************
REM

COLUMN QUERY_PLAN FORMAT A60
SPOOL rep_out\plan
SELECT        LPAD (' ', 2 * LEVEL)
           || operation
           || ' '
           || options
           || ' '
           || object_name query_plan
      FROM plan_table
CONNECT BY PRIOR id = parent_id
START WITH id = 1
  ORDER BY id;
SPOOL OFF
