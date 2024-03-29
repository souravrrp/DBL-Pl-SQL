DROP TABLE XXDBL.XX_LOAN_INTEREST_DTL_INFO CASCADE CONSTRAINTS;

CREATE TABLE XXDBL.XX_LOAN_INTEREST_DTL_INFO
(
  LOAN_ID                   INTEGER,
  ORG_ID                    NUMBER(15),
  LEDGER_ID                 NUMBER(15),
  SECURITY_PROFILE_ID       NUMBER(15),
  COMPANY_CODE              VARCHAR2(5 BYTE),
  SCHEDULE_ID               NUMBER(15),
  PRINCIPAL_AMOUNT          NUMBER(30,9),
  INTEREST_RATE             NUMBER(4,2),
  INTEREST_AMOUNT           NUMBER(30,9),
  REPAYMENT_AMT             NUMBER(30,9),
  OVER_DUE_DAYS             NUMBER,
  OVER_DUE_RATE             NUMBER(4,2),
  OVER_DUE_AMT              NUMBER(30,9),
  AFTER_OVER_DUE_AMT        NUMBER(30,9),
  TOTAL_AMOUNT              NUMBER(30,9),
  DESCRIPTION               VARCHAR2(240 BYTE),
  PROCESS_FLAG              VARCHAR2(1 BYTE),
  PAYMENT_MODE              VARCHAR2(20 BYTE),
  EFFECTIVE_START_DATE      DATE,
  EFFECTIVE_END_DATE        DATE,
  CREATION_DATE             DATE,
  CREATED_BY                NUMBER(15)          NOT NULL,
  LAST_UPDATE_DATE          DATE                NOT NULL,
  LAST_UPDATED_BY           NUMBER(15)          NOT NULL,
  LAST_UPDATE_LOGIN         NUMBER(15)          NOT NULL,
  LINE_NO                   NUMBER(15),
  PAYMENT_DATE              DATE,
  GL_DATE                   DATE,
  CALCULATE_DAY             NUMBER,
  BALANCE_AMOUNT            NUMBER(30,9),
  YTD_DAY                   NUMBER,
  REPAY_INT_AMT             NUMBER(30,9),
  GRACE_AMT                 NUMBER(30,9),
  VOUCHER_NUMBER            VARCHAR2(240 BYTE),
  REPAY_FLAG                VARCHAR2(1 BYTE),
  INTEREST_FLAG             VARCHAR2(1 BYTE),
  GRACE_FLAG                VARCHAR2(1 BYTE),
  OD_FLAG                   VARCHAR2(1 BYTE),
  INTERFACE_LINE_ID         VARCHAR2(240 BYTE),
  INTERFACE_HEADER_ID       NUMBER(22),
  INVOICE_ID                NUMBER(22),
  PROVISION_VOUCHER_NUMBER  VARCHAR2(240 BYTE),
  SANCTION_NO               VARCHAR2(40 BYTE),
  OD_PRINCIPLE_AMT          NUMBER(30,9),
  SANCTION_ID               VARCHAR2(40 BYTE),
  GL_HEADER_ID              VARCHAR2(40 BYTE),
  PRINCIPLE_TOTAL           NUMBER(25,2),
  INTEREST_TOTAL            NUMBER(25,2),
  CLOSING_TOTAL             NUMBER(25,2),
  CHECK_FLAG                VARCHAR2(1 BYTE),
  INVOICE_FLAG              VARCHAR2(1 BYTE),
  LOAN_TRX_TYPE             VARCHAR2(50 BYTE)
)
TABLESPACE XXDBL_TS_TX_DATA
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE;


CREATE OR REPLACE SYNONYM APPS.XX_LOAN_INTEREST_DTL_INFO FOR XXDBL.XX_LOAN_INTEREST_DTL_INFO;


CREATE OR REPLACE SYNONYM APPSRO.XX_LOAN_INTEREST_DTL_INFO FOR XXDBL.XX_LOAN_INTEREST_DTL_INFO;


GRANT SELECT ON XXDBL.XX_LOAN_INTEREST_DTL_INFO TO APPSRO;
