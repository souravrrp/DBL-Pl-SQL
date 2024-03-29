/* Formatted on 8/27/2020 10:20:38 AM (QP5 v5.287) */
CREATE TABLE XXDBL.XXDBL_ITEM_ALOC_BASIS_STG
(
   SL_NO                NUMBER NOT NULL,
   CREATION_DATE        DATE,
   CREATED_BY           NUMBER,
   ORGANIZATION_CODE    VARCHAR2 (10 BYTE),
   ITEM_CODE            VARCHAR2 (100 BYTE),
   ALLOC_CODE           VARCHAR2 (100 BYTE),
   BASIS_TYPE           VARCHAR2 (100 BYTE),
   COST_ANALYSIS_CODE   VARCHAR2 (10 BYTE),
   STATUS               VARCHAR2 (10 BYTE),
   STATUS_MESSAGE       VARCHAR2 (240 BYTE),
   SET_PROC_ID          VARCHAR2 (50 BYTE),
   CONSTRAINT IDX_ITM_ALOC_BS PRIMARY KEY (SL_NO)
);

CREATE UNIQUE INDEX XXDBL.IDX_ITM_ALOC_BS
   ON XXDBL.XXDBL_ITEM_ALOC_BASIS_STG (SL_NO)
   LOGGING
   TABLESPACE XXDBL_TS_TX_DATA
   PCTFREE 10
   INITRANS 2
   MAXTRANS 255
   STORAGE (INITIAL 64 K
            NEXT 1 M
            MAXSIZE UNLIMITED
            MINEXTENTS 1
            MAXEXTENTS UNLIMITED
            PCTINCREASE 0
            BUFFER_POOL DEFAULT);

ALTER TABLE XXDBL.XXDBL_ITEM_ALOC_BASIS_STG ADD (
  CONSTRAINT IDX_ITM_ALOC_BS
  PRIMARY KEY
  (SL_NO)
  USING INDEX XXDBL.IDX_ITM_ALOC_BS
  ENABLE VALIDATE);

GRANT SELECT ON XXDBL.XXDBL_ITEM_ALOC_BASIS_STG TO APPS WITH GRANT OPTION;

GRANT SELECT ON XXDBL.XXDBL_ITEM_ALOC_BASIS_STG TO APPSRO;

CREATE OR REPLACE SYNONYM APPS.XXDBL_ITEM_ALOC_BASIS_STG FOR XXDBL.XXDBL_ITEM_ALOC_BASIS_STG;

DROP TABLE XXDBL.XXDBL_ITEM_ALOC_BASIS_STG;

------------------------------------------------------------------------------------

