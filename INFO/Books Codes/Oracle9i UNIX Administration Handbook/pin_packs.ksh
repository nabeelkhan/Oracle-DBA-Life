ORACLE_SID=prodedi
export ORACLE_SID
su oracle -c "/usr/oracle/bin/svrmgrl /<<!
connect internal;
@pin.sql 
exit;
!"
