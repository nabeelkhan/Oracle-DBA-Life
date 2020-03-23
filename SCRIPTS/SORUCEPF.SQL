set heading off
set trimspool on
set feedback off
set echo off
set termout off
set pagesize 1000
create table temp_user_source(name varchar2(30),type varchar2(12),line
number,text varchar2(4000))
/
declare
cursor cu_proceduretext is select name,type,line,text from
user_source where type IN('PROCEDURE' , 'FUNCTION');
V_name varchar2(30);
V_Type varchar2(12);
V_Line number;
V_text varchar2(4000);
begin
open cu_proceduretext;
loop
fetch cu_proceduretext into V_name,V_Type,V_line,V_text;
exit when cu_proceduretext%notfound;
if V_line = 1 then
insert into temp_user_source values(V_name,V_type,V_line,'/');
V_text:=replace(upper(V_text),'PROCEDURE','CREATE OR REPLACE PROCEDURE');
V_text:=replace(upper(V_text),'FUNCTION','CREATE OR REPLACE FUNCTION');
insert into temp_user_source values(V_name,V_type,V_line,V_text);
else
insert into temp_user_source values(V_name,V_type,V_line,V_text);
end if;
end loop;
close cu_proceduretext;
insert into temp_user_source values(V_name,V_type,V_line,'/');
delete from temp_user_source
where rowid in(select min(rowid) from temp_user_source);
end;
/
spool c:\prcscript.txt;
select text from temp_user_source order by name,line;
spool off;
drop table temp_user_source;
set heading on
set feedback on
set echo on
set termout on 