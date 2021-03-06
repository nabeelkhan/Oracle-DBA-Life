CLEAR SCREEN
SET HEADING OFF
SET TERMOUT ON
SET SERVEROUTPUT ON
PROMPT
PROMPT Script ran from D:\NABEEL\DBA\SCRIPTS\IDX_VAL.SQL
PROMPT
PROMPT
PROMPT Validate Script will be created in D:\NABEEL\DBA\SCRIPTS\LST AS IDX_STVAL.SQL
PROMPT
PROMPT
PROMPT CONNECT AS THE OWNER OR WHO HAVE ACCESS TO THE OBJECTS, PROVIDE USERNAME AND PASSWORD 
PROMPT WITH CONNECT STRING . BY DEFAULT IT WILL CONNECT TO LEGATO AS PREMPROD
PROMPT
PROMPT
SET TERMOUT OFF

SPOOL D:\NABEEL\LST\ES40\IDX_STVAL.SQL
SELECT 'ANALYZE INDEX ', OWNER||'.'|| INDEX_NAME, 'VALIDATE STRUCTURE ;' FROM DBA_INDEXES
WHERE OWNER IN ('PREMPROD','FINAL7','LIFEPROD');
REM UNcomment this line if want to do monitoring for 1 single user
--WHERE OWNER ='PREMPROD';
SPOOL OFF

var v_idx  varchar2(4);
   SELECT COUNT(*) INTO  :TOT 
   FROM DBA_INDEXES
    WHERE OWNER IN ('PREMPROD','FINAL7');

CONN PREMPROD/PREMPROD@LEGATO

EXECUTE  DBMS_OUTPUT.PUT_LINE('Total Number of Indexex Altered'||'  '||:tot);

@D:\NABEEL\LST\ES40\IDX_STVAL.SQL;

--CONN NK_DBA/DBA@LEGATO
SET TERMOUT ON
SHOW USER
