rem -----------------------------------------------------------------------
rem Filename:   compall2.sql
rem Purpose:    Compile all invalid database objects
rem             Run this script after each database upgrade or whenever
rem             required.
rem Notes:      If the dependencies between objects are complicated, you can
rem             end up re-compiling it many times, as recompiling some
rem             invalidates others. This script uses dyamic SQL, and
rem             recompile objects based on reverse dependency order.
rem Date:       27-Aug-2006
rem Author:     Nabeel Khan Oracle 8 & 8.1.5
rem -----------------------------------------------------------------------

set serveroutput on size 1000000

declare
   sql_statement varchar2(200);
   cursor_id     number;
   ret_val       number;
begin

   dbms_output.put_line(chr(0));
   dbms_output.put_line('Re-compilation of Invalid Objects');
   dbms_output.put_line('---------------------------------');
   dbms_output.put_line(chr(0));

   for invalid in (select object_type, owner, object_name
                   from   sys.dba_objects o,
                          sys.order_object_by_dependency d
                   where  o.object_id    = d.object_id(+)
                     and  o.status       = 'INVALID'
                     and  o.object_type in ('PACKAGE', 'PACKAGE BODY',
                                            'FUNCTION',
                                            'PROCEDURE', 'TRIGGER',
                                            'VIEW')
                   order  by d.dlevel desc, o.object_type) loop

      if invalid.object_type = 'PACKAGE BODY' then
         sql_statement := 'alter package '||invalid.owner||'.'||invalid.object_name||
                          ' compile body';
      else
         sql_statement := 'alter '||invalid.object_type||' '||invalid.owner||'.'||
                          invalid.object_name||' compile';
      end if;

      /* now parse and execute the alter table statement */
      cursor_id := dbms_sql.open_cursor;
      dbms_sql.parse(cursor_id, sql_statement, dbms_sql.native);
      ret_val := dbms_sql.execute(cursor_id);
      dbms_sql.close_cursor(cursor_id);

      dbms_output.put_line(rpad(initcap(invalid.object_type)||' '||
                                invalid.object_name, 32)||' : compiled');
   end loop;

end;
/
