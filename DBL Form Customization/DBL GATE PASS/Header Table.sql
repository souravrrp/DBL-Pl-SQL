CREATE TABLE APPS.XXDBL_CERAMIC_GATE_PASS_HDR
(
  GATE_PASS_HDR_ID  NUMBER                   NOT NULL,
  TO_HEAD              VARCHAR2(100 BYTE),
  ADDRESS              VARCHAR2(256 BYTE),
  CHALLAN_NO           VARCHAR2(100 BYTE),
  DELIVERY_DATE        DATE,
  VEHICLE_NO           VARCHAR2(100 BYTE),
  CHALLAN_DATE         DATE
)
TABLESPACE APPS_TS_TX_DATA
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          128K
            NEXT             128K
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE UNIQUE INDEX APPS.XXDBL_CERAMIC_GATE_PASS_HDR_PK ON APPS.XXDBL_CERAMIC_GATE_PASS_HDR
(GATE_PASS_HDR_ID)
LOGGING
TABLESPACE APPS_TS_TX_DATA
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          128K
            NEXT             128K
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           );

ALTER TABLE APPS.XXDBL_CERAMIC_GATE_PASS_HDR ADD (
  CONSTRAINT XXDBL_CERAMIC_GATE_PASS_HDR_PK
  PRIMARY KEY
  (GATE_PASS_HDR_ID)
  USING INDEX APPS.XXDBL_CERAMIC_GATE_PASS_HDR_PK
  ENABLE VALIDATE);