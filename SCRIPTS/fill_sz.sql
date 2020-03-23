INSERT INTO temp_size_table                                                   
SELECT 'DEPT'                                                                 
,COUNT( DISTINCT(dbms_rowid.rowid_block_number(ROWID))) blocks                
FROM scott.DEPT                                                               
;                                                                             
INSERT INTO temp_size_table                                                   
SELECT 'EMP'                                                                  
,COUNT( DISTINCT(dbms_rowid.rowid_block_number(ROWID))) blocks                
FROM scott.EMP                                                                
;                                                                             
INSERT INTO temp_size_table                                                   
SELECT 'BONUS'                                                                
,COUNT( DISTINCT(dbms_rowid.rowid_block_number(ROWID))) blocks                
FROM scott.BONUS                                                              
;                                                                             
INSERT INTO temp_size_table                                                   
SELECT 'SALGRADE'                                                             
,COUNT( DISTINCT(dbms_rowid.rowid_block_number(ROWID))) blocks                
FROM scott.SALGRADE                                                           
;                                                                             
