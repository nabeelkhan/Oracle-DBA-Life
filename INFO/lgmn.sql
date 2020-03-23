EXECUTE dbms_logmnr.add_logfile('/u02/ARCH/1564-orakic.arc', DBMS_LOGMNR.NEW);

EXECUTE DBMS_LOGMNR.ADD_LOGFILE('/u02/ARCH/1565-orakic.arc');

EXECUTE dbms_logmnr.add_logfile('/u02/ARCH/1566-orakic.arc');

EXECUTE dbms_logmnr.add_logfile('/u02/ARCH/1567-orakic.arc');

EXECUTE dbms_logmnr.add_logfile('/u02/ARCH/1568-orakic.arc');

EXECUTE dbms_logmnr.add_logfile('/u02/ARCH/1569-orakic.arc');


/* A select on v$logmnr_contents fails with: ORA-03113: end-of-file on communication channel
AND  Trace file and core dump written IF DICTIONARY FILE IS USED */

EXECUTE DBMS_LOGMNR.START_LOGMNR( -
> DICTFILENAME =>'/ora/oracle/logminer/dictionary.ora');





 execute DBMS_LOGMNR.START_LOGMNR(options => -
dbms_logmnr.dict_from_online_catalog);



execute dbms_logmnr.start_logmnr(options => -
dbms_logmnr.dict_from_online_catalog + dbms_logmnr.skip_corruption + -
dbms_logmnr.print_pretty_sql);


SELECT operation, sql_redo FROM v$logmnr_contents;



EXECUTE DBMS_LOGMNR.END_LOGMNR;