REM FILE NAME:  oa_sys.sql
REM LOCATION:   Security Administration\Reports
REM FUNCTION:   Print out users who have SYSTEM ADMINISTRATOR responsibilites
REM             within Oracle Applications
REM TESTED ON:  8.0.4.1, 8.1.5
REM PLATFORM:   non-specific
REM REQUIRES:   
REM AUTHOR:     Jim Basler
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************
REM

SET linesize 130
SET pagesize 3000

COLUMN user_name heading 'User' format a20 word_wrapped
COLUMN responsibility_name heading 'Responsibility' format a35
COLUMN start_date heading 'Starts' format a17
COLUMN end_date heading 'Ends' format a17

BREAK on responsibility_name skip 1 on user_name
ALTER SESSION SET nls_date_format='DD-Mon-YYYY HH24:MI';
@title132 'Users who have SYSTEM ADMINISTRATOR within Oracle Apps'
SPOOL rep_out\oa_sys

SELECT   fr.responsibility_name, fu.user_name, fu.start_date, fu.end_date,
         fur.start_date, fur.end_date
    FROM applsys.fnd_responsibility fr,
         applsys.fnd_user_responsibility fur,
         applsys.fnd_user fu
   WHERE fu.user_id = fur.user_id
     AND fur.responsibility_id = fr.responsibility_id
     AND fur.application_id = fr.application_id
     AND UPPER (fr.responsibility_name) LIKE 'SYSTEM%'
     AND fur.end_date IS NULL
     AND fu.end_date IS NULL
ORDER BY fr.responsibility_name, fu.user_name, fur.start_date, fur.end_date
/

SPOOL off;
TTITLE off;
