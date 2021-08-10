/* Formatted on 7/16/2020 9:46:40 AM (QP5 v5.287) */
  SELECT OOD.ORGANIZATION_CODE,
         ORGANIZATION_NAME,
         A.SEGMENT1 AS ITEM_CODE,
         DESCRIPTION,
         PRIMARY_UOM_CODE,
         SECONDARY_UOM_CODE,
         B.SEGMENT1 LINE_OF_BUSINESS,
         B.SEGMENT2 "Item_Category",
         B.SEGMENT3 "Item_Type"
    FROM APPS.MTL_SYSTEM_ITEMS_B_KFV A,
         APPS.MTL_ITEM_CATEGORIES_V B,
         APPS.ORG_ORGANIZATION_DEFINITIONS OOD
   WHERE     A.INVENTORY_ITEM_ID = B.INVENTORY_ITEM_ID
         AND A.ORGANIZATION_ID = B.ORGANIZATION_ID
         AND A.ORGANIZATION_ID = OOD.ORGANIZATION_ID
         AND CATEGORY_SET_ID = 1
         AND B.SEGMENT2 IN ('FINISH GOODS')
         AND A.INVENTORY_ITEM_STATUS_CODE = 'Active'
         AND B.SEGMENT3 = 'YARN'
         AND OOD.ORGANIZATION_CODE IN ('101')
ORDER BY 7