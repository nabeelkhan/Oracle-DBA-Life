rem -----------------------------------------------------------------------
rem Filename:   compall.sql
rem Purpose:    Compile all invalid database objects
rem             Run this script after each database upgrade or whenever
rem             required.
rem Notes:      If the dependencies between objects are complicated, you can
rem             end up re-compiling it many times, as recompiling some
rem             invalidates others. This script uses dyamic SQL, and
rem             recompile objects based on reverse dependency order.
rem Date:       27-Aug-2006
rem Author:     Nabeel Khan Oracle 8.1.7 to 10g
rem -----------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE RECOMPILE_SCHEMA
IS
  v_Type USER_OBJECTS.OBJECT_TYPE%TYPE;
  v_Name USER_OBJECTS.OBJECT_NAME%TYPE;
  v_Stat USER_OBJECTS.STATUS%TYPE;

  CURSOR c_Obj
  IS
    SELECT  BASE
    FROM  (SELECT A.OBJECT_ID BASE
           ,      B.OBJECT_ID REL
           FROM   USER_OBJECTS A
              ,      USER_OBJECTS B
              ,      SYS.DEPENDENCY$  C
           WHERE  A.OBJECT_ID = C.D_OBJ#
           AND    B.OBJECT_ID = C.P_OBJ#
           AND    A.OBJECT_TYPE IN ('PACKAGE',
                                    'PROCEDURE',
                                    'FUNCTION',
                                    'PACKAGE BODY',
                                  --  'VIEW', 
                                    'TRIGGER')
           AND    B.OBJECT_TYPE IN ('PACKAGE',
                                    'PROCEDURE',
                                    'FUNCTION',
                                    'PACKAGE BODY',
                                  --  'VIEW', 
                                    'TRIGGER')
            AND    NOT A.OBJECT_NAME = B.OBJECT_NAME) OBJECTS
    CONNECT BY BASE = PRIOR REL
    GROUP   BY BASE
    ORDER   BY MAX(LEVEL) DESC;
BEGIN
  -- loop through all objects in order of dependancy.
  FOR c_Row IN c_Obj
  LOOP
    -- select the objects attributes (type, name & status).
    SELECT OBJECT_TYPE
    ,      OBJECT_NAME
    ,      STATUS
    INTO   v_Type
    ,      v_Name
    ,      v_Stat
    FROM   USER_OBJECTS
    WHERE  OBJECT_ID = c_Row.BASE;

    -- if the OBJECT is INVALID, recompile it.
    IF v_Stat = 'INVALID' THEN
      DBMS_DDL.ALTER_COMPILE(v_Type, USER, v_Name);
    END IF;
  END LOOP;

  -- Recompile all remaining INVALID OBJECTS (all those without dependencies).
  FOR c_Row IN ( SELECT OBJECT_TYPE
             ,      OBJECT_NAME
             FROM   USER_OBJECTS
             WHERE  STATUS = 'INVALID'
             AND    OBJECT_TYPE IN ('PACKAGE',
                                    'PROCEDURE',
                                    'FUNCTION',
                                    'TRIGGER',
                                    'PACKAGE BODY',
                                 --   'VIEW', 
                                    'TRIGGER') )
  LOOP
    DBMS_DDL.ALTER_COMPILE(c_Row.OBJECT_TYPE, USER, c_Row.OBJECT_NAME);
  END LOOP;
END RECOMPILE_SCHEMA;
