-- ***************************************************************************
-- File: 10_6.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 10_6.lis

-- Create the 3 roles
CREATE ROLE entry;
CREATE ROLE maintenance;
CREATE ROLE manager;

-- Assign object privileges to roles
GRANT SELECT, INSERT ON s_employee TO entry;
GRANT SELECT, INSERT ON s_customer TO entry;
GRANT SELECT, UPDATE ON s_employee TO maintenance;
GRANT SELECT, UPDATE ON s_customer TO maintenance;
GRANT EXECUTE ON validate_salary TO maintenance;
GRANT SELECT, INSERT, UPDATE, DELETE ON s_employee TO manager;
GRANT SELECT, INSERT, UPDATE, DELETE ON s_customer TO manager;
GRANT EXECUTE ON validate_salary TO manager;
GRANT EXECUTE ON adjust_salary TO manager;

-- Create users (object privilege) and assign to appropriate role

-- Joe and Lori are entry level users
CREATE USER joe identified by joe;
CREATE USER lori identified by lori;
GRANT CONNECT TO joe, lori;
GRANT entry TO joe, lori;

-- Rich and Brad are maintenance level users
CREATE USER rich identified by rich;
CREATE USER brad identified by brad;
GRANT CONNECT TO rich, brad;
GRANT maintenance TO rich, brad;

-- Regina and Kristen are manager level users
CREATE USER regina identified by regina;
CREATE USER kristen identified by kristen;
GRANT CONNECT TO regina, kristen;
GRANT manager TO regina, kristen;

SPOOL OFF
