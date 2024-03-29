/* Formatted on 9/18/2021 12:05:02 PM (QP5 v5.354) */
CREATE TABLE XX_APEX.XXAPEX_ORD_GRN_TRACKING
(
    OM_GRN_TRACK_ID      INTEGER
                            GENERATED ALWAYS AS IDENTITY
                                (          START WITH 1 INCREMENT BY 1)
                            NOT NULL,
    CREATION_DATE        DATE,
    CREATED_BY           NUMBER,
    LAST_UPDATE_DATE     DATE,
    LAST_UPDATED_BY      NUMBER,
    LAST_UPDATE_LOGIN    NUMBER,
    UNIT_NAME            VARCHAR2 (240 BYTE),
    PO_NUMBER            VARCHAR2 (20 BYTE),
    PO_DATE              DATE,
    CONSTRAINT ORD_GRN_TRCK_PK PRIMARY KEY (OM_GRN_TRACK_ID)
);


CREATE OR REPLACE SYNONYM APPSRO.XXAPEX_ORD_GRN_TRACKING FOR XX_APEX.XXAPEX_ORD_GRN_TRACKING;

CREATE OR REPLACE SYNONYM APPS.XXAPEX_ORD_GRN_TRACKING FOR XX_APEX.XXAPEX_ORD_GRN_TRACKING;

GRANT ALTER, SELECT
    ON XX_APEX.XXAPEX_ORD_GRN_TRACKING
    TO APPS
    WITH GRANT OPTION;

GRANT INSERT, SELECT, UPDATE, DELETE
    ON XX_APEX.XXAPEX_ORD_GRN_TRACKING
    TO APPSDBL;
    
DROP TABLE XX_APEX.XXAPEX_ORD_GRN_TRACKING CASCADE CONSTRAINTS;