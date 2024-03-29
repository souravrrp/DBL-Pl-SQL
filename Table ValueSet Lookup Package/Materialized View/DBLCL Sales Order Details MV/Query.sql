/* Formatted on 8/24/2021 1:29:08 PM (QP5 v5.287) */
SELECT OHA.ORG_ID,
       CUST.CUSTOMER_NUMBER,
       CUST.CUSTOMER_NAME,
       CUST.CUSTOMER_CATEGORY_CODE CUST_CATEGORY,
       CUST.CUSTOMER_TYPE C_TYPE,
       CUST.ADDRESS1,
       OHA.ORDER_NUMBER,
       OTT.NAME ORDER_TYPE,
       TRUNC (OHA.ORDERED_DATE) ORDERED_DATE,
       TRUNC (OLA.ACTUAL_SHIPMENT_DATE) INVOICE_DATE,
       OHA.SHIPMENT_PRIORITY_CODE PRIORITY,
       OLA.FREIGHT_TERMS_CODE FREIGHT,
       CASE
          WHEN     OLA.FREIGHT_TERMS_CODE = 'DEALER'
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
       CAT.ITEM_SIZE ITEM_SIZE,
       CAT.PRODUCT_CATEGORY PRODUCT_CATEGORY,
       CAT.PRODUCT_TYPE PRODUCT_TYPE,
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
       RSV.RESOURCE_NAME,
       OHA.SALESREP_ID,
       CUST.CUSTOMER_ID
  FROM OE_ORDER_HEADERS_ALL OHA,
       OE_ORDER_LINES_ALL OLA,
       APPS.OE_TRANSACTION_TYPES_TL OTT,
       INV.MTL_SYSTEM_ITEMS_B MSI,
       XX_AR_CUSTOMER_SITE_V CUST,
       XXDBL_MTL_ITEM_CTG_INFO CAT,
       JTF_RS_SALESREPS SAL,
       JTF_RS_DEFRESOURCES_V RSV
 WHERE     OHA.HEADER_ID = OLA.HEADER_ID
       AND OHA.ORDER_TYPE_ID = OTT.TRANSACTION_TYPE_ID
       AND OLA.INVENTORY_ITEM_ID = MSI.INVENTORY_ITEM_ID
       AND OLA.SHIP_FROM_ORG_ID = MSI.ORGANIZATION_ID
       AND MSI.INVENTORY_ITEM_ID = CAT.INVENTORY_ITEM_ID
       AND MSI.ORGANIZATION_ID = CAT.ORGANIZATION_ID
       AND OHA.SALESREP_ID = SAL.SALESREP_ID
       AND OHA.ORG_ID = SAL.ORG_ID
       AND SAL.RESOURCE_ID = RSV.RESOURCE_ID
       AND CUST.ACCT_USE_STATUS = 'A'
       AND CUST.SITE_USE_STATUS = 'A'
       AND OLA.SOLD_TO_ORG_ID = CUST.CUSTOMER_ID
       AND OLA.SHIP_TO_ORG_ID = CUST.SHIP_TO_ORG_ID
       AND OHA.ORG_ID = 126;