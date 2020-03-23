column "Plan" format a80
set pagesize 650

SELECT cardinality "Rows",
       lpad(' ',level-1)||operation||' '||
       options||' '||object_name "Plan"
  FROM NK_PLAN_TABLE
CONNECT BY prior id = parent_id
        AND prior statement_id = statement_id
  START WITH id = 0
--        AND statement_id = 'bad1'
  ORDER BY id;
