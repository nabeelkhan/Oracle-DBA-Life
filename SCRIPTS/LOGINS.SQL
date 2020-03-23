COLUMN  L_PREMIA_USER  FORMAT A10
COLUMN  L_LOGIN_TIME   FORMAT A8
COLUMN  L_LOGOUT_TIME  FORMAT A8
COLUMN  L_DEPT_NO      FORMAT A2
COLUMN  L_SID          FORMAT 999
COLUMN  L_SRNO         FORMAT 99999
SELECT  /*+ RULE */
   L_PREMIA_USER          ,
        L_DEPT_NO              ,
        L_LOGIN_TIME           ,
        L_LOGOUT_TIME          ,
        L_LOGIN_DT             ,
        L_SID                  ,
        L_SRNO                 ,
        L_AUDSID               ,
        USERNAME
FROM    premprod.LOGINS, V$SESSION
WHERE   TO_CHAR(L_LOGIN_DT,'DD-MON-YY') = TO_CHAR(SYSDATE,'DD-MON-YY')
and     L_AUDSID =  AUDSID (+)
AND     STATUS  != 'KILLED'
AND     L_LOGOUT_TIME IS NULL
AND  L_PREMIA_USER LIKE '%&USER_NAME%'
ORDER BY L_PREMIA_USER,  L_DEPT_NO

/
