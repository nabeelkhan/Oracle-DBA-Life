set verify off
set feedback off
set echo off
set long 5000
set pagesize 0
set head off
set lines 1000
set termout on
set trimspool on
set serveroutput on
clear columns
spool c:\NK\create_tablespaces.sql

DECLARE

CURSOR c_df (tbs_name VARCHAR2) IS
SELECT a.file_name,
a.tablespace_name,
a.bytes,
b.maxextend,
b.inc
FROM dba_data_files a,
sys.filext$ b
WHERE a.tablespace_name = tbs_name
AND a.file_id = b.file# (+);

/* dba_tablespaces columns */
v_tbsname VARCHAR2(30);
v_blksize NUMBER;
v_initial NUMBER;
v_next NUMBER;
v_minext NUMBER;
v_maxext NUMBER;
v_pctinc NUMBER;
v_extlen NUMBER;
v_status VARCHAR2(9);
v_contents VARCHAR2(9);
v_logging VARCHAR2(9);
v_flogging VARCHAR2(3);
v_extman VARCHAR2(10);
v_alloc VARCHAR2(9);
v_plugged VARCHAR2(3);
v_segman VARCHAR2(6);

cur INTEGER;
rec_tbs dba_tablespaces%ROWTYPE;

v_bs INTEGER;
v_ltt BOOLEAN := FALSE;
v_version VARCHAR2(10);
l_str VARCHAR2(10);
m_str VARCHAR2(20);
sSQLt VARCHAR2(1000);
v_return INTEGER;

BEGIN
DBMS_OUTPUT.ENABLE (1000000);

SELECT value
INTO v_bs
FROM v$parameter
WHERE name = 'db_block_size';

SELECT version
INTO v_version
FROM v$instance;

IF SUBSTR(v_version, 1, 1) = '7' THEN
sSQLt := 'SELECT TABLESPACE_NAME, INITIAL_EXTENT,
NEXT_EXTENT, MIN_EXTENTS,
MAX_EXTENTS, PCT_INCREASE,
STATUS
FROM DBA_TABLESPACES
WHERE TABLESPACE_NAME <> ' || 

|| 'SYSTEM' || 

;
ELSIF SUBSTR(v_version, 1, 3) = '8.0' THEN
sSQLt := 'SELECT TABLESPACE_NAME, INITIAL_EXTENT,
NEXT_EXTENT, MIN_EXTENTS,
MAX_EXTENTS, PCT_INCREASE,
STATUS, MIN_EXTLEN,
CONTENTS, LOGGING
FROM DBA_TABLESPACES
WHERE TABLESPACE_NAME <> ' || 

|| 'SYSTEM' || 

;
ELSIF SUBSTR(v_version, 1, 3) = '8.1' THEN
sSQLt := 'SELECT TABLESPACE_NAME, INITIAL_EXTENT, NEXT_EXTENT,
MIN_EXTENTS, MAX_EXTENTS, PCT_INCREASE, STATUS,
MIN_EXTLEN, CONTENTS, LOGGING, EXTENT_MANAGEMENT,
ALLOCATION_TYPE, PLUGGED_IN
FROM DBA_TABLESPACES
WHERE TABLESPACE_NAME <> ' || 

|| 'SYSTEM' || 

;
ELSIF SUBSTR(v_version, 1, 3) = '9.0' THEN
sSQLt := 'SELECT TABLESPACE_NAME, INITIAL_EXTENT, NEXT_EXTENT,
MIN_EXTENTS, MAX_EXTENTS, PCT_INCREASE, STATUS,
MIN_EXTLEN, CONTENTS, LOGGING, EXTENT_MANAGEMENT,
ALLOCATION_TYPE, PLUGGED_IN, BLOCK_SIZE,
SEGMENT_SPACE_MANAGEMENT
FROM DBA_TABLESPACES
WHERE TABLESPACE_NAME <> ' || 

|| 'SYSTEM' || 

