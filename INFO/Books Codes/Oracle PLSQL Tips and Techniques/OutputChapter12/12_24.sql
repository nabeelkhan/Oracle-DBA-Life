-- ***************************************************************************
-- File: 12_24.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 12_24.lis

DECLARE
   CURSOR cur_roles IS
      SELECT granted_role
      FROM   user_role_privs
      ORDER BY granted_role;
BEGIN
   FOR cur_roles_rec IN cur_roles LOOP
      IF DBMS_SESSION.IS_ROLE_ENABLED(cur_roles_rec.granted_role) THEN
         DBMS_OUTPUT.PUT_LINE('Role Enabled: ' ||
            cur_roles_rec.granted_role);
      END IF;
   END LOOP;

SPOOL OFF
