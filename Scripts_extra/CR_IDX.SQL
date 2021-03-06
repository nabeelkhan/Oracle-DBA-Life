--------------------------------------------------------------------------------
--  DROP Index Recommendations
--------------------------------------------------------------------------------


DROP INDEX FINAL7.REP_TD_MAIN_SUB_AC;

DROP INDEX FINAL7.P_REP_TD_MAIN_SUB_AC;

DROP INDEX PREMPROD.PIX_CDH_1;

DROP INDEX PREMPROD.PS_PREM_REG_IDX_003;

DROP INDEX PREMPROD.FK_POL_PDS_IDX;

DROP INDEX PREMPROD.PIX_POL_6;

DROP INDEX PREMPROD.SHIP_POL_SYS_ID;


--------------------------------------------------------------------------------
--  CREATE Index Recommendations
--------------------------------------------------------------------------------


CREATE INDEX FINAL7.FM_MAIN_ACCOUNT_IDX_020
     ON FINAL7.FM_MAIN_ACCOUNT
        (MAIN_ACTY_CODE_1)
    TABLESPACE FIN7IDX_NYR
    PCTFREE 0;

CREATE INDEX FINAL7.FM_MAIN_ACCOUNT_IDX_021
     ON FINAL7.FM_MAIN_ACCOUNT
        (MAIN_ACTY_CODE_2)
    TABLESPACE FIN7IDX_NYR
    PCTFREE 0;

CREATE INDEX FINAL7.FM_MAIN_ACCOUNT_IDX_022
     ON FINAL7.FM_MAIN_ACCOUNT
        (MAIN_ACNT_CATG)
    TABLESPACE FIN7IDX_NYR
    PCTFREE 0;

CREATE INDEX FINAL7.FS_CUR_ACNT_BAL_IDX_017
     ON FINAL7.FS_CUR_ACNT_BAL
        (ABAL_MAIN_ACNT_CODE,
         ABAL_SUB_ACNT_CODE)
    TABLESPACE FIN7IDX_NYR
    PCTFREE 0;

CREATE INDEX FINAL7.FS_CUR_ACNT_BAL_IDX_018
     ON FINAL7.FS_CUR_ACNT_BAL
        (ABAL_COMP_CODE,
         ABAL_DIVN_CODE,
         ABAL_DEPT_CODE)
    TABLESPACE FIN7IDX_NYR
    PCTFREE 0;

CREATE INDEX FINAL7.FS_CUR_ACNT_BAL_IDX_019
     ON FINAL7.FS_CUR_ACNT_BAL
        (ABAL_CURR_CODE)
    TABLESPACE FIN7IDX_NYR
    PCTFREE 0;

CREATE INDEX FINAL7.FS_PRV_ACNT_BAL_IDX_028
     ON FINAL7.FS_PRV_ACNT_BAL
        (ABAL_MAIN_ACNT_CODE,
         ABAL_SUB_ACNT_CODE)
    TABLESPACE FIN7IDX_NYR
    PCTFREE 0;

CREATE INDEX FINAL7.FS_PRV_ACNT_BAL_IDX_029
     ON FINAL7.FS_PRV_ACNT_BAL
        (ABAL_COMP_CODE,
         ABAL_DIVN_CODE,
         ABAL_DEPT_CODE)
    TABLESPACE FIN7IDX_NYR
    PCTFREE 0;

CREATE INDEX FINAL7.FS_PRV_ACNT_BAL_IDX_030
     ON FINAL7.FS_PRV_ACNT_BAL
        (ABAL_CURR_CODE)
    TABLESPACE FIN7IDX_NYR
    PCTFREE 0;

CREATE INDEX FINAL7.REP_TD_MAIN_SUB_AC
     ON FINAL7.FT_CUR_TRANS_DETAIL
        (TD_MAIN_ACNT_CODE,
         TD_SUB_ACNT_CODE,
         TD_CURR_CODE)
    LOGGING
    INITRANS 2
    MAXTRANS 255
    TABLESPACE FIN7IDX_NYR
    PCTFREE 0
    STORAGE (
        INITIAL 24292K
        PCTINCREASE 0
        MINEXTENTS 1
        MAXEXTENTS 2147483645);

CREATE INDEX FINAL7.FT_CUR_TRANS_DETAIL_IDX_008
     ON FINAL7.FT_CUR_TRANS_DETAIL
        (TD_MONTH_PRC_FLAG,
         TD_COMP_CODE,
         TD_ACNT_YEAR,
         TD_TRAN_CODE,
         TD_DOC_NO)
    TABLESPACE FIN7IDX_NYR
    PCTFREE 0;

