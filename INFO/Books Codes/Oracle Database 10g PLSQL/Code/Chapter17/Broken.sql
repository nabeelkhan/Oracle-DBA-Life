/*
 * Broken.sql
 * Chapter 17, Oracle10g PL/SQL Programming
 * by Ron Hardman, Mike McLaughlin, Scott Urman
 *
 * This script tests the DBMS_JOB.BROKEN procedure
 */

SET VERIFY OFF

SET VERIFY OFF
UNDEFINE job_number

exec CLEAN_SCHEMA.jobs
exec CLEAN_SCHEMA.procs
exec CLEAN_SCHEMA.tables

PROMPT
PROMPT Create email_tbl to hold e-mail details
PROMPT

CREATE TABLE email_tbl (
	EMAILID NUMBER(10) 
	      CONSTRAINT emailid_pk PRIMARY KEY,
	SENDER VARCHAR2(100 CHAR) 
	      NOT NULL,
	RECIPIENTS VARCHAR2(4000 CHAR) 
	      NOT NULL,
	CC VARCHAR2(4000),
	BCC VARCHAR2(4000),
	SUBJECT VARCHAR2(50),
	MESSAGE VARCHAR2(4000),
	ATTACHMENT VARCHAR2(4000),
	DATE_LOGGED TIMESTAMP DEFAULT SYSTIMESTAMP,
	DATE_SENT TIMESTAMP);

PROMPT
PROMPT Insert four sample e-mails -- modify if you wish to receive e-mails
PROMPT

INSERT INTO email_tbl
   VALUES (1, 'email1@myemail.com', 'email1@youremail.com', 
           'email1@someonesemail.com', 'email1@theotheremail.com',
           'Subject 1', 'This is the message for e-mail 1',
           'This is inline attachment 1', null, null);

INSERT INTO email_tbl
   VALUES (2, 'email2@myemail.com', 'email2@youremail.com', 
           'email2@someonesemail.com', 'email2@theotheremail.com',
           'Subject 2', 'This is the message for e-mail 2',
           'This is inline attachment 2', null, null);

INSERT INTO email_tbl
   VALUES (3, 'email3@myemail.com', 'email3@youremail.com', 
           'email3@someonesemail.com', 'email3@theotheremail.com',
           'Subject 3', 'This is the message for e-mail 3',
           'This is inline attachment 3', null, null);

INSERT INTO email_tbl
   VALUES (4, 'email4@myemail.com', 'email4@youremail.com', 
           'email4@someonesemail.com', 'email4@theotheremail.com',
           'Subject 4', 'This is the message for e-mail 4',
           'This is inline attachment 4', null, null);


INSERT INTO email_tbl
   VALUES (5, 'email5@myemail.com', 'email5@youremail.com', 
           'email5@someonesemail.com', 'email5@theotheremail.com',
           'Subject 5', 'This is the message for e-mail 5',
           'This is inline attachment 5', null, systimestamp);


INSERT INTO email_tbl
   VALUES (6, 'email6@myemail.com', 'email6@youremail.com', 
           'email6@someonesemail.com', 'email6@theotheremail.com',
           'Subject 6', 'This is the message for e-mail 6',
           'This is inline attachment 6', null, systimestamp);

COMMIT;

PROMPT 
PROMPT Create a package called email_manager to send e-mail messages
PROMPT

CREATE OR REPLACE PACKAGE email_manager
IS

   PROCEDURE smtp (i_host_string VARCHAR2);
   PROCEDURE inline_email;

END;
/



CREATE OR REPLACE PACKAGE BODY email_manager
IS

PROCEDURE smtp (i_host_string VARCHAR2)
AS

   v_host_string VARCHAR2(500) :=
                      i_host_string;
   v_conn_string UTL_SMTP.CONNECTION;

   CURSOR email_cur
   IS
   SELECT *
   FROM email_tbl
   WHERE DATE_SENT IS NULL;

BEGIN
   
   FOR y IN email_cur
   LOOP
      UTL_SMTP.HELO(v_conn_string, v_host_string);
      UTL_SMTP.MAIL(v_conn_string, y.sender);
      UTL_SMTP.RCPT(v_conn_string, y.recipients);
      UTL_SMTP.OPEN_DATA(v_conn_string);
      UTL_SMTP.WRITE_DATA(v_conn_string, y.message);
      UTL_SMTP.CLOSE_DATA(v_conn_string);
      UTL_SMTP.QUIT(v_conn_string);

      UPDATE email_tbl
      SET date_sent = systimestamp
      WHERE emailid = y.emailid;
   END LOOP;

   COMMIT;

EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
END smtp;

PROCEDURE inline_email
AS

   CURSOR email_cur
   IS
   SELECT * 
   FROM email_tbl
   WHERE DATE_SENT IS NULL;

BEGIN

   FOR y IN email_cur
   LOOP
      UTL_MAIL.SEND_ATTACH_VARCHAR2 (
         SENDER => y.sender,
         RECIPIENTS => y.recipients,
         CC => y.cc,
         BCC => y.bcc,
         SUBJECT => y.subject,
         MESSAGE => y.message,
         ATTACHMENT => y.attachment,
         ATT_INLINE => TRUE);

      UPDATE email_tbl
      SET date_sent = systimestamp
      WHERE emailid = y.emailid;
   END LOOP;

   COMMIT;

EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
END inline_email;

END;
/

PROMPT
PROMPT This procedure retrieves details about jobs
PROMPT

CREATE OR REPLACE PROCEDURE get_job_details(
   i_job_number IN NUMBER,
   cv_job_details IN OUT SYS_REFCURSOR)
IS
BEGIN
   OPEN cv_job_details FOR
   SELECT job, schema_user schema, 
          to_char(next_date, 'dd-mon-yyyy hh24:mi:ss') NEXT_DATE, 
          interval, what, broken
   FROM user_jobs
   WHERE job = i_job_number;
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
END get_job_details;
/



SET PAGES 999
COL what FORMAT A40
SELECT job, what
FROM user_jobs;

PROMPT
PROMPT DBMS_JOB.BROKEN examples
PROMPT


BEGIN

   DBMS_JOB.BROKEN(job => &&job_number, 
                   broken => TRUE, 
                   next_date => sysdate);
   COMMIT;

END;
/


PROMPT
PROMPT Check the USER_JOBS view
PROMPT

VARIABLE v_job_details REFCURSOR
EXEC GET_JOB_DETAILS(&&job_number, :v_job_details)

COL schema_user FORMAT A15
COL next_date FORMAT A20
COL interval FORMAT A60
COL what FORMAT A4000
SET PAGES 9999
PRINT v_job_details

PROMPT
PROMPT Look at the output and note the change to the BROKEN status.
PROMPT  It used to be 'N' and it is now 'Y'...
PROMPT