/* Formatted on 7/13/2020 2:14:17 PM (QP5 v5.287) */
CREATE TABLE apps.xxdbl_ar_invoice_stg
(
   SL_NO                  NUMBER,
   ORGANIZATION_CODE      VARCHAR2 (10 BYTE),
   TRX_TYPE               VARCHAR2 (500 BYTE),
   CUST_TRX_TYPE_ID       NUMBER,
   BATCH_SOURCE_NAME      VARCHAR2 (500 BYTE),
   BATCH_SOURCE_ID        NUMBER,
   LINE_NUMBER            NUMBER,
   TRX_DATE               DATE,
   GL_DATE                DATE,
   CURRENCY_CODE          VARCHAR2 (3 BYTE),
   CUSTOMER_NUMBER        VARCHAR2 (10 BYTE),
   SALES_ORDER            NUMBER,
   ITEM_CODE              VARCHAR2 (50 BYTE),
   QUANTITY               NUMBER,
   UNIT_SELLING_PRICE     NUMBER,
   LINE_DESCRIPTION       VARCHAR2 (500 BYTE),
   FLAG                   VARCHAR2 (3 BYTE),
   OPERATING_UNIT         NUMBER,
   ORGANIZATION_ID        NUMBER,
   SET_OF_BOOKS           NUMBER,
   LEGAL_ENTITY_ID        NUMBER,
   ITEM_ID                NUMBER,
   ITEM_DESCRIPTION       VARCHAR2 (500 BYTE),
   UOM_CODE               VARCHAR2 (10 BYTE),
   AMOUNT                 NUMBER,
   CUSTOMER_ID            NUMBER,
   BILL_TO_SITE_ID        NUMBER,
   SHIP_TO_SITE_ID        NUMBER,
   TERM_ID                NUMBER,
   ORD_HEADER_ID          NUMBER,
   FREIGHT_TERMS_CODE     VARCHAR2 (50 BYTE),
   FREIGHT_CARRIER_CODE   VARCHAR2 (50 BYTE),
   SALESREP_ID            NUMBER,
   ORD_LINE_ID            NUMBER,
   ORDER_DATE             DATE,
   ORD_LINE_NUMBER        NUMBER,
   UNIT_LIST_PRICE        FLOAT,
   ACTUAL_SHIP_DATE       DATE,
   TERRITORY_ID           NUMBER,
   T_SEGMENT1             VARCHAR2 (500 BYTE),
   T_SEGMENT2             VARCHAR2 (500 BYTE),
   T_SEGMENT3             VARCHAR2 (500 BYTE),
   T_SEGMENT4             VARCHAR2 (500 BYTE),
   CHALLAN_DATE           DATE,
   BILL_CATEGORY          VARCHAR2 (50 BYTE),
   PO_NUMBER              VARCHAR2 (50 BYTE),
   PI_NUMBER              VARCHAR2 (50 BYTE),
   EXCHANCE_RATE          NUMBER
);

DELETE FROM xxdbl_ar_invoice_stg;

SELECT                                                                --SL_NO,
                                                   --       ORGANIZATION_CODE,
                                                   --       BATCH_SOURCE_NAME,
                                                         --       LINE_NUMBER,
                                                            --       TRX_DATE,
                                                             --       GL_DATE,
                                                       --       CURRENCY_CODE,
                                                     --       CUSTOMER_NUMBER,
                                                         --       SALES_ORDER,
                                                           --       ITEM_CODE,
                                                            --       QUANTITY,
                                                  --       UNIT_SELLING_PRICE,
                                                                --       FLAG,
                                                      --       OPERATING_UNIT,
                                                     --       ORGANIZATION_ID,
                                                        --       SET_OF_BOOKS,
                                                     --       LEGAL_ENTITY_ID,
                                                                   --       --
                                                             --       ITEM_ID,
                                                            --       UOM_CODE,
                                                              --       AMOUNT,
                                                                   --       --
                                                         --       CUSTOMER_ID,
                                                     --       BILL_TO_SITE_ID,
                                                     --       SHIP_TO_SITE_ID,
                                                             --       TERM_ID,
                                                                  --       ---
                                                       --       ORD_HEADER_ID,
                                             --       TRANSACTIONAL_CURR_CODE,
                                                  --       FREIGHT_TERMS_CODE,
                                                --       FREIGHT_CARRIER_CODE,
                                                         --       SALESREP_ID,
                                                         --       ORD_LINE_ID,
                                                     --       ORDERED_QUANTITY
     STG.*
FROM apps.xxdbl_ar_invoice_stg STG;


DROP TABLE APPS.xxdbl_ar_invoice_stg CASCADE CONSTRAINTS;