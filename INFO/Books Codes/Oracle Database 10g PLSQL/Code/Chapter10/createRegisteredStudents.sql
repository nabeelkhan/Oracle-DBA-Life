/*
 * createRegisteredStudents.sql
 * Chapter 10, Oracle10g PL/SQL Programming
 * by Ron Hardman, Michael McLaughlin and Scott Urman
 *
 * This script builds the REGISTERED_STUDENTS table.
 */
SET ECHO ON


BEGIN
  FOR i IN (SELECT   null
            FROM     user_tables
            WHERE    table_name = 'REGISTERED_STUDENTS') LOOP
      EXECUTE IMMEDIATE 'DROP TABLE registered_students';
  END LOOP;
END;
/

CREATE TABLE registered_students (
  student_id NUMBER(5) NOT NULL,
  department CHAR(3)   NOT NULL,
  course     NUMBER(3) NOT NULL,
  grade      CHAR(1),
  CONSTRAINT rs_grade
    CHECK (grade IN ('A', 'B', 'C', 'D', 'E')),
  CONSTRAINT rs_student_id
    FOREIGN KEY (student_id) REFERENCES students (id),
  CONSTRAINT rs_department_course
    FOREIGN KEY (department, course) 
    REFERENCES classes (department, course)
  );
