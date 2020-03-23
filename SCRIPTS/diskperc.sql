REM FILE NAME:  diskperc.sql
REM LOCATION:   System Monitoring\Reports
REM FUNCTION:   Report the spread of disk I/Os
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   v$filestat
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


DROP TABLE tot_read_writes;

CREATE TABLE tot_read_writes
  AS SELECT SUM(phyrds) phys_reads, SUM(phywrts) phys_wrts
        FROM v$filestat;
TTITLE ' Disk I/O s by Datafile '
COLUMN name      FORMAT a30
COLUMN phyrds    FORMAT 999,999,999
COLUMN phywrts   FORMAT 999,999,999
COLUMN read_pct  FORMAT 999.99        
COLUMN write_pct FORMAT 999.99      
SPOOL rep_out\diskperc  
SELECT   NAME, phyrds,
         phyrds * 100 / trw.phys_reads read_pct,
         phywrts,
         phywrts * 100 / trw.phys_wrts write_pct
    FROM tot_read_writes trw, v$datafile df, v$filestat fs
   WHERE df.file# = fs.file#
ORDER BY phyrds DESC;
SPOOL OFF
