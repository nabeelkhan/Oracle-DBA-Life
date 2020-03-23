REM dropcns.sql checked out on 12/22/97 17:05:20 version 1.1 created on 8/25/97 15:36:16
set define '^'
select
'PROMPT Dropping Constraint:  ^2( ^3 )' buff,
'ALTER TABLE ^2 DROP CONSTRAINT ^3;' buff
from dual;
