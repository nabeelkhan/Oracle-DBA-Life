REM FILE NAME:  ld_data.sql
REM LOCATION:   System Monitoring\Utilities
REM FUNCTION:   Load data buffer data
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   v$statname, v$sysstat, v$session, hit_ratios
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


DECLARE
   c_date      DATE;
   c_hour      NUMBER        := 0;
   h_ratio     NUMBER        := 0;
   con_gets    NUMBER        := 0;
   db_gets     NUMBER        := 0;
   p_reads     NUMBER        := 0;
   stat_name   VARCHAR2 (64);
   temp_name   VARCHAR2 (64);
   stat_val    NUMBER        := 0;
   users       NUMBER        := 0;
BEGIN
   SELECT TO_CHAR (SYSDATE, 'DD-MON-YY')
     INTO c_date
     FROM DUAL;

   SELECT TO_CHAR (SYSDATE, 'HH24')
     INTO c_hour
     FROM DUAL;

   stat_name := 'db block gets';

   SELECT a.NAME, b.VALUE
     INTO temp_name, db_gets
     FROM v$statname a, v$sysstat b
    WHERE a.statistic# = b.statistic# AND a.NAME = stat_name;

   stat_name := 'consistent gets';

   SELECT a.NAME, b.VALUE
     INTO temp_name, con_gets
     FROM v$statname a, v$sysstat b
    WHERE a.statistic# = b.statistic# AND a.NAME = stat_name;

   stat_name := 'physical reads';

   SELECT a.NAME, b.VALUE
     INTO temp_name, p_reads
     FROM v$statname a, v$sysstat b
    WHERE a.statistic# = b.statistic# AND a.NAME = stat_name;

   SELECT   COUNT (*)
          - 4
     INTO users
     FROM v$session;

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
   WHEN NO_DATA_FOUND
   THEN
      NULL;
   WHEN ZERO_DIVIDE
   THEN
      INSERT INTO hit_ratios
           VALUES (c_date, c_hour, db_gets, con_gets, p_reads, 0, 0, 0, users);

      COMMIT;
END;
/