CREATE TABLE XXDBL.XXDBL_CER_FORMULA_UPD_STG
(
  RECORD_TYPE                VARCHAR2(1 BYTE),
  FORMULA_NO                 VARCHAR2(32 BYTE),
  FORMULA_VERS               NUMBER,
  FORMULA_TYPE               VARCHAR2(10 BYTE),
  FORMULA_DESC1              VARCHAR2(240 BYTE),
  FORMULA_DESC2              VARCHAR2(240 BYTE),
  FORMULA_CLASS              VARCHAR2(32 BYTE),
  FMCONTROL_CLASS            VARCHAR2(32 BYTE),
  INACTIVE_IND               NUMBER,
  OWNER_ORGANIZATION_CODE    VARCHAR2(10 BYTE),
  TOTAL_INPUT_QTY            NUMBER,
  TOTAL_OUTPUT_QTY           NUMBER,
  YIELD_UOM                  VARCHAR2(3 BYTE),
  FORMULA_STATUS             VARCHAR2(30 BYTE),
  OWNER_CODE                 VARCHAR2(30 BYTE),
  FORMULA_ID                 NUMBER,
  FORMULALINE_ID             NUMBER,
  LINE_TYPE                  VARCHAR2(30 BYTE),
  LINE_NO                    NUMBER,
  ITEM_NO                    VARCHAR2(2000 BYTE),
  INVENTORY_ITEM_ID          NUMBER,
  REVISION                   VARCHAR2(3 BYTE),
  QTY                        NUMBER,
  DETAIL_UOM                 VARCHAR2(3 BYTE),
  MASTER_FORMULA_ID          NUMBER,
  RELEASE_TYPE               NUMBER,
  SCRAP_FACTOR               VARCHAR2(10 BYTE),
  SCALE_TYPE_HDR             VARCHAR2(10 BYTE),
  SCALE_TYPE_DTL             NUMBER,
  COST_ALLOC                 NUMBER,
  PHANTOM_TYPE               NUMBER,
  REWORK_TYPE                VARCHAR2(1000 BYTE),
  BUFFER_IND                 NUMBER,
  BY_PRODUCT_TYPE            VARCHAR2(30 BYTE),
  INGREDIENT_END_DATE        DATE,
  ATTRIBUTE1                 VARCHAR2(240 BYTE),
  ATTRIBUTE2                 VARCHAR2(240 BYTE),
  ATTRIBUTE3                 VARCHAR2(240 BYTE),
  ATTRIBUTE4                 VARCHAR2(240 BYTE),
  ATTRIBUTE5                 VARCHAR2(240 BYTE),
  ATTRIBUTE6                 VARCHAR2(240 BYTE),
  ATTRIBUTE7                 VARCHAR2(240 BYTE),
  ATTRIBUTE8                 VARCHAR2(240 BYTE),
  ATTRIBUTE9                 VARCHAR2(240 BYTE),
  ATTRIBUTE10                VARCHAR2(240 BYTE),
  ATTRIBUTE11                VARCHAR2(240 BYTE),
  ATTRIBUTE12                VARCHAR2(240 BYTE),
  ATTRIBUTE13                VARCHAR2(240 BYTE),
  ATTRIBUTE14                VARCHAR2(240 BYTE),
  ATTRIBUTE15                VARCHAR2(240 BYTE),
  ATTRIBUTE16                VARCHAR2(240 BYTE),
  ATTRIBUTE17                VARCHAR2(240 BYTE),
  ATTRIBUTE18                VARCHAR2(240 BYTE),
  ATTRIBUTE19                VARCHAR2(240 BYTE),
  ATTRIBUTE20                VARCHAR2(240 BYTE),
  ATTRIBUTE21                VARCHAR2(240 BYTE),
  ATTRIBUTE22                VARCHAR2(240 BYTE),
  ATTRIBUTE23                VARCHAR2(240 BYTE),
  ATTRIBUTE24                VARCHAR2(240 BYTE),
  ATTRIBUTE25                VARCHAR2(240 BYTE),
  ATTRIBUTE26                VARCHAR2(240 BYTE),
  ATTRIBUTE27                VARCHAR2(240 BYTE),
  ATTRIBUTE28                VARCHAR2(240 BYTE),
  ATTRIBUTE29                VARCHAR2(240 BYTE),
  ATTRIBUTE30                VARCHAR2(240 BYTE),
  DTL_ATTRIBUTE1             VARCHAR2(240 BYTE),
  DTL_ATTRIBUTE2             VARCHAR2(240 BYTE),
  DTL_ATTRIBUTE3             VARCHAR2(240 BYTE),
  DTL_ATTRIBUTE4             VARCHAR2(240 BYTE),
  DTL_ATTRIBUTE5             VARCHAR2(240 BYTE),
  DTL_ATTRIBUTE6             VARCHAR2(240 BYTE),
  DTL_ATTRIBUTE7             VARCHAR2(240 BYTE),
  DTL_ATTRIBUTE8             VARCHAR2(240 BYTE),
  DTL_ATTRIBUTE9             VARCHAR2(240 BYTE),
  DTL_ATTRIBUTE10            VARCHAR2(240 BYTE),
  DTL_ATTRIBUTE11            VARCHAR2(240 BYTE),
  DTL_ATTRIBUTE12            VARCHAR2(240 BYTE),
  DTL_ATTRIBUTE13            VARCHAR2(240 BYTE),
  DTL_ATTRIBUTE14            VARCHAR2(240 BYTE),
  DTL_ATTRIBUTE15            VARCHAR2(240 BYTE),
  DTL_ATTRIBUTE16            VARCHAR2(240 BYTE),
  DTL_ATTRIBUTE17            VARCHAR2(240 BYTE),
  DTL_ATTRIBUTE18            VARCHAR2(240 BYTE),
  DTL_ATTRIBUTE19            VARCHAR2(240 BYTE),
  DTL_ATTRIBUTE20            VARCHAR2(240 BYTE),
  DTL_ATTRIBUTE21            VARCHAR2(240 BYTE),
  DTL_ATTRIBUTE22            VARCHAR2(240 BYTE),
  DTL_ATTRIBUTE23            VARCHAR2(240 BYTE),
  DTL_ATTRIBUTE24            VARCHAR2(240 BYTE),
  DTL_ATTRIBUTE25            VARCHAR2(240 BYTE),
  DTL_ATTRIBUTE26            VARCHAR2(240 BYTE),
  DTL_ATTRIBUTE27            VARCHAR2(240 BYTE),
  DTL_ATTRIBUTE28            VARCHAR2(240 BYTE),
  DTL_ATTRIBUTE29            VARCHAR2(240 BYTE),
  DTL_ATTRIBUTE30            VARCHAR2(240 BYTE),
  ATTRIBUTE_CATEGORY         VARCHAR2(30 BYTE),
  DTL_ATTRIBUTE_CATEGORY     VARCHAR2(30 BYTE),
  TPFORMULA_ID               NUMBER,
  IAFORMULA_ID               NUMBER,
  SCALE_MULTIPLE             VARCHAR2(1000 BYTE),
  CONTRIBUTE_YIELD_IND       VARCHAR2(3 BYTE),
  SCALE_UOM                  VARCHAR2(4 BYTE),
  CONTRIBUTE_STEP_QTY_IND    VARCHAR2(3 BYTE),
  SCALE_ROUNDING_VARIANCE    NUMBER,
  ROUNDING_DIRECTION         VARCHAR2(2 BYTE),
  TEXT_CODE_HDR              NUMBER,
  TEXT_CODE_DTL              NUMBER,
  USER_ID                    NUMBER,
  CREATION_DATE              DATE,
  CREATED_BY                 NUMBER(15),
  LAST_UPDATED_BY            NUMBER(15),
  LAST_UPDATE_DATE           DATE,
  LAST_UPDATE_LOGIN          NUMBER(15),
  USER_NAME                  VARCHAR2(100 BYTE),
  DELETE_MARK                NUMBER,
  AUTO_PRODUCT_CALC          VARCHAR2(1 BYTE),
  PROD_PERCENT               NUMBER,
  PROD_OR_INGR_SCALE_TYPE    VARCHAR2(30 BYTE),
  YIELD_OR_CONSUMPTION_TYPE  VARCHAR2(30 BYTE),
  VERIFY_FLAG                VARCHAR2(2 BYTE),
  ERROR_MSG                  VARCHAR2(4000 BYTE),
  ROUTING_NO                 VARCHAR2(32 BYTE),
  MATERIAL_ASSIGNMENT_STEP   VARCHAR2(1000 BYTE),
  OPERATION_NO               NUMBER,
  AT                         VARCHAR2(1000 BYTE),
  BATCH_NUMBER               NUMBER
)
TABLESPACE XXDBL_TS_TX_DATA
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
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


CREATE OR REPLACE PUBLIC SYNONYM XXDBL_CER_FORMULA_UPD_STG FOR XXDBL.XXDBL_CER_FORMULA_UPD_STG;
