SELECT LE.LESEQ CURRENT_LOG_SEQUENCE#,100*CP.CPODR_BNO/LE.LESIZ PERCENTAGE_FULL
FROM X$KCCCP CP,X$KCCLE LE
WHERE LE.LESEQ =CP.CPODR_SEQ
/