CREATE INDEX FINAL7.FT_CUR_TRANS_DETAIL_IDX_025
     ON FINAL7.FT_CUR_TRANS_DETAIL
        (TD_COMP_CODE,
         TD_DIVN_CODE,
         TD_DEPT_CODE)
    TABLESPACE FIN7IDX_NYR
    PCTFREE 0;

CREATE INDEX FINAL7.FT_CUR_TRANS_DETAIL_IDX_026
     ON FINAL7.FT_CUR_TRANS_DETAIL
        (TD_TRAN_CODE)
    TABLESPACE FIN7IDX_NYR
    PCTFREE 0;

CREATE INDEX FINAL7.FT_CUR_TRANS_DETAIL_IDX_027
     ON FINAL7.FT_CUR_TRANS_DETAIL
        (TD_CURR_CODE)
    TABLESPACE FIN7IDX_NYR
    PCTFREE 0;

CREATE INDEX FINAL7.FT_CUR_TRANS_HEADER_IDX_009
     ON FINAL7.FT_CUR_TRANS_HEADER
        (TH_DOC_CAL_YEAR,
         TH_DOC_CAL_MONTH,
         TH_COMP_CODE,
         TH_ACNT_YEAR,
         TH_TRAN_CODE,
         TH_DOC_NO)
    TABLESPACE FIN7IDX_NYR
    PCTFREE 0;

CREATE INDEX FINAL7.FT_CUR_TRANS_HEADER_IDX_023
     ON FINAL7.FT_CUR_TRANS_HEADER
        (TH_COMP_CODE,
         TH_DIVN_CODE,
         TH_DEPT_CODE)
    TABLESPACE FIN7IDX_NYR
    PCTFREE 0;

CREATE INDEX FINAL7.FT_CUR_TRANS_HEADER_IDX_024
     ON FINAL7.FT_CUR_TRANS_HEADER
        (TH_TRAN_CODE)
    TABLESPACE FIN7IDX_NYR
    PCTFREE 0;

CREATE INDEX FINAL7.FT_OS_IDX_014
     ON FINAL7.FT_OS
        (OST_COMP_CODE,
         OST_DIVN_CODE,
         OST_DEPT_CODE)
    TABLESPACE FIN7IDXTAB
    PCTFREE 0;

CREATE INDEX FINAL7.FT_OS_IDX_015
     ON FINAL7.FT_OS
        (OST_HEAD_NO_1,
         OST_ANLY_CODE_1)
    TABLESPACE FIN7IDXTAB
    PCTFREE 0;

CREATE INDEX FINAL7.FT_OS_IDX_016
     ON FINAL7.FT_OS
        (OST_HEAD_NO_2,
         OST_ANLY_CODE_2)
    TABLESPACE FIN7IDXTAB
    PCTFREE 0;

CREATE INDEX FINAL7.P_REP_TD_MAIN_SUB_AC
     ON FINAL7.FT_PRV_TRANS_DETAIL
        (TD_MAIN_ACNT_CODE,
         TD_SUB_ACNT_CODE,
         TD_COMP_CODE)
    LOGGING
    INITRANS 2
    MAXTRANS 255
    TABLESPACE FIN7IDX_NYR
    PCTFREE 0
    STORAGE (
        INITIAL 173012K
        PCTINCREASE 0
        MINEXTENTS 1
        MAXEXTENTS 2147483645);

CREATE INDEX FINAL7.FT_PRV_TRANS_DETAIL_IDX_004
     ON FINAL7.FT_PRV_TRANS_DETAIL
        (TD_COMP_CODE,
         TD_TRAN_CODE,
         TD_ACNT_YEAR,
         TD_DOC_NO)
    TABLESPACE FIN7IDX_NYR
    PCTFREE 0;

CREATE INDEX FINAL7.FT_PRV_TRANS_DETAIL_IDX_011
     ON FINAL7.FT_PRV_TRANS_DETAIL
        (TD_TRAN_CODE)
    TABLESPACE FIN7IDX_NYR
    PCTFREE 0;

CREATE INDEX FINAL7.FT_PRV_TRANS_DETAIL_IDX_012
     ON FINAL7.FT_PRV_TRANS_DETAIL
        (TD_CURR_CODE)
    TABLESPACE FIN7IDX_NYR
    PCTFREE 0;

CREATE INDEX FINAL7.FT_PRV_TRANS_HEADER_IDX_003
     ON FINAL7.FT_PRV_TRANS_HEADER
        (TH_COMP_CODE,
         TH_TRAN_CODE,
         TH_ACNT_YEAR,
         TH_DOC_NO)
    TABLESPACE FIN7IDX_NYR
    PCTFREE 0;

