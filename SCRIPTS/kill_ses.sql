REM FILE NAME:  kill_ses.sql
REM LOCATION:   Security Administration\Utilities
REM FUNCTION:   Give controlled access to the ALTER SYSTEM KILL SESSSION command
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   ALTER SYSTEM privilege
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************
REM
REM  After creating this procedure, you can grant execute on the 
REM  procedure to a user or a role. That user or role will be able to 
REM  kill sessions, but will not be able to do other ALTER SYSTEM 
REM  commands.
REM
REM***********************************************************************************


CREATE OR REPLACE PROCEDURE kill_session (
   session_id   IN   VARCHAR2,
   serial_num   IN   VARCHAR2
)
AS
   cur      INTEGER;
   ret      INTEGER;
   STRING   VARCHAR2 (100);
BEGIN
   STRING :=    'alter system kill session '
             || ''''
             || session_id
             || ','
             || serial_num
             || '''';
   cur := DBMS_SQL.open_cursor;
   DBMS_SQL.parse (cur, STRING, DBMS_SQL.v7);
   ret := DBMS_SQL.EXECUTE (cur);
   DBMS_SQL.close_cursor (cur);
EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error (-20001, 'Error in execution', TRUE);

      IF DBMS_SQL.is_open (cur)
      THEN
         DBMS_SQL.close_cursor (cur);
      END IF;
END;
/
