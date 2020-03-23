REM FILE NAME:  wbs.sql
REM LOCATION:   System Monitoring\Reports
REM FUNCTION:   Display the system write batch size
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   must be connected as SYS
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


SELECT kviival write_batch_size
  FROM x$kvii
 WHERE kviidsc = 'DB writer IO clump'
    OR kviitag = 'kcbswc'
/
