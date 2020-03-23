drop table t;
create table t ( country varchar2(10) ,
customer varchar2 (10),
sale_amount number (5),
quantity number(5) ) ;

insert into t 
select 'USA',         'USA1',       5000,             50 from dual union 
select 'AUS',         'AUS1',       500 ,            30 from dual union 
select 'USA',         'USA1',       2000,            30 from dual union  
select 'USA',         'USA2',        700,             30 from dual union 
select 'USA',         'USA3',        250,             40  from dual union 
select 'AUS',         'AUS2',        300,             70 from dual union 
select 'USA',         'USA4',       1700,             30 from dual union 
select 'AUS',         'AUS3',        600,             20 from dual union 
select 'USA',        'USA4' ,      1700,            30  from dual union 
select 'USA',         'USA5',       1200,             40 from dual union 
select 'USA',         'USA6',       300,             30 from dual union 
select 'USA',         'USA7',       500,             70 from dual union 
select 'AUS',         'AUS4',       2600,             20 from dual union 
select 'AUS',         'AUS4',       1600,             20 from dual union 
select 'AUS',         'AUS5',       1800,             10 from dual union 
select 'AUS',         'AUS6',       1400,             15 from dual  
;
commit ;


select cty, cust, amt, qty, dr, ratio_to_report(amt) over ()*100 tot_pct
  from (
select case when dr <= 5 then country else 'oth' end cty, 
       case when dr <= 5 then customer else 'others' end cust, 
	   sum(amt) amt, sum(qty) qty, dr
  from (
select country, customer, amt, qty,
       least( dense_rank() over (order by amt desc nulls last), 6 ) dr
  from (
select country, customer, sum(sale_amount) amt, sum(quantity) qty
  from t
 group by country, customer
       )
	   )
 group by case when dr <= 5 then country else 'oth' end , 
          case when dr <= 5 then customer else 'others' end , 
		  dr
	   )
 order by dr
/

