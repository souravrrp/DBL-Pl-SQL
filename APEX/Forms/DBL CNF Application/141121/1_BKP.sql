DROP TABLE XX_APEX.XX_APEX_CNF_EXPENSE_LIST CASCADE CONSTRAINTS;

CREATE TABLE XX_APEX.XX_APEX_CNF_EXPENSE_LIST
(
  EXPENSE_LIST_ID      NUMBER GENERATED ALWAYS AS IDENTITY ( START WITH 107 MAXVALUE 9999999999999999999999999999 MINVALUE 1 NOCYCLE CACHE 20 NOORDER NOKEEP) NOT NULL,
  EXPENSE_LIST         VARCHAR2(200 BYTE),
  ACTIVITY_LEVEL       VARCHAR2(100 BYTE),
  RECEIPTABLE          VARCHAR2(10 BYTE),
  NON_RECEIPTABLE      VARCHAR2(10 BYTE),
  PORT_SIDE            VARCHAR2(10 BYTE),
  DEPOT_SIDE           VARCHAR2(10 BYTE),
  CUSTOMS_SIDE         VARCHAR2(10 BYTE),
  EXPENSE_LIST_STATUS  NUMBER,
  CREATED_BY           NUMBER,
  CREATION_DATE        DATE,
  LAST_UPDATED_BY      NUMBER,
  LAST_UPDATE_DATE     DATE,
  ATTRIBUTE1           VARCHAR2(255 BYTE),
  ATTRIBUTE2           VARCHAR2(255 BYTE),
  ATTRIBUTE3           VARCHAR2(255 BYTE),
  ATTRIBUTE4           VARCHAR2(255 BYTE)
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


CREATE UNIQUE INDEX XX_APEX.XX_APEX_CNF_EXPENSE_L_PK ON XX_APEX.XX_APEX_CNF_EXPENSE_LIST
(EXPENSE_LIST_ID)
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

ALTER TABLE XX_APEX.XX_APEX_CNF_EXPENSE_LIST ADD (
  CONSTRAINT XX_APEX_CNF_EXPENSE_L_PK
  PRIMARY KEY
  (EXPENSE_LIST_ID)
  USING INDEX XX_APEX.XX_APEX_CNF_EXPENSE_L_PK
  ENABLE VALIDATE);


DROP SEQUENCE XX_APEX.ISEQ$$_16318813;

-- Sequence ISEQ$$_16318813 is created automatically by Oracle for use with an Identity column


CREATE OR REPLACE PUBLIC SYNONYM XX_APEX_CNF_EXPENSE_LIST FOR XX_APEX.XX_APEX_CNF_EXPENSE_LIST;