CREATE INDEX FINAL7.FT_PRV_TRANS_HEADER_IDX_013
     ON FINAL7.FT_PRV_TRANS_HEADER
        (TH_TRAN_CODE)
    TABLESPACE FIN7IDX_NYR
    PCTFREE 0;

CREATE INDEX PREMPROD.PIX_CDH_1
     ON PREMPROD.PH_COVER_DISCOUNT
        (CDH_COVER_SYS_ID,
         CDH_END_NO_IDX,
         CDH_N_FC_DISC,
         CDH_O_FC_DISC)
    LOGGING
    INITRANS 2
    MAXTRANS 255
    TABLESPACE PREMIDXTAB
    PCTFREE 0
    STORAGE (
        INITIAL 772K
        PCTINCREASE 0
        MINEXTENTS 1
        MAXEXTENTS 2147483645);

CREATE INDEX PREMPROD.PH_POL_COVER_IDX_006
     ON PREMPROD.PH_POL_COVER
        (PCVRH_N_CODE,
         PCVRH_SYS_ID)
    TABLESPACE PREMIDXTAB
    PCTFREE 0;

CREATE INDEX PREMPROD.PS_DRCR_IDX_002
     ON PREMPROD.PS_DRCR
        (DRCR_SUB_ACNT_CODE,
         DRCR_CLM_SYS_ID,
         DRCR_DOC_DT,
         DRCR_TXN_CODE,
         DRCR_DOC_NO)
    TABLESPACE FIN7IDXTAB
    PCTFREE 0;

CREATE INDEX PREMPROD.PS_PREM_REG_IDX_003
     ON PREMPROD.PS_PREM_REG
        (PR_DEPT_CODE,
         PR_POL_SYS_ID,
         PR_END_NO_IDX,
         PR_SC_CODE,
         PR_CUST_CODE,
         PR_APPRV_DT,
         PR_POL_NO,
         PR_END_NO,
         PR_TXN_DT)
    LOGGING
    INITRANS 2
    MAXTRANS 255
    TABLESPACE PREMIDXTAB
    PCTFREE 0
    STORAGE (
        INITIAL 64K
        PCTINCREASE 0
        MINEXTENTS 1
        MAXEXTENTS 2147483645);

CREATE INDEX PREMPROD.PT_CLAIM_IDX_010
     ON PREMPROD.PT_CLAIM
        (CLM_CDS_CODE,
         CLM_POL_NO)
    TABLESPACE PREMIDXTAB
    PCTFREE 0;

CREATE INDEX PREMPROD.FK_POL_PDS_IDX
     ON PREMPROD.PT_POLICY
        (POL_PDS_CODE,
         POL_DIVN_CODE,
         POL_UW_YEAR,
         POL_ISSUE_DT)
    LOGGING
    INITRANS 2
    MAXTRANS 255
    TABLESPACE PREMIDXTAB
    PCTFREE 0
    STORAGE (
        INITIAL 13332K
        PCTINCREASE 0
        MINEXTENTS 1
        MAXEXTENTS 2147483645);

CREATE UNIQUE INDEX PREMPROD.PIX_POL_6
     ON PREMPROD.PT_POLICY
        (POL_SYS_ID,
         POL_END_NO_IDX,
         POL_ISSUE_DT,
         POL_NO)
    LOGGING
    INITRANS 2
    MAXTRANS 255
    TABLESPACE PREMIDXTAB
    PCTFREE 0
    STORAGE (
        INITIAL 14160K
        PCTINCREASE 0
        MINEXTENTS 1
        MAXEXTENTS 2147483645);

CREATE INDEX PREMPROD.PT_POL_CHARGE_IDX_005
     ON PREMPROD.PT_POL_CHARGE
        (CHG_SYS_ID)
    TABLESPACE PREMIDXTAB
    PCTFREE 0;

CREATE INDEX PREMPROD.PT_RI_CESSION_IDX_007
     ON PREMPROD.PT_RI_CESSION
        (RC_SYS_ID,
         RC_SUM_FC_SI,
         RC_SUM_FC_FAC_SI,
         RC_SUM_FC_COINS_SI)
    TABLESPACE PREMIDXTAB
    PCTFREE 10;

CREATE INDEX PREMPROD.SHIP_POL_SYS_ID
     ON PREMPROD.PT_SHIPMENT
        (SHIP_POL_SYS_ID,
         SHIP_LC_NO,
         SHIP_BANK_NAME)
    LOGGING
    INITRANS 2
    MAXTRANS 255
    TABLESPACE PREMIDXTAB
    PCTFREE 0
    STORAGE (
        INITIAL 1032K
        PCTINCREASE 0
        MINEXTENTS 1
        MAXEXTENTS 2147483645);
