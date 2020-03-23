-- ***************************************************************************
-- File: 15_8.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 15_8.lis

<FORM METHOD="POST"
ACTION="http://www.nhl.com/nhl/owa/hockey_pass">
Please type the name of the person you wish to search for:
<INPUT TYPE="text" NAME="p_person_txt"><P>
To submit the query, press this button:
<INPUT TYPE="submit" VALUE="Submit Query">. <P>
</FORM>

SPOOL OFF
