SELECT lpad(' ',level-1)||operation||' '||options||' '||
        object_name "Plan"
   FROM NK_plan_table
CONNECT BY prior id = parent_id
        AND prior statement_id = statement_id
  START WITH id = 0 AND statement_id = '&ID'
  ORDER BY id
/