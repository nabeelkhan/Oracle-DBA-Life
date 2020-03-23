-- ***************************************************************************
-- File: 13_2.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 13_2.lis

COLUMN    segment_name FORMAT a15
SELECT    segment_name, segment_type, COUNT(*), SUM(bytes)
FROM      dba_extents
WHERE     segment_name IN 
          ('COL$', 'DEPENDENCY$', 'ERROR$', 'IDL_CHAR$',
           'IDL_SB4$', 'IDL_UB1$', 'IDL_UB2$', 'LINK$', 'OBJ$',
           'OBJAUTH$', 'SOURCE$', 'SYSAUTH$', 'TRIGGER$',
           'TRIGGERCOL$', 'USER$')
GROUP BY  segment_name, segment_type
ORDER BY  segment_type, segment_name;

SPOOL OFF
