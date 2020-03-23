SELECT TABLE_NAME "Table Name",
       SUM(  DECODE( SUBSTR(DATA_TYPE,1,1),
             'N',     TRUNC( ( DATA_PRECISION + 1 ) / 2, 0 ) + 1 ,
             'D', 7,  DATA_LENGTH     ) ) "Max Length"
FROM ALL_TAB_COLUMNS
WHERE TABLE_NAME='&1'
GROUP BY TABLE_NAME
HAVING SUM(  DECODE( SUBSTR(DATA_TYPE,1,1),
             'N',     TRUNC( ( DATA_PRECISION + 1 ) / 2, 0 ) + 1 ,
             'D', 7,  DATA_LENGTH     ) )     > 0
ORDER BY 2 DESC , 1 
/