;
ELSE
sSQLt := 'SELECT TABLESPACE_NAME, INITIAL_EXTENT, NEXT_EXTENT,
MIN_EXTENTS, MAX_EXTENTS, PCT_INCREASE, STATUS,
MIN_EXTLEN, CONTENTS, LOGGING, EXTENT_MANAGEMENT,
ALLOCATION_TYPE, PLUGGED_IN, BLOCK_SIZE,
SEGMENT_SPACE_MANAGEMENT, FORCE_LOGGING
FROM DBA_TABLESPACES
WHERE TABLESPACE_NAME <> ' || 

|| 'SYSTEM' || 

;
END IF;

cur := DBMS_SQL.OPEN_CURSOR;

DBMS_SQL.PARSE(cur, sSQLt, DBMS_SQL.native);

DBMS_SQL.DEFINE_COLUMN(cur, 1, v_tbsname, 30);
DBMS_SQL.DEFINE_COLUMN(cur, 2, v_initial);
DBMS_SQL.DEFINE_COLUMN(cur, 3, v_next);
DBMS_SQL.DEFINE_COLUMN(cur, 4, v_minext);
DBMS_SQL.DEFINE_COLUMN(cur, 5, v_maxext);
DBMS_SQL.DEFINE_COLUMN(cur, 6, v_pctinc);
DBMS_SQL.DEFINE_COLUMN(cur, 7, v_status, 9);

IF SUBSTR(v_version, 1, 3) = '8.0' THEN
BEGIN
DBMS_SQL.DEFINE_COLUMN(cur, 8, v_extlen);
DBMS_SQL.DEFINE_COLUMN(cur, 9, v_contents, 9);
DBMS_SQL.DEFINE_COLUMN(cur, 10, v_logging, 9);
END;
ELSIF SUBSTR(v_version, 1, 3) = '8.1' THEN
BEGIN
DBMS_SQL.DEFINE_COLUMN(cur, 8, v_extlen);
DBMS_SQL.DEFINE_COLUMN(cur, 9, v_contents, 9);
DBMS_SQL.DEFINE_COLUMN(cur, 10, v_logging, 9);
DBMS_SQL.DEFINE_COLUMN(cur, 11, v_extman, 10);
DBMS_SQL.DEFINE_COLUMN(cur, 12, v_alloc, 9);
DBMS_SQL.DEFINE_COLUMN(cur, 13, v_plugged, 3);
END;
ELSIF SUBSTR(v_version, 1, 3) = '9.0' THEN
BEGIN
DBMS_SQL.DEFINE_COLUMN(cur, 8, v_extlen);
DBMS_SQL.DEFINE_COLUMN(cur, 9, v_contents, 9);
DBMS_SQL.DEFINE_COLUMN(cur, 10, v_logging, 9);
DBMS_SQL.DEFINE_COLUMN(cur, 11, v_extman, 10);
DBMS_SQL.DEFINE_COLUMN(cur, 12, v_alloc, 9);
DBMS_SQL.DEFINE_COLUMN(cur, 13, v_plugged, 3);
DBMS_SQL.DEFINE_COLUMN(cur, 14, v_blksize);
DBMS_SQL.DEFINE_COLUMN(cur, 15, v_segman, 9);
END;
ELSIF SUBSTR(v_version, 1, 3) = '9.2' THEN
BEGIN
DBMS_SQL.DEFINE_COLUMN(cur, 8, v_extlen);
DBMS_SQL.DEFINE_COLUMN(cur, 9, v_contents, 9);
DBMS_SQL.DEFINE_COLUMN(cur, 10, v_logging, 9);
DBMS_SQL.DEFINE_COLUMN(cur, 11, v_extman, 10);
DBMS_SQL.DEFINE_COLUMN(cur, 12, v_alloc, 9);
DBMS_SQL.DEFINE_COLUMN(cur, 13, v_plugged, 3);
DBMS_SQL.DEFINE_COLUMN(cur, 14, v_blksize);
DBMS_SQL.DEFINE_COLUMN(cur, 15, v_segman, 9);
DBMS_SQL.DEFINE_COLUMN(cur, 16, v_flogging, 3);
END;
END IF;

