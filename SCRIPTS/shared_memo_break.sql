column sum(ksmchsiz) format 999,999,999,999,999 heading 'Bytes'
column ksmchcls format a8 heading 'Status'
compute sum of sum(ksmchsiz) on report
break on report
select sum(ksmchsiz), ksmchcls from x$ksmsp
group by ksmchcls
/
