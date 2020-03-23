set termout off
set echo off
define X=NotConnected
define Y=DBNAME

Column Usr New_Value X
Column DBName New_Value Y


Select SYS_CONTEXT('USERENV','SESSION_USER' ) Usr From Dual;

--- The following does not work in 8.1.5 but works in 8.1.6 or above
Select SYS_CONTEXT('USERENV','DB_NAME') DBNAME From Dual;

--- If you are using 8.1.5, use this .
---Select Global_Name DBNAME from Global_Name;

set termout on
set sqlprompt '&X@&Y> '