v_return := DBMS_SQL.EXECUTE(cur);

LOOP
BEGIN

IF DBMS_SQL.FETCH_ROWS(cur) <= 0 THEN
EXIT;
END IF;

DBMS_SQL.COLUMN_VALUE (cur, 1, v_tbsname);
DBMS_SQL.COLUMN_VALUE (cur, 2, v_initial);
DBMS_SQL.COLUMN_VALUE (cur, 3, v_next);
DBMS_SQL.COLUMN_VALUE (cur, 4, v_minext);
DBMS_SQL.COLUMN_VALUE (cur, 5, v_maxext);
DBMS_SQL.COLUMN_VALUE (cur, 6, v_pctinc);
DBMS_SQL.COLUMN_VALUE (cur, 7, v_status);

IF SUBSTR(v_version, 1, 3) = '8.0' THEN
BEGIN
DBMS_SQL.COLUMN_VALUE (cur, 8, v_extlen);
DBMS_SQL.COLUMN_VALUE (cur, 9, v_contents);
DBMS_SQL.COLUMN_VALUE (cur, 10, v_logging);
END;
ELSIF SUBSTR(v_version, 1, 3) = '8.1' THEN
BEGIN
DBMS_SQL.COLUMN_VALUE (cur, 8, v_extlen);
DBMS_SQL.COLUMN_VALUE (cur, 9, v_contents);
DBMS_SQL.COLUMN_VALUE (cur, 10, v_logging);
DBMS_SQL.COLUMN_VALUE (cur, 11, v_extman);
DBMS_SQL.COLUMN_VALUE (cur, 12, v_alloc);
DBMS_SQL.COLUMN_VALUE (cur, 13, v_plugged);
END;
ELSIF SUBSTR(v_version, 1, 3) = '9.0' THEN
BEGIN
DBMS_SQL.COLUMN_VALUE (cur, 8, v_extlen);
DBMS_SQL.COLUMN_VALUE (cur, 9, v_contents);
DBMS_SQL.COLUMN_VALUE (cur, 10, v_logging);
DBMS_SQL.COLUMN_VALUE (cur, 11, v_extman);
DBMS_SQL.COLUMN_VALUE (cur, 12, v_alloc);
DBMS_SQL.COLUMN_VALUE (cur, 13, v_plugged);
DBMS_SQL.COLUMN_VALUE (cur, 14, v_blksize);
DBMS_SQL.COLUMN_VALUE (cur, 15, v_segman);
END;
ELSIF SUBSTR(v_version, 1, 3) = '9.2' THEN
BEGIN
DBMS_SQL.COLUMN_VALUE (cur, 8, v_extlen);
DBMS_SQL.COLUMN_VALUE (cur, 9, v_contents);
DBMS_SQL.COLUMN_VALUE (cur, 10, v_logging);
DBMS_SQL.COLUMN_VALUE (cur, 11, v_extman);
DBMS_SQL.COLUMN_VALUE (cur, 12, v_alloc);
DBMS_SQL.COLUMN_VALUE (cur, 13, v_plugged);
DBMS_SQL.COLUMN_VALUE (cur, 14, v_blksize);
DBMS_SQL.COLUMN_VALUE (cur, 15, v_segman);
DBMS_SQL.COLUMN_VALUE (cur, 16, v_flogging);
END;
END IF;

DBMS_OUTPUT.PUT_LINE ('Prompt .');
DBMS_OUTPUT.PUT_LINE ('Prompt Creating tablespace ' || v_tbsname || '...');

v_ltt := FALSE;

IF substr(v_version, 1, 3) IN ('8.1', '9.0', '9.2') THEN
IF v_contents = 'TEMPORARY' AND v_extman = 'LOCAL' THEN
v_ltt := TRUE;
END IF;
END IF;

IF v_contents = 'UNDO' THEN
DBMS_OUTPUT.PUT_LINE ('CREATE UNDO TABLESPACE ' || v_tbsname);
ELSIF v_ltt = TRUE THEN
DBMS_OUTPUT.PUT_LINE ('CREATE TEMPORARY TABLESPACE ' || v_tbsname);
ELSE
DBMS_OUTPUT.PUT_LINE ('CREATE TABLESPACE '|| v_tbsname);
END IF;

