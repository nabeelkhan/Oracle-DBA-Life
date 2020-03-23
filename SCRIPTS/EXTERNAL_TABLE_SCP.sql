CREATE TABLE LOAD_DATA_EMP 
			(
			QEMP_ID VARCHAR2(20),
			QEMP_NAME  VARCHAR2(60),
			QEMP_FC_SAL  NUMBER(14,3),
			QEMP_DOB  DATE,
			QDEPND_ID  VARCHAR2(20),
			QDEPND_NAME  VARCHAR2(60),
			QDEPND_DOB  DATE,
			QDEPND_RELN  VARCHAR2(20),
			QEMP_CATG_CODE  VARCHAR2(2),
			QEMP_SR_NO  NUMBER(6)
		        )
	    ORGANIZATION EXTERNAL
		       (
			       TYPE ORACLE_LOADER
			       DEFAULT DIRECTORY EMP_dat_dir
			       ACCESS PARAMETERS
		       (
--		         records delimited by newline
--			 records delimited  BY ';'
		         badfile EMP_bad_dir:'empxt%a_%p.bad'
		         logfile EMP_log_dir:'empxt%a_%p.log'
		         fields terminated by ','
		         missing field values are null
		         ( QEMP_ID, QEMP_NAME, QEMP_FC_SAL, QEMP_DOB, QDEPND_ID, QDEPND_NAME, QDEPND_DOB, QDEPND_RELN, QEMP_CATG_CODE, QEMP_SR_NO         )
		       )
	LOCATION ('emp.csv')
			)
	     PARALLEL
	     REJECT LIMIT UNLIMITED
/
