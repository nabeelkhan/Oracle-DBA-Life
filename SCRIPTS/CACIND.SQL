--Description: 
--Reduce the Reloads and try to increase the hit ratios to above 85%
--Code :
ttitle center 'LIBRARY CACHE STATS' skip 2
column namespace format a8 heading 'Library'
column gets format 9,999,990 heading 'GETS'
column gethits format 9,999,990 heading 'GETHITS'
column gethitratio format 99.90 heading 'GET|HIT|RATIO'
column pins format 999,999,990 heading 'PINS'
column pinhits format 999,999,990 heading 'PINHITS'
column pinhitratio format 99.90 heading 'PIN|HIT|RATIO'
column reloads format 999,990 heading 'RELOADS' 
compute sum of gets on report
compute sum of gethits on report
compute sum of pins on report
compute sum of pinhits on report 
compute sum of reloads on report
break on report
select
namespace,gets,gethits,gethitratio,pins,pinhits,
pinhitratio, reloads
from v$librarycache
where gets+gethits+pins+pinhits>0
; 

