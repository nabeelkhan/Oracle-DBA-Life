REM FILE NAME:  fileio.sql
REM LOCATION:   System Monitoring\Reports
REM FUNCTION:   Reports on the file io status of all of the datafiles 
REM             in the database
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   v_$filestat, sys.v_$dbfile 
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


COLUMN sum_io new_value divide_by noprint
COLUMN Percent   format 999.99    heading 'Percent|Of IO'
COLUMN ratio     format 999.999   heading 'Block|Read|Ratio'
COLUMN phyrds                     heading 'Physical | Reads'
COLUMN phywrts                    heading 'Physical | Writes'
COLUMN phyblkrd                   heading 'Physical|Block|Reads'
COLUMN name      format a50       heading 'File|Name'
SET feedback off verify off lines 132 pages 60
REM
SELECT SUM (  phyrds
            + phywrts) sum_io
  FROM sys.v_$filestat;
REM
@title132 'File IO Statistics Report'
SPOOL rep_out\fileio
SELECT   NAME, phyrds, phywrts,
           ((  phyrds
             + phywrts
            ) / &divide_by
           )
         * 100 PERCENT,
         phyblkrd,
         (phyblkrd / GREATEST (phyrds, 1)) ratio
    FROM sys.v_$filestat a, sys.v_$dbfile b
   WHERE a.file# = b.file#
ORDER BY A.file#
/
SPOOL off
SET feedback on verify on lines 80 pages 22
CLEAR columns
TTITLE off