FOR rec_df IN c_df (v_tbsname) LOOP
BEGIN

IF c_df%ROWCOUNT = 1 THEN
IF v_ltt THEN
l_str := 'TEMPFILE';
ELSE
l_str := 'DATAFILE';
END IF;
ELSE
l_str := ',';
END IF;

DBMS_OUTPUT.PUT_LINE (l_str||' '
||chr(39)||rec_df.file_name||chr(39)
||' SIZE '||rec_df.bytes||' REUSE ');

IF rec_df.maxextend = 4194302 THEN
m_str := 'UNLIMITED';
ELSE
m_str := to_char(rec_df.maxextend * v_bs);
END IF;

IF rec_df.maxextend IS NOT NULL THEN
DBMS_OUTPUT.PUT_LINE ('AUTOEXTEND ON NEXT ' ||
TO_CHAR (rec_df.inc * v_bs)||' MAXSIZE '|| m_str);
END IF;
END;

END LOOP;

IF v_blksize IS NOT NULL THEN
DBMS_OUTPUT.PUT_LINE ('BLOCKSIZE ' || v_blksize);
END IF;

IF v_logging IS NOT NULL THEN
DBMS_OUTPUT.PUT_LINE (v_logging);
END IF;

IF v_flogging = 'YES' THEN
DBMS_OUTPUT.PUT_LINE ('FORCE LOGGING');
END IF;

IF v_extman <> 'LOCAL' THEN
BEGIN
DBMS_OUTPUT.PUT_LINE ('DEFAULT STORAGE (INITIAL ' || v_initial);
IF v_next IS NOT NULL THEN
DBMS_OUTPUT.PUT_LINE (' NEXT ' || v_next);
END IF;

IF v_minext IS NOT NULL THEN
DBMS_OUTPUT.PUT_LINE (' MINEXTENTS ' || v_minext);
END IF;

IF v_maxext IS NOT NULL THEN
IF v_pctinc IS NULL THEN
DBMS_OUTPUT.PUT_LINE (' MAXEXTENTS ' || v_maxext || ')');
ELSE
DBMS_OUTPUT.PUT_LINE (' MAXEXTENTS ' || v_maxext);
END IF;
END IF;

IF v_pctinc IS NOT NULL THEN
DBMS_OUTPUT.PUT_LINE (' PCTINCREASE '|| v_pctinc || ')');
END IF;
END;
END IF;

DBMS_OUTPUT.PUT_LINE (v_status);

IF v_ltt = FALSE AND v_contents = 'TEMPORARY' THEN
DBMS_OUTPUT.PUT_LINE ('TEMPORARY');
END IF;

IF v_extman = 'LOCAL' AND v_alloc = 'SYSTEM' THEN
DBMS_OUTPUT.PUT_LINE ('EXTENT MANAGEMENT LOCAL AUTOALLOCATE');
END IF;

IF v_extman = 'LOCAL' AND v_alloc = 'UNIFORM' THEN
DBMS_OUTPUT.PUT_LINE ('EXTENT MANAGEMENT LOCAL UNIFORM SIZE ' ||
v_initial);
END IF;

IF v_segman = 'AUTO' THEN
DBMS_OUTPUT.PUT_LINE ('SEGMENT SPACE MANAGEMENT AUTO');
END IF;

DBMS_OUTPUT.PUT_LINE ('/');

DBMS_OUTPUT.NEW_LINE;

END;

END LOOP;

DBMS_SQL.CLOSE_CURSOR(cur);

EXCEPTION
WHEN OTHERS THEN
DBMS_SQL.CLOSE_CURSOR(cur);

END;
/

spool off

Prompt
Prompt Script create_tablespaces.sql generated.
Prompt

set verify on
set feedback on
set pagesize 30 head on lines 100
set termout on trimspool on
set serveroutput off
