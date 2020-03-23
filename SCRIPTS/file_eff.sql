REM FILE NAME:  file_eff.sql
REM LOCATION:   Database Tuning\File I/O Reports
REM FUNCTION:   Generate file io efficiencies report
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


CLEAR COLUMNS
SET PAGES 58 NEWPAGE 0 
SET LINES 131
COLUMN EFF        FORMAT A6            HEADING '% Eff'
COLUMN RW         FORMAT 9,999,999,999 HEADING 'Phys Block read/writes'
COLUMN TS         FORMAT A25           HEADING 'Tablespace name'
COLUMN filename   FORMAT a51           HEADING 'File Name'
START title132 "FILE IO EFFICIENCY"
BREAK ON TS
SPOOL rep_out\file_eff
SELECT   f.tablespace_name ts, f.file_name filename,
           v.phyblkrd
         + v.phyblkwrt rw,
         TO_CHAR (
            DECODE (
               v.phyblkrd,
               0, NULL,
               ROUND (
                    100
                  * (  v.phyrds
                     + v.phywrts
                    )
                  / (  v.phyblkrd
                     + v.phyblkwrt
                    ),
                  2
               )
            )
         ) eff
    FROM dba_data_files f, v$filestat v
   WHERE f.file_id = v.file#
ORDER BY 1, file#;
SPOOL off
