REM FILE NAME: 	cbo_stats.sql
REM LOCATION:   Application Tuning\Reports
REM FUNCTION:   Statistics used by Cost Base Optimizer
REM TESTED ON:  8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:
REM
REM This is a part of the Knowledge Xpert for Oracle Administration library. 
REM Copyright (C) 2001 Quest Software 
REM All rights reserved. 
REM
REM******************** Knowledge Xpert for Oracle Administration ********************


SET echo off
SET scan on
SET lines 132
SET pages 66
SET verify off
SET feedback off
SET termout off
SET termout on
COLUMN uservar new_value Table_Owner noprint
COLUMN TABLE_NAME heading "Tables owned by &Table_Owner" format a30

SELECT USER uservar
  FROM DUAL;
SELECT   table_name
    FROM user_tables
ORDER BY 1
/
UNDEFINE table_name
UNDEFINE owner
PROMPT

ACCEPT owner prompt 'Please enter Name of Table Owner (Null = &Table_Owner): '
ACCEPT table_name  prompt 'Please enter Table Name to show Statistics for: '
COLUMN TABLE_NAME heading "Table|Name" format a15
COLUMN NUM_ROWS heading "Number|of Rows" format 9,999,990
COLUMN BLOCKS heading "Blocks" format 999,990
COLUMN EMPTY_BLOCKS heading "Empty|Blocks" format 999,990
COLUMN AVG_SPACE heading "Average|Space" format 9,990
COLUMN CHAIN_CNT heading "Chain|Count" format 990
COLUMN AVG_ROW_LEN heading "Average|Row Len" format 990
COLUMN COLUMN_NAME  heading "Column|Name" format a25
COLUMN NULLABLE heading Null|able format a4
COLUMN NUM_DISTINCT heading "Distinct|Values" format 9,999,990
COLUMN DENSITY heading "Density" format 990
COLUMN INDEX_NAME heading "Index|Name" format a15
COLUMN UNIQUENESS heading "Unique" format a9
COLUMN BLEV heading "B|Tree|Level" format 90
COLUMN LEAF_BLOCKS heading "Leaf|Blks" format 9,999,990
COLUMN DISTINCT_KEYS heading "Distinct|Keys" format 9,999,990
COLUMN AVG_LEAF_BLOCKS_PER_KEY heading "Average|Leaf Blocks|Per Key" format 99,990
COLUMN AVG_DATA_BLOCKS_PER_KEY heading "Average|Data Blocks|Per Key" format 99,990
COLUMN CLUSTERING_FACTOR heading "Cluster|Factor" format 9,999,990
COLUMN COLUMN_POSITION heading "Col|Pos" format 990
COLUMN col heading "Column|Details" format a24
COLUMN COLUMN_LENGTH heading "Col|Len" format 990

SELECT table_name, num_rows, blocks, empty_blocks, avg_space, chain_cnt,
       avg_row_len
  FROM dba_tables
 WHERE owner = UPPER (NVL ('&&Owner', USER))
   AND table_name = UPPER ('&&Table_name')
/
SELECT column_name,
          DECODE (
             t.data_type,
             'NUMBER',    t.data_type
                       || '('
                       || DECODE (
                             t.data_precision,
                             NULL,    t.data_length
                                   || ')',
                                t.data_precision
                             || ','
                             || t.data_scale
                             || ')'
                          ),
             'DATE', t.data_type,
             'LONG', t.data_type,
             'LONG RAW', t.data_type,
             'ROWID', t.data_type,
             'MLSLABEL', t.data_type,
                t.data_type
             || '('
             || t.data_length
             || ')'
          )
       || ' '
       || DECODE (t.nullable, 'N', 'NOT NULL', 'n', 'NOT NULL', NULL) col,
       num_distinct, density
  FROM dba_tab_columns t
 WHERE table_name = UPPER ('&Table_name')
   AND owner = UPPER (NVL ('&Owner', USER))
/
SELECT index_name, uniqueness, blevel blev, leaf_blocks, distinct_keys,
       avg_leaf_blocks_per_key, avg_data_blocks_per_key, clustering_factor
  FROM dba_indexes
 WHERE table_name = UPPER ('&Table_name')
   AND table_owner = UPPER (NVL ('&Owner', USER))
/
BREAK on index_name

SELECT   i.index_name, i.column_name, i.column_position,
            DECODE (
               t.data_type,
               'NUMBER',    t.data_type
                         || '('
                         || DECODE (
                               t.data_precision,
                               NULL,    t.data_length
                                     || ')',
                                  t.data_precision
                               || ','
                               || t.data_scale
                               || ')'
                            ),
               'DATE', t.data_type,
               'LONG', t.data_type,
               'LONG RAW', t.data_type,
               'ROWID', t.data_type,
               'MLSLABEL', t.data_type,
                  t.data_type
               || '('
               || t.data_length
               || ')'
            )
         || ' '
         || DECODE (t.nullable, 'N', 'NOT NULL', 'n', 'NOT NULL', NULL) col
    FROM dba_ind_columns i, dba_tab_columns t
   WHERE i.table_name = UPPER ('&Table_name')
     AND owner = UPPER (NVL ('&Owner', USER))
     AND i.table_name = t.table_name
     AND t.column_name = i.column_name
ORDER BY index_name, column_position
/
CLEAR breaks
SET echo on
