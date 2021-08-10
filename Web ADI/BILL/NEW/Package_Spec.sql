/* Formatted on 6/18/2020 6:02:14 PM (QP5 v5.287) */
CREATE OR REPLACE PACKAGE APPS.ar_bill_upload_adi_pkg
IS
   PROCEDURE import_data_to_ar_interface (ERRBUF OUT VARCHAR2, RETCODE OUT VARCHAR2);

   PROCEDURE upload_data_to_staging (P_SL_NO               NUMBER,
                                     P_OPERATING_UNIT      VARCHAR2,
                                     P_CUSTOMER_NUMBER     VARCHAR2,
                                     P_BILL_CURRENCY       VARCHAR2,
                                     P_BILL_CATEGORY       VARCHAR2,
                                     P_EXCHANCE_RATE       NUMBER,
                                     P_BILL_DATE           DATE,
                                     P_BILL_TYPE           VARCHAR2,
                                     P_CHALLAN_DATE        DATE,
                                     P_CHALLAN_QTY         NUMBER,
                                     P_ITEM_CODE           VARCHAR2,
                                     P_FINISHING_WEIGHT    NUMBER,
                                     P_PO_NUMBER           VARCHAR2,
                                     P_PI_NUMBER           VARCHAR2);
END ar_bill_upload_adi_pkg;
/