REM FILE NAME:  hratio.sql
REM LOCATION:   Database Tuning\Buffer Cache Reports
REM FUNCTION:   Create plot of period hit ratio for 1 day 
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   hit_ratios, hratio2.sql
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


CREATE OR REPLACE PROCEDURE hitratio
IS
   c_date      DATE;
   c_hour      NUMBER        := 0;
   h_ratio     NUMBER (5, 2) := 0;
   con_gets    NUMBER        := 0;
   db_gets     NUMBER        := 0;
   p_reads     NUMBER        := 0;
   stat_name   VARCHAR (64);
   temp_name   VARCHAR (64);
   stat_val    NUMBER        := 0;
   users       NUMBER        := 0;

   CURSOR get_stat (p_name VARCHAR2)
   IS
      SELECT NAME, VALUE
        FROM v$sysstat
       WHERE NAME = p_name;
BEGIN
   SELECT TO_CHAR (SYSDATE, 'DD-MON-YY')
     INTO c_date
     FROM DUAL;

   SELECT TO_CHAR (SYSDATE, 'HH24')
     INTO c_hour
     FROM DUAL;

   stat_name := 'db block gets';
   OPEN get_stat (stat_name);
   FETCH get_stat INTO temp_name, db_gets;
   CLOSE get_stat;
   DBMS_OUTPUT.put_line (   temp_name
                         || ':'
                         || TO_CHAR (db_gets));
   stat_name := 'consistent gets';
   OPEN get_stat (stat_name);
   FETCH get_stat INTO temp_name, con_gets;
   CLOSE get_stat;
   DBMS_OUTPUT.put_line (   temp_name
                         || ':'
                         || TO_CHAR (con_gets));
   stat_name := 'physical reads';
   OPEN get_stat (stat_name);
   FETCH get_stat INTO temp_name, p_reads;
   CLOSE get_stat;
   DBMS_OUTPUT.put_line (   temp_name
                         || ':'
                         || TO_CHAR (p_reads));

   SELECT COUNT (*)
     INTO users
     FROM v$session
    WHERE username IS NOT NULL;

   h_ratio :=
       (  ((  db_gets
            + con_gets
            - p_reads
           ) / (  db_gets
                + con_gets
               )
          )
        * 100
       );
   DBMS_OUTPUT.put_line (   'hit_ratio:'
                         || TO_CHAR (h_ratio));

   INSERT INTO hit_ratios
        VALUES (c_date, c_hour, db_gets, con_gets, p_reads, h_ratio, 0, 0, users);

   COMMIT;

   UPDATE hit_ratios
      SET period_hit_ratio = (SELECT ROUND (
                                          (  (  (  h2.CONSISTENT
                                                 - h1.CONSISTENT
                                                )
                                              + (  h2.db_block_gets
                                                 - h1.db_block_gets
                                                )
                                              - (  h2.phy_reads
                                                 - h1.phy_reads
                                                )
                                             )
                                           / (  (  h2.CONSISTENT
                                                 - h1.CONSISTENT
                                                )
                                              + (  h2.db_block_gets
                                                 - h1.db_block_gets
                                                )
                                             )
                                          )
                                        * 100,
                                        2
                                     )
                                FROM hit_ratios h1, hit_ratios h2
                               WHERE h2.check_date = hit_ratios.check_date
                                 AND h2.check_hour = hit_ratios.check_hour
                                 AND (   (    h1.check_date = h2.check_date
                                          AND   h1.check_hour
                                              + 1 = h2.check_hour
                                         )
                                      OR (      h1.check_date
                                              + 1 = h2.check_date
                                          AND h1.check_hour = '23'
                                          AND h2.check_hour = '0'
                                         )
                                     ))
    WHERE period_hit_ratio = 0;

   COMMIT;

   UPDATE hit_ratios
      SET period_usage = (SELECT (  (  h2.CONSISTENT
                                     - h1.CONSISTENT
                                    )
                                  + (  h2.db_block_gets
                                     - h1.db_block_gets
                                    )
                                 )
                            FROM hit_ratios h1, hit_ratios h2
                           WHERE h2.check_date = hit_ratios.check_date
                             AND h2.check_hour = hit_ratios.check_hour
                             AND (   (    h1.check_date = h2.check_date
                                      AND   h1.check_hour
                                          + 1 = h2.check_hour
                                     )
                                  OR (      h1.check_date
                                          + 1 = h2.check_date
                                      AND h1.check_hour = '23'
                                      AND h2.check_hour = '0'
                                     )
                                 ))
    WHERE period_usage = 0;

   COMMIT;
EXCEPTION
   WHEN ZERO_DIVIDE
   THEN
      INSERT INTO hit_ratios
           VALUES (c_date, c_hour, db_gets, con_gets, p_reads, 0, 0, 0, users);

      COMMIT;
END;
/
