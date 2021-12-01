/* Formatted on 11/30/2021 4:37:43 PM (QP5 v5.365) */
CREATE TABLE XXDBL.XXDBL_DEBT_MNGT_CHNG_HIST
(
    CHNG_HIST_ID         INTEGER
                            GENERATED ALWAYS AS IDENTITY
                                (          START WITH 1 INCREMENT BY 1)
                            NOT NULL,
    CREATION_DATE        DATE,
    CREATED_BY           NUMBER,
    LAST_UPDATE_DATE     DATE,
    LAST_UPDATED_BY      NUMBER,
    LAST_UPDATE_LOGIN    NUMBER,
    BS_NUMBER            VARCHAR2 (240 BYTE),
    OLD_BS_QTY           NUMBER,
    NEW_BS_QTY           NUMBER,
    OLD_BS_VAL           NUMBER,
    NEW_BS_VAL           NUMBER,
    BS_UPD_DATE          DATE,
    BS_UPD_BY            NUMBER,
    PI_NUMBER            VARCHAR2 (240 BYTE),
    OLD_PI_QTY           NUMBER,
    NEW_PI_QTY           NUMBER,
    OLD_PI_VAL           NUMBER,
    NEW_PI_VAL           NUMBER,
    PI_UPD_DATE          DATE,
    PI_UPD_BY            NUMBER,
    LC_NUMBER            VARCHAR2 (240 BYTE),
    OLD_LC_QTY           NUMBER,
    NEW_LC_QTY           NUMBER,
    OLD_LC_VAL           NUMBER,
    NEW_LC_VAL           NUMBER,
    LC_UPD_DATE          DATE,
    LC_UPD_BY            NUMBER,
    CI_NUMBER            VARCHAR2 (240 BYTE),
    OLD_CI_QTY           NUMBER,
    NEW_CI_QTY           NUMBER,
    OLD_CI_VAL           NUMBER,
    NEW_CI_VAL           NUMBER,
    CI_UPD_DATE          DATE,
    CI_UPD_BY            NUMBER,
    CONSTRAINT CHNG_HIST_ID_PK PRIMARY KEY (CHNG_HIST_ID)
);

CREATE OR REPLACE SYNONYM appsro.XXDBL_DEBT_MNGT_CHNG_HIST FOR xxdbl.XXDBL_DEBT_MNGT_CHNG_HIST;

CREATE OR REPLACE SYNONYM apps.XXDBL_DEBT_MNGT_CHNG_HIST FOR xxdbl.XXDBL_DEBT_MNGT_CHNG_HIST;

GRANT INSERT, SELECT, UPDATE, DELETE
    ON XXDBL.XXDBL_DEBT_MNGT_CHNG_HIST
    TO APPSDBL;
    
GRANT ALTER,
      DELETE,
      INDEX,
      INSERT,
      REFERENCES,
      SELECT,
      UPDATE,
      ON COMMIT REFRESH,
      QUERY REWRITE,
      READ,
      DEBUG,
      FLASHBACK
    ON XXDBL.XXDBL_DEBT_MNGT_CHNG_HIST
    TO APPS
    WITH GRANT OPTION;