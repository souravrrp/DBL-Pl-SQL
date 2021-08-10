/* Formatted on 7/28/2020 3:34:21 PM (QP5 v5.287) */
  SELECT OU_NAME,
         ORG_ID,
         ORGANIZATION_NAME,
         REQUEST_NUMBER,
         REQUISITION_NUMBER,
         PR_APPROVED_DATE,
         PO_NUMBER,
         SHIP_NUM,
         SHIP_DATE,
         LC_NUMBER,
         LC_OPENING_DATE,
         --currency_code,
         BANK_NAME,
         APPROVE_STATUS,
         PO_APPROVED_DATE,
         TRUNC (PO_APPROVED_DATE) - TRUNC (PR_APPROVED_DATE)
             "PR_to_pay_L",
         SUPPLIER_ID
             SUPPLIER_NUM,
         SUPPLIER_NAME,
         ITEM_CODE,
         ITEM_NAME,
         ITEM_CATEGORY_1,
         ITEM_CATEGORY_2,
         ITEM_CATEGORY_3,
         ITEM_CATEGORY_4,
         CURRENCY_CODE,
         UOM,
         PR_QUANTITY,
         PR_PRICE,
         PO_QUANTITY,
         QUANTITY_BILLED,
         PO_PRICE,
         RECEIPT_NUM,
         GRN_DATE,
         TRUNC (GRN_DATE) - TRUNC (PO_APPROVED_DATE)
             "GRN Lead_time",
         GRN_QUANTITY,
         INVOICE_NUM,
         ITN,
         VOUCHER_NUMBER,
         INVOICE_DATE,
         TRUNC (INVOICE_DATE) - TRUNC (GRN_DATE)
             "Invoice_L",
         PAYMENT_VOUCHER,
         PAYMENT_DATE,
         TRUNC (INVOICE_DATE) - TRUNC (PAYMENT_DATE)
             "Inv_Pay_L",
         BANK_ACCOUNT_NAME,
         PAYMENT_VOUCHER_DATE,
         PAID_DATE,
         PR_CREATED_BY,
         APPS.XX_COM_PKG.GET_EMP_NAME_FROM_USER_ID (PR_CREATED_BY)
             AS PR_CREATED_NAME,
         PO_CREATED_BY,
         APPS.XX_COM_PKG.GET_EMP_NAME_FROM_USER_ID (PO_CREATED_BY)
             AS PO_CREATED_NAME,
         INVOICE_CREATED_BY,
         APPS.XX_COM_PKG.GET_EMP_NAME_FROM_USER_ID (INVOICE_CREATED_BY)
             AS INV_CREATED_NAME,
         PAYMENT_CREATED_BY,
         APPS.XX_COM_PKG.GET_EMP_NAME_FROM_USER_ID (PAYMENT_CREATED_BY)
             AS PAY_CREATED_NAME
    FROM APPS.XXDBL_PR_TO_PAY p2p
   WHERE     ( :P_LEGAL IS NULL OR LEGAL_ENTITY_ID = :P_LEGAL)
         AND ( :P_ORG_ID IS NULL OR ORG_ID = :P_ORG_ID)
         AND (   :P_REQUISITION_NUMBER IS NULL
              OR REQUISITION_NUMBER = :P_REQUISITION_NUMBER)
         AND ( :P_PO_NUMBER IS NULL OR PO_NUMBER = :P_PO_NUMBER)
         AND ( :P_LC_NUMBER IS NULL OR LC_NUMBER = :P_LC_NUMBER)
         AND ( :P_SUPPLIER IS NULL OR SUPPLIER_NAME = :P_SUPPLIER)
         AND ( :P_GRN IS NULL OR RECEIPT_NUM = :P_GRN)
         AND ( :P_CATEGORY IS NULL OR ITEM_CATEGORY_1 = :P_CATEGORY)
         AND ( :P_CATEGORY_2 IS NULL OR ITEM_CATEGORY_2 = :P_CATEGORY_2)
         AND ( :P_CATEGORY_3 IS NULL OR ITEM_CATEGORY_3 = :P_CATEGORY_3)
         AND ( :P_INV_VOUHCER IS NULL OR VOUCHER_NUMBER = :P_INV_VOUHCER)
         AND ( :P_PAY_VOUCHER IS NULL OR PAYMENT_VOUCHER = :P_PAY_VOUCHER)
         AND (   :P_PR_DATE_FROM IS NULL
              OR TRUNC (PR_APPROVED_DATE) BETWEEN TRUNC ( :P_PR_DATE_FROM)
                                              AND TRUNC ( :P_PR_DATE_TO))
         AND (   :P_PO_DATE_FROM IS NULL
              OR TRUNC (PO_APPROVED_DATE) BETWEEN TRUNC ( :P_PO_DATE_FROM)
                                              AND TRUNC ( :P_PO_DATE_TO))
         AND (   :P_GRN_DATE_FROM IS NULL
              OR TRUNC (GRN_DATE) BETWEEN TRUNC ( :P_GRN_DATE_FROM)
                                      AND TRUNC ( :P_GRN_DATE_TO))
         AND (   :P_INV_DATE_FROM IS NULL
              OR TRUNC (INVOICE_DATE) BETWEEN TRUNC ( :P_INV_DATE_FROM)
                                          AND TRUNC ( :P_INV_DATE_TO))
         AND (   :P_LC_DATE_FORM IS NULL
              OR TRUNC (LC_OPENING_DATE) BETWEEN TRUNC ( :P_LC_DATE_FORM)
                                             AND TRUNC ( :P_LC_DATE_TO))
         AND ( :P_PR_CREATED_BY IS NULL OR PR_CREATED_BY = :P_PR_CREATED_BY)
         AND ( :P_PO_CREATED_BY IS NULL OR PR_CREATED_BY = :P_PO_CREATED_BY)
ORDER BY ORG_ID, REQUISITION_NUMBER, PO_NUMBER;