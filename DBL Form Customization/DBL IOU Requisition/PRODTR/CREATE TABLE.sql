/* Formatted on 11/12/2020 12:50:32 PM (QP5 v5.287) */
CREATE TABLE XXDBL.XXDBL_IOU_REQ_DTL
(
   IOU_REQ_ID            NUMBER NOT NULL,
   IOU_NUMBER            VARCHAR2 (100 BYTE),
   IOU_DATE              DATE,
   LEGAL_ENTITY_ID       NUMBER,
   LEGAL_ENTITY          VARCHAR2 (240 BYTE),
   OPERATING_UNIT        NUMBER,
   OU_NAME               VARCHAR2 (240 BYTE),
   LOCATION_ID           NUMBER,
   LOCATION_NAME         VARCHAR2 (500 BYTE),
   EMPLOYEE_NO           VARCHAR2 (100 BYTE),
   ADVANCE_AMOUNT        NUMBER,
   REASON_FOR_ADVANCE    VARCHAR2 (500 BYTE),
   RETURN_DAYS           NUMBER,
   STATUS                VARCHAR2 (50 BYTE),
   CREATED_BY            NUMBER,
   CREATION_DATE         DATE,
   LAST_UPDATE_LOGIN     NUMBER,
   LAST_UPDATED_BY       NUMBER,
   LAST_UPDATE_DATE      DATE,
   APPROVED_BY           VARCHAR2 (100 BYTE),
   APPROVED_DATE         DATE,
   PAID_BY               VARCHAR2 (100 BYTE),
   PAYMENT_AMOUNT        NUMBER,
   PAYMENT_DATE          DATE,
   ADJUSTED_BY           VARCHAR2 (100 BYTE),
   ADJUST_AMOUNT         NUMBER,
   BILL_AMOUNT           NUMBER,
   ADJUST_DATE           DATE,
   FIRST_APPROVER        VARCHAR2 (100 BYTE),
   SECOND_APPROVER       VARCHAR2 (100 BYTE),
   FINAL_APPROVER        VARCHAR2 (100 BYTE),
   FINAL_APPROVED_DATE   DATE,
   FINAL_APPROVE         VARCHAR2 (50 BYTE),
   CONSTRAINT IOU_REQ_PK PRIMARY KEY (IOU_REQ_ID)
);

CREATE OR REPLACE SYNONYM APPS.XXDBL_IOU_REQ_DTL FOR XXDBL.XXDBL_IOU_REQ_DTL;

CREATE OR REPLACE SYNONYM APPSRO.XXDBL_IOU_REQ_DTL FOR XXDBL.XXDBL_IOU_REQ_DTL;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, READ, DEBUG, FLASHBACK ON XXDBL.XXDBL_IOU_REQ_DTL TO APPS WITH GRANT OPTION;

GRANT INSERT, SELECT, UPDATE ON XXDBL.XXDBL_IOU_REQ_DTL TO APPSDBL;

GRANT SELECT ON XXDBL.XXDBL_IOU_REQ_DTL TO APPSRO;