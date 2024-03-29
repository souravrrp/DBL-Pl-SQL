/* Formatted on 30-Mar-19 10:24:31 (QP5 v5.136.908.31019) */
  SELECT AC.CUSTOMER_NUMBER,
         AC.CUSTOMER_NAME,
         AC.CUSTOMER_CATEGORY_CODE CUST_CATEGORY,
         AC.CUSTOMER_TYPE C_TYPE,
         HL.ADDRESS1,
         OHA.ORDER_NUMBER,
         OTT.NAME ORDER_TYPE,
         TRUNC (OHA.ORDERED_DATE) ORDERED_DATE,
         TRUNC (OLA.ACTUAL_SHIPMENT_DATE) INVOICE_DATE,
         OHA.SHIPMENT_PRIORITY_CODE PRIORITY,
         OLA.FREIGHT_TERMS_CODE FREIGHT,
         CASE
            WHEN OLA.FREIGHT_TERMS_CODE = 'DEALER'
                 AND OTT.TRANSACTION_TYPE_ID NOT IN (1006, 1014)
            THEN
               OLA.ORDERED_QUANTITY * .8
            ELSE
               0
         END
            Freight_Charge,
         OHA.FLOW_STATUS_CODE,
         OLA.FLOW_STATUS_CODE,
         OLA.ORDERED_ITEM,
         MSI.DESCRIPTION,
         OHA.SHIPPING_INSTRUCTIONS,
         OLA.SHIPPING_INSTRUCTIONS LINE_INSTRUCTIONS,
         OHA.CUST_PO_NUMBER,
         OLA.PREFERRED_GRADE,
         CAT.SEGMENT2 ITEM_SIZE,
         CAT.CATEGORY_CONCAT_SEGS PRODUCT_CATEGORY,
         CAY.SEGMENT3 PRODUCT_TYPE,
         OLA.ORDERED_QUANTITY,
         OLA.ORDER_QUANTITY_UOM,
         OLA.UNIT_LIST_PRICE,
         OLA.UNIT_SELLING_PRICE,
         OLA.ORDERED_QUANTITY2,
         OLA.ORDERED_QUANTITY_UOM2,
         OLA.SHIPPED_QUANTITY,
         OLA.SHIPPED_QUANTITY2,
         (OLA.UNIT_LIST_PRICE - OLA.UNIT_SELLING_PRICE) * OLA.ORDERED_QUANTITY
            LINE_DISCOUNT,
         RSV.RESOURCE_NAME
    FROM OE_ORDER_HEADERS_ALL OHA,
         OE_ORDER_LINES_ALL OLA,
         APPS.OE_TRANSACTION_TYPES_TL OTT,
         INV.MTL_SYSTEM_ITEMS_B MSI,
         AR_CUSTOMERS AC,
         APPS.HZ_CUST_ACCOUNTS HCA,
         APPS.HZ_CUST_ACCT_SITES_ALL HCASA,
         APPS.HZ_PARTY_SITES HPS,
         APPS.HZ_CUST_SITE_USES_ALL HCSUA,
         APPS.HZ_LOCATIONS HL,
         MTL_ITEM_CATEGORIES_V CAT,
         MTL_ITEM_CATEGORIES_V CAY,
         JTF_RS_SALESREPS SAL,
         JTF_RS_DEFRESOURCES_V RSV,
         XXDBL_COMPANY_LE_MAPPING_V CLM
   WHERE     OHA.HEADER_ID = OLA.HEADER_ID
         AND OHA.ORG_ID = OLA.ORG_ID
         AND OHA.ORDER_TYPE_ID = OTT.TRANSACTION_TYPE_ID
         AND OLA.INVENTORY_ITEM_ID = MSI.INVENTORY_ITEM_ID
         AND OLA.SHIP_FROM_ORG_ID = MSI.ORGANIZATION_ID
         AND MSI.INVENTORY_ITEM_ID = CAT.INVENTORY_ITEM_ID
         AND MSI.INVENTORY_ITEM_ID = CAY.INVENTORY_ITEM_ID
         AND AC.CUSTOMER_ID = HCA.CUST_ACCOUNT_ID
         AND CAT.CATEGORY_SET_NAME = 'DBL_SALES_CAT_SET'
         AND CAY.CATEGORY_SET_NAME = 'Inventory'
         AND CAY.ORGANIZATION_ID = 152
         AND CAT.ORGANIZATION_ID = 152
         AND OHA.SALESREP_ID = SAL.SALESREP_ID
         AND SAL.RESOURCE_ID = RSV.RESOURCE_ID
         AND SAL.ORG_ID = OHA.ORG_ID
         --AND HCA.STATUS = 'A'
         AND HCA.CUST_ACCOUNT_ID = HCASA.CUST_ACCOUNT_ID(+)
         AND HCASA.STATUS = 'A'
         AND HCSUA.STATUS = 'A'
         AND HCASA.PARTY_SITE_ID = HPS.PARTY_SITE_ID
         AND HCSUA.CUST_ACCT_SITE_ID = HCASA.CUST_ACCT_SITE_ID
         AND CLM.ORG_ID = HCSUA.ORG_ID
         AND HPS.LOCATION_ID = HL.LOCATION_ID
         AND OHA.SOLD_TO_ORG_ID = HCA.CUST_ACCOUNT_ID
         AND OHA.SHIP_TO_ORG_ID = HCSUA.SITE_USE_ID
         --AND OHA.FLOW_STATUS_CODE = 'BOOKED'
         --AND OLA.FLOW_STATUS_CODE NOT IN ('CANCELLED')
         AND OHA.ORG_ID = 126
         AND OHA.ORG_ID = :P_ORG_ID
         AND (:P_PRODUCT_CATEGORY IS NULL
              OR CAT.CATEGORY_CONCAT_SEGS = :P_PRODUCT_CATEGORY)
         AND (:P_PRODUCT_TYPE IS NULL OR CAY.SEGMENT3 = :P_PRODUCT_TYPE)
         AND (:P_ITEM_GRADE IS NULL OR OLA.PREFERRED_GRADE = :P_ITEM_GRADE)
         AND (:P_CUSTOMER_CATEGORY IS NULL
              OR AC.CUSTOMER_CATEGORY_CODE = :P_CUSTOMER_CATEGORY)
         AND (:P_SALES_PERSON IS NULL OR OHA.SALESREP_ID = :P_SALES_PERSON)
         AND (:P_CUSTOMER_ID IS NULL OR AC.CUSTOMER_ID = :P_CUSTOMER_ID)
         AND (:P_ORDER_NUMBER IS NULL OR OHA.ORDER_NUMBER = :P_ORDER_NUMBER)
         AND TRUNC (ORDERED_DATE) BETWEEN :P_DATE_FROM AND :P_DATE_TO
ORDER BY AC.CUSTOMER_NUMBER