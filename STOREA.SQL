REM  Edit and/or remove the following  CREATE TABLE
REM  statement as your needs dictate.
CREATE TABLE  nk_tkprof_table
(
 date_of_insert                       DATE   
,cursor_num                           NUMBER 
,depth                                NUMBER 
,user_id                              NUMBER 
,parse_cnt                            NUMBER 
,parse_cpu                            NUMBER 
,parse_elap                           NUMBER 
,parse_disk                           NUMBER 
,parse_query                          NUMBER 
,parse_current                        NUMBER 
,parse_miss                           NUMBER 
,exe_count                            NUMBER 
,exe_cpu                              NUMBER 
,exe_elap                             NUMBER 
,exe_disk                             NUMBER 
,exe_query                            NUMBER 
,exe_current                          NUMBER 
,exe_miss                             NUMBER 
,exe_rows                             NUMBER 
,fetch_count                          NUMBER 
,fetch_cpu                            NUMBER 
,fetch_elap                           NUMBER 
,fetch_disk                           NUMBER 
,fetch_query                          NUMBER 
,fetch_current                        NUMBER 
,fetch_rows                           NUMBER 
,ticks                                NUMBER 
,sql_statement                        LONG 
);
INSERT INTO nk_tkprof_table VALUES
(
  SYSDATE, 1, 0, 59, 0, 0, 0, 0, 0, 0, 0 
, 1, 0, 0, 0, 0, 0, 0, 0 
, 0, 0, 0, 0, 0, 0, 0, 18446744073709549663 
, 'ALTER SESSION SET SQL_TRACE = TRUE
');
INSERT INTO nk_tkprof_table VALUES
(
  SYSDATE, 2, 1, 0, 1, 0, 0, 0, 0, 0, 0 
, 1, 0, 0, 0, 3, 0, 0, 0 
, 0, 0, 0, 0, 0, 0, 0, 14430664 
, 'update object_usage set flags=flags+1 where obj#=:1 and bitand(flags, 1)=0
');
INSERT INTO nk_tkprof_table VALUES
(
  SYSDATE, 1, 0, 59, 1, 33333, 116211, 0, 0, 0, 1 
, 1, 0, 0, 0, 0, 0, 0, 0 
, 1, 14150000, 37397461, 33811, 122064, 74, 0, 37400390 
, 'SELECT ALL PREMPROD.PM_DIVISION.DIVN_BL_NAME, PREMPROD.PT_POLICY.POL_NO,
PREMPROD.PT_POLICY.POL_CUST_CODE, PREMPROD.PT_POLICY.POL_ASSURED_NAME,
PREMPROD.PT_POLICY_SCHEDULE.PSC_FIELD_2, PREMPROD.PT_POLICY_SCHEDULE.PSC_FIELD_4,
PREMPROD.PT_POLICY_SCHEDULE.PSC_FIELD_7, PREMPROD.PT_POLICY_SCHEDULE.PSC_FIELD_8,
PREMPROD.PT_POLICY_SCHEDULE.PSC_FIELD_9, PREMPROD.PT_POLICY_SCHEDULE.PSC_FIELD_3,
PREMPROD.PT_POLICY.POL_NL_PERIOD_DESC
FROM PREMPROD.PM_DIVISION, PREMPROD.PT_POLICY_SCHEDULE, PREMPROD.PT_POLICY
WHERE (PREMPROD.PT_POLICY.POL_PDS_CODE IN (''080'', ''088'', ''089'')
 AND PREMPROD.PT_POLICY_SCHEDULE.PSC_FIELD_3 LIKE ''%278091758616%'')
 AND  ((PREMPROD.PT_POLICY_SCHEDULE.PSC_POL_SYS_ID=PREMPROD.PT_POLICY.POL_SYS_ID)
 AND (PREMPROD.PM_DIVISION.DIVN_CODE=PREMPROD.PT_POLICY.POL_DIVN_CODE))
ORDER BY PREMPROD.PM_DIVISION.DIVN_BL_NAME ASC,
PREMPROD.PT_POLICY.POL_NO ASC, PREMPROD.PT_POLICY.POL_CUST_CODE ASC
');
INSERT INTO nk_tkprof_table VALUES
(
  SYSDATE, 1, 0, 59, 1, 0, 22461, 0, 0, 0, 0 
, 1, 0, 976, 0, 0, 0, 0, 0 
, 0, 0, 0, 0, 0, 0, 0, 25404297 
, 'ALTER SESSION SET SQL_TRACE = FALSE
');
