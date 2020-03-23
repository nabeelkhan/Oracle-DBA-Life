/*
 * TypeEvolution.sql
 * Chapter 14, Oracle10g PL/SQL Programming
 * by Ron Hardman, Mike McLaughlin, Scott Urman
 *
 * This script demonstrates type evolution for object maintenance.
 */

exec clean_schema.synonyms
exec clean_schema.tables
exec clean_schema.objects

CREATE OR REPLACE TYPE music_person_obj AS OBJECT (
   first_name   VARCHAR2 (50 CHAR),
   last_name    VARCHAR2 (50 CHAR)
)
FINAL INSTANTIABLE;
/

CREATE OR REPLACE TYPE music_obj AS OBJECT (
   style      VARCHAR2 (50 CHAR),
   composer   music_person_obj,
   artist     music_person_obj
)
NOT FINAL INSTANTIABLE;
/

CREATE OR REPLACE TYPE cd_obj
UNDER music_obj (
   title           VARCHAR2 (50 CHAR),
   date_released   DATE,
   CONSTRUCTOR FUNCTION cd_obj (
      artist          music_person_obj,
      title           VARCHAR2,
      date_released   DATE
   )
      RETURN SELF AS RESULT,
   MEMBER PROCEDURE show_cd
)
FINAL INSTANTIABLE;
/

CREATE OR REPLACE TYPE BODY cd_obj
AS
   CONSTRUCTOR FUNCTION cd_obj (
      artist          music_person_obj,
      title           VARCHAR2,
      date_released   DATE
   )
      RETURN SELF AS RESULT
   IS
   BEGIN
      SELF.artist := artist;
      SELF.title := title;
      SELF.date_released := date_released;
      RETURN;
   END cd_obj;
   MEMBER PROCEDURE show_cd
   IS
   BEGIN
      DBMS_OUTPUT.put_line ('MUSIC TITLES IN BOOKSTORE1');
      DBMS_OUTPUT.put_line ('==========================');
      DBMS_OUTPUT.put_line ('TITLE: ' || SELF.title);
      DBMS_OUTPUT.put_line (   'ARTIST: '
                            || SELF.artist.first_name
                            || ' '
                            || SELF.artist.last_name
                           );
      DBMS_OUTPUT.put_line ('DATE RELEASED: ' || SELF.date_released);
   END show_cd;
END;
/

-- Test script
/******************************************
*
* SET SERVEROUTPUT ON SIZE 1000000
*
* DECLARE
*    v_person   music_person_obj := music_person_obj ('Chuck', 'Soulful');
*    v_cd       cd_obj        := cd_obj (v_person, 'GMAN Blues', '01-JUN-1995');
* BEGIN
*    v_cd.show_cd;
* END;
* /
* 
*******************************************/



