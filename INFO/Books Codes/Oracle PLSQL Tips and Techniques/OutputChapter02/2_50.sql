-- ***************************************************************************
-- File: 2_50.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 2_50.lis

-- Displays the literal text 'LOGIN Execution' to the screen
PROMPT LOGIN Execution
-- Changes the default SQL*Plus editor
DEFINE_EDITOR=c:\pfe\pfe32.exe
-- Changes the default Oracle DATE display
ALTER SESSION SET nls_date_format='mm/dd/yyyy';
-- Changes the default temporary file to edit
SET EDITFILE "PLUSTEMP.SQL"
-- Sets feedback to display the number of records returned if > 1
SET FEEDBACK 1
-- Sets the size of the page to 23, which will only display the
-- title and column headers every 23 records of output
set pagesize 23
-- Sets pause on, so scrolling will pause every page
set pause ON
-- Sets the pause message to say 'More...'
set pause "More..."
-- Enables DBMS_OUTPUT so all DBMS_OUTPUT.PUT_LINE statements will
-- display in SQL*Plus (the buffer is set to the maximum and 
-- wrapping will not break words)
set serveroutput ON size 1000000 format WORD_WRAPPED
-- Sets timing on, so every SQL statement executed returns a timing
set timing ON

SPOOL OFF
