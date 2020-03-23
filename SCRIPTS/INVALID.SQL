REM--Description: 

PROMT This script creates a stored procedure which compiles all object that are INVALID.

REM Code :

CREATE OR REPLACE PROCEDURE REBUILD_INVALID
IS
cursor_handle integer;
feedback integer;
err_msg varchar2(1000);
obj_name varchar2(100);
obj_type varchar2(100);
obj_preff varchar2(20);
alter_statement varchar2(1000);
cursor inv_objects is
select object_name,decode(object_type,'PACKAGE BODY','PACKAGE',object_type),
decode(object_type,'PACKAGE','PACKAGE','PACKAGE BODY','BODY',
)
from user_objects where status='INVALID';

begin
OPEN inv_objects;
LOOP
FETCH inv_objects INTO obj_name,obj_type,obj_preff;
EXIT WHEN inv_objects%NOTFOUND;

cursor_handle:=dbms_sql.open_cursor;

alter_statement:='alter '||obj_type||' '||obj_name||' compile '||obj_preff;

dbms_sql.parse(cursor_handle,alter_statement,dbms_sql.native);
feedback:=dbms_sql.execute(cursor_handle);

dbms_sql.close_cursor(cursor_handle);

END LOOP;
CLOSE inv_objects;
dbms_output.put_line('Success');

exception
when others then
err_msg:=sqlerrm;
dbms_output.put_line(err_msg);

end; 


