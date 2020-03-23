SELECT RPAD(t.name,18,' ') tablespace ,
LPAD(TO_CHAR(CEIL( (SUM(s.blocks)*COUNT(*)) / (SUM(f.blocks) *
POWER(COUNT(DISTINCT(f.file#)),2)) * 100 )),3) Pct ,
LPAD(TO_CHAR(TRUNC(SUM(f.blocks) * t.blocksize *
COUNT(DISTINCT(f.file#)) /
( COUNT(*) * 1024 * 1024 * 1024 ),2)),6) vol_G ,
LPAD(TO_CHAR(SUM(f.blocks) * t.blocksize * COUNT(DISTINCT(f.file#)) /
( COUNT(*) * 1024 * 1024 )),8) volume_M ,
TRUNC(SUM(s.blocks) * t.blocksize /
( 1024 * 1024 * COUNT(DISTINCT(f.file#))),2) taken_M ,
TRUNC( ( SUM(f.blocks) * t.blocksize * COUNT(DISTINCT(f.file#))
/ ( COUNT(*) * 1024 * 1024 ) )
- ( NVL(suM(s.blocks),0) * t.blocksize
/ ( 1024 * 1024 * COUNT(DISTINCT(f.file#)) ) ),2) remain_M
FROM sys.seg$ s, sys.ts$ t, sys.file$ f
WHERE s.ts# (+) = t.ts#
AND f.ts# = t.ts#
AND f.status$ = 2
GROUP BY t.name, t.blocksize
ORDER BY 1
/
