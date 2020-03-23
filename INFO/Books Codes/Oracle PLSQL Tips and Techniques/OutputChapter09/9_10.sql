-- ***************************************************************************
-- File: 9_10.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 9_10.lis

SELECT TO_CHAR(SHARABLE_MEM / 1000 ,'999999') SZ,
       DECODE(KEPT_VERSIONS,0,'      ',
       RPAD('YES(' || TO_CHAR(KEPT_VERSIONS)  || ')' ,6)) KEEPED,
       RAWTOHEX(ADDRESS) || ','  || TO_CHAR(HASH_VALUE)  NAME,
       SUBSTR(SQL_TEXT,1,354) EXTRA, 1 ISCURSOR   
FROM   V$SQLAREA  
WHERE  SHARABLE_MEM > &min_ksize * 1000   
UNION 
SELECT TO_CHAR(SHARABLE_MEM / 1000 ,'999999') SZ,
       DECODE(KEPT,'YES','YES   ','      ') KEEPED,
       OWNER || '.'  || NAME  || 
       LPAD(' ',29 - (LENGTH(OWNER) + LENGTH(NAME) ) )  || 
       '('  || TYPE  || ')'  NAME, NULL  EXTRA, 0 ISCURSOR   
FROM   V$DB_OBJECT_CACHE V  
WHERE  SHARABLE_MEM > &min_ksize * 1000  
ORDER BY 1 DESC;

SPOOL OFF
