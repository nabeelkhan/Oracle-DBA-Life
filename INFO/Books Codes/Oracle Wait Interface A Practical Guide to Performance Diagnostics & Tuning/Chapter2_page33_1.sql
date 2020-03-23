-- Enable trace at level 8 for session 1234 with serial# 56789
exec dbms_system.set_ev( 1234, 56789, 10046, 8, ‘’);  

-- Let the session execute SQL script or 
-- program for some amount of time 

-- To turn off the tracing:
exec dbms_system.set_ev( 1234, 56789, 10046, 0, ‘’);




