CREATE TABLE XX_APEX.XX_APEX_CNF_JOB_MASTER
(
  JOB_MASTER_ID             NUMBER GENERATED ALWAYS AS IDENTITY ( START WITH 143 MAXVALUE 9999999999999999999999999999 MINVALUE 1 NOCYCLE CACHE 20 NOORDER NOKEEP) NOT NULL,
  OPERATING_UNIT            NUMBER,
  BILL_NO                   VARCHAR2(200 BYTE),
  BUYER                     VARCHAR2(200 BYTE),
  JOB_NO                    VARCHAR2(50 BYTE),
  JOB_DATE                  DATE,
  NUMBER_OF_CONTAINER       NUMBER,
  LC_NO                     VARCHAR2(255 BYTE),
  LC_DATE                   DATE,
  CONTAINER_SIZE            VARCHAR2(100 BYTE),
  COMMERCIAL_INVOICE_NO     VARCHAR2(100 BYTE),
  COMMERCIAL_INVOICE_DATE   DATE,
  COMMERCIAL_INVOICE_VALUE  NUMBER,
  PRIMARY_QTY               NUMBER,
  PRIMARY_UOM               VARCHAR2(255 BYTE),
  SECONDARY_QTY             NUMBER,
  SECONDARY_UOM             VARCHAR2(255 BYTE),
  ITEM                      VARCHAR2(255 BYTE),
  SCAN_COPY_URL             VARCHAR2(255 BYTE),
  B_E_OR_S_B_NO             VARCHAR2(255 BYTE),
  B_E_OR_S_B_DATE           DATE,
  DEPARTURE_FROM            VARCHAR2(255 BYTE),
  DEPARTURE_FROM_DATE       DATE,
  CURRENCY                  VARCHAR2(100 BYTE),
  DEPOT_NAME                VARCHAR2(255 BYTE),
  TRANSPORTER               VARCHAR2(255 BYTE),
  ASSESSABLE_VALUE_TK       NUMBER,
  JOB_STATUS                VARCHAR2(100 BYTE),
  CTG_APPROVE_STATUS        NUMBER,
  CORPORATE_APPROVE_STATUS  NUMBER,
  CREATED_BY                NUMBER,
  CREATION_DATE             DATE,
  LAST_UPDATED_BY           NUMBER,
  LAST_UPDATE_DATE          DATE,
  ATTRIBUTE1                VARCHAR2(255 BYTE),
  ATTRIBUTE2                VARCHAR2(255 BYTE),
  ATTRIBUTE3                VARCHAR2(255 BYTE),
  ATTRIBUTE4                VARCHAR2(255 BYTE),
  ATTRIBUTE5                VARCHAR2(255 BYTE),
  ATTRIBUTE6                VARCHAR2(255 BYTE),
  ATTRIBUTE7                VARCHAR2(255 BYTE),
  ATTRIBUTE8                VARCHAR2(255 BYTE),
  ATTRIBUTE9                VARCHAR2(255 BYTE),
  ATTRIBUTE10               VARCHAR2(255 BYTE)
)
TABLESPACE APEX_1300907655516710
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


CREATE UNIQUE INDEX XX_APEX.XX_APEX_CNF_JOB_MASTER_PK ON XX_APEX.XX_APEX_CNF_JOB_MASTER
(JOB_MASTER_ID)
LOGGING
TABLESPACE APEX_1300907655516710
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           );
CREATE UNIQUE INDEX XX_APEX.XX_BESB_CONSTRAINT_UK ON XX_APEX.XX_APEX_CNF_JOB_MASTER
(B_E_OR_S_B_NO)
LOGGING
TABLESPACE APEX_1300907655516710
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           );

ALTER TABLE XX_APEX.XX_APEX_CNF_JOB_MASTER ADD (
  CONSTRAINT XX_APEX_CNF_JOB_MASTER_PK
  PRIMARY KEY
  (JOB_MASTER_ID)
  USING INDEX XX_APEX.XX_APEX_CNF_JOB_MASTER_PK
  ENABLE VALIDATE
,  CONSTRAINT XX_BESB_CONSTRAINT_UK
  UNIQUE (B_E_OR_S_B_NO)
  USING INDEX XX_APEX.XX_BESB_CONSTRAINT_UK
  ENABLE VALIDATE);


DROP SEQUENCE XX_APEX.ISEQ$$_16323872;

-- Sequence ISEQ$$_16323872 is created automatically by Oracle for use with an Identity column


CREATE OR REPLACE PUBLIC SYNONYM XX_APEX_CNF_JOB_MASTER FOR XX_APEX.XX_APEX_CNF_JOB_MASTER;