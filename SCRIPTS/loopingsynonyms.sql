set serveroutput on format wrap
prompt
declare
    connect_by_loop exception;
    pragma exception_init(connect_by_loop,-1436);
    hold_prev_synonym_name    user_synonyms.synonym_name%type;
begin
    dbms_output.put_line('Synonym Hierarchy');
    dbms_output.put_line('----------------------------------------');
    for x in (select lpad(' ',level * 3) || synonym_name a
            ,synonym_name b
            from user_synonyms
         connect by prior synonym_name = table_name
           start with synonym_name = 'S3') loop
        hold_prev_synonym_name := x.b;
        dbms_output.put_line(x.a);
    end loop;
    exception
        when connect_by_loop then
            dbms_output.put_line(
                 'Error: connect-by loop following "'
                ||hold_prev_synonym_name||'"');
end;
/