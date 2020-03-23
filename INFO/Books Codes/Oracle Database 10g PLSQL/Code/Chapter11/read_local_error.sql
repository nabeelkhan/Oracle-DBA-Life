/*
 * read_local_error.sql
 * Chapter 11, Oracle10g PL/SQL Programming
 * by Ron Hardman, Michael McLaughlin and Scott Urman
 *
 * This script uses DBMS_PIPE to write a local message to
 * the implicit anonymous session pipe. It has the following
 * characteristics:
 *
 * - It can only be accessed by a user that is granted
 *   execute permission on DBMS_PIPE.
 * - It is read implicitly by a session call to the 
 *   DBMS_PIPE.UNPACK_MESSAGE procedure.
 * - It is anonymous in the sense that you cannot see its
 *   name or address it by name.
 * - You clear the contents of the anonymous local pipe by
 *   executing the DBMS_PIPE.RESET_BUFFER procedure.
 * - It must be run from the same local directory as the
 *   write_local.sql and read_local.sql programs.
 */

SET ECHO ON
SET SERVEROUTPUT ON SIZE 1000000

-- Ensure you put something in the local buffer.
@write_local.sql

-- Run a DBMS_PIPE.RECEIVE_MESSAGE call to empty the local buffer.
SELECT   DBMS_PIPE.RECEIVE_MESSAGE('Nowhere',0)
FROM     dual;

@read_local.sql
