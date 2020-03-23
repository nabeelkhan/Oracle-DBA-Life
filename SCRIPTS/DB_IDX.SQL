REM FILE NAME:  db_inx.sql
REM LOCATION:   Object Management\Indexes\Reports
REM FUNCTION:   Report on indexes
REM TESTED ON:  8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   dba_indexes, dba_ind_columns
REM
REM 
REM******************** NK ********************


COLUMN owner                    FORMAT a8       HEADING 'Index|Owner'
COLUMN index_name               FORMAT a27      HEADING 'Index'
COLUMN index_type               FORMAT a6       HEADING 'Type|Index'
COLUMN table_owner              FORMAT a8       HEADING 'Table|Owner'
COLUMN table_name               FORMAT a24      HEADING 'Table Name'
COLUMN table_type               FORMAT a10      HEADING 'Table|Type'
COLUMN uniqueness               FORMAT a1       HEADING 'U|n|i|q|u|e'
COLUMN tablespace_name          FORMAT a13      HEADING 'Tablespace'
COLUMN column_name              FORMAT a25      HEADING 'Col. Name'
SET PAGES 58 LINES 130 FEEDBACK OFF VERIFY OFF
BREAK ON owner
START title132 'Expandeded Index Report'
SPOOL LST\DB_IDX.LST
SELECT   a.owner, a.index_name, a.index_type, a.table_owner, a.table_name,
         a.table_type,
         DECODE (a.uniqueness, 'UNIQUE', 'U', 'NONUNIQUE', 'N') uniqueness,
         a.tablespace_name, b.column_name
    FROM dba_indexes a, dba_ind_columns b
    WHERE owner LIKE UPPER ('%&owner%') 
--     WHERE owner in ('PREMPROD','FINAL7','FIN7LIFE','LIFEPROD')
     AND a.owner = b.index_owner(+)
     AND a.index_name = b.index_name(+)
ORDER BY owner, index_type;
SPOOL OFF

