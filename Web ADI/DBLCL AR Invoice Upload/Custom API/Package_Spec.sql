/* Formatted on 7/12/2020 12:53:34 PM (QP5 v5.287) */
CREATE OR REPLACE PACKAGE apps.ar_cust_trx_upld_adi_pkg
IS
   PROCEDURE import_data_to_ar_cust_trx (ERRBUF    OUT VARCHAR2,
                                         RETCODE   OUT VARCHAR2);


   --vl_prog_appl_id               NUMBER       :=apps.fnd_global.prog_appl_id;
   p_responsibility_id   NUMBER := apps.fnd_global.resp_id;
   p_respappl_id         NUMBER := apps.fnd_global.resp_appl_id;
   p_user_id             NUMBER := apps.fnd_global.user_id;
   p_org_id              NUMBER := apps.fnd_global.org_id;


   PROCEDURE ar_cust_trx_stg_upload (P_SL_NO                 NUMBER,
                                     P_ORGANIZATION_CODE     VARCHAR2,
                                     P_BATCH_SOURCE_NAME     VARCHAR2,
                                     P_TRX_TYPE              VARCHAR2,
                                     P_CUST_TRX_TYPE         VARCHAR2,
                                     P_LINE_NUMBER           NUMBER,
                                     P_TRX_DATE              DATE,
                                     P_GL_DATE               DATE,
                                     P_CURRENCY_CODE         VARCHAR2,
                                     P_CUSTOMER_NUMBER       VARCHAR2,
                                     P_ITEM_CODE             VARCHAR2,
                                     P_QUANTITY              NUMBER,
                                     P_UNIT_SELLING_PRICE    NUMBER,
                                     P_LINE_DESCRIPTION      VARCHAR2);
END ar_cust_trx_upld_adi_pkg;
/