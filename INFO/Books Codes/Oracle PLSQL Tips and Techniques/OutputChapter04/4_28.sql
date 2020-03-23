-- ***************************************************************************
-- File: 4_28.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 4_28.lis

CREATE OR REPLACE PROCEDURE search_trigs
   (p_search_txt VARCHAR2, p_trigger_txt VARCHAR2 := NULL) IS
   CURSOR cur_get_trigger_body IS
      SELECT trigger_name, table_name, trigger_body
      FROM   user_triggers
      WHERE  trigger_name = NVL(UPPER(p_trigger_txt), trigger_name);
   lv_body_txt           VARCHAR2(32767);
   lv_trigger_name_txt   VARCHAR2(30);
   lv_table_name_txt     VARCHAR2(30);
   lv_counter_num        NUMBER;
   lv_error_occurred_bln BOOLEAN := FALSE;
BEGIN
   OPEN cur_get_trigger_body;
   LOOP
      -- Initialize local variables on each loop pass
      lv_trigger_name_txt := NULL;
      lv_table_name_txt   := NULL;
      lv_body_txt         := NULL;
      -- Use nested PL/SQL block to trap exceptions
      BEGIN << fetch_body >>
         FETCH cur_get_trigger_body INTO lv_trigger_name_txt,
            lv_table_name_txt, lv_body_txt;
         IF cur_get_trigger_body%NOTFOUND THEN
            -- When no more triggers, exit loop
            EXIT;
         END IF;
      EXCEPTION
         WHEN VALUE_ERROR THEN
            IF p_trigger_txt IS NOT NULL THEN
               lv_error_occurred_bln := TRUE;
               DBMS_OUTPUT.PUT_LINE('Trigger body too long to ' ||
                  'search.');
            ELSE
               DBMS_OUTPUT.PUT_LINE('Trigger body too long to ' ||
                  'search for  Trigger: ' || 
                  RPAD(lv_trigger_name_txt,30) || 
                  ' Table: ' || lv_table_name_txt);
            END IF;
      END fetch_body;
      -- Use INSTR function to check if search string is found
      IF INSTR(UPPER(lv_body_txt), UPPER(p_search_txt)) > 0 THEN
         lv_counter_num := NVL(lv_counter_num, 0) + 1;
         DBMS_OUTPUT.PUT_LINE('Match found in  Trig: ' || 
            RPAD(lv_trigger_name_txt,30) || ' Table: ' || 
               lv_table_name_txt);
      END IF;
   END LOOP;
   CLOSE cur_get_trigger_body;
   -- If no previous messages were displayed, then create generic one
   IF NVL(lv_counter_num,0) = 0 AND NOT lv_error_occurred_bln THEN
      DBMS_OUTPUT.PUT_LINE('Search found no matches.');
   END IF;
END search_trigs;
/

SPOOL OFF
