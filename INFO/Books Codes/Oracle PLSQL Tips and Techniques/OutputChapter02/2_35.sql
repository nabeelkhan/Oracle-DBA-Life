-- ***************************************************************************
-- File: 2_35.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 2_35.lis

SET ECHO OFF
PROMPT Input Date prompts for the beginning month and year of the
PROMPT quarter in the format of mmyyyy.
PROMPT
SET ECHO ON
SELECT employee_last_name, start_date
FROM   s_employee
WHERE  start_date BETWEEN TO_DATE('01' || 
                                  '&&input_date','DDMMYYYY')
AND    LAST_DAY(ADD_MONTHS(TO_DATE('01' || 
                                  '&&input_date','DDMMYYYY'),2)));
UNDEFINE input_date

SPOOL OFF
