REM FILE NAME:  space.sql
REM LOCATION:   Object Management\Tables\Reports
REM FUNCTION:   Table space usage
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   dba_free_space, v$database, v$datafile
REM USED BY:    space_rp.sql
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


CREATE OR REPLACE PROCEDURE space
AS
   CURSOR datafile1
   IS
      SELECT   tablespace_name, file_id, MAX (bytes) largeextent,
               SUM (bytes) totalfreespace
          FROM sys.dba_free_space
      GROUP BY tablespace_name, file_id
      ORDER BY tablespace_name, file_id;

   CURSOR datafile2 (fileid INTEGER)
   IS
      SELECT NAME, bytes
        FROM v$datafile
       WHERE file# = fileid;

   dbname   VARCHAR2 (8);
BEGIN
   SELECT NAME
     INTO dbname
     FROM v$database;

   DBMS_OUTPUT.put_line ('');
   DBMS_OUTPUT.put_line (   'Space Report for Database '
                         || dbname);
   DBMS_OUTPUT.put_line ('-----------------------------------');
   DBMS_OUTPUT.put_line ('');

   FOR FILE IN datafile1
   LOOP
      DBMS_OUTPUT.put_line (
            'Tablespace Name:           '
         || FILE.tablespace_name
      );
      --DBMS output...Name:'|file...         < commented out.  didn't pass syntax check.
      DBMS_OUTPUT.put_line ('');

      FOR filedata IN datafile2 (FILE.file_id)
      LOOP
         DBMS_OUTPUT.put_line (
               'Data File Name:              '
            || filedata.NAME
         );
         DBMS_OUTPUT.put_line (
               'Total File Size (KB):        '
            || ROUND (filedata.bytes / 1024, 0)
         );
         DBMS_OUTPUT.put_line (
               'Free Space in File (KB):     '
            || ROUND (FILE.totalfreespace / 1024, 0)
         );
         DBMS_OUTPUT.put_line (
               '% Free Space in File:        '
            || ROUND ((  (FILE.totalfreespace / filedata.bytes)
                       * 100
                      ), 0)
            || '%'
         );
         DBMS_OUTPUT.put_line (
               'Largest Extent (KB):      '
            || ROUND (FILE.largeextent / 1024, 0)
         );
         DBMS_OUTPUT.put_line ('');
      END LOOP;
   END LOOP;
END;
/
