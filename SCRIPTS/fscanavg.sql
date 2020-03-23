REM FILE NAME:  fscanavg.sql
REM LOCATION:   System Monitoring\Reports
REM FUNCTION:   Report the average lengths of the full table scans by user
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   Full_Table_Scans (created by fullscan.sql)
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************
REM 


TTITLE 'AVERAGE SCAN LENGTH OF FULL TABLE SCANS BY USER '
SPOOL rep_out\fscanavg
SELECT   "User Process",
           (  "Rows Retrieved"
            - ("Short Scans" * 5)
           )
         / ("Long Scans")
               "Average Long Scan Length"
    FROM full_table_scans
   WHERE "Long Scans" != 0
ORDER BY "Long Scans" DESC;
SPOOL OFF
TTITLE OFF
