/* Formatted on 7/7/2020 1:59:48 PM (QP5 v5.287) */
  SELECT OOD.ORGANIZATION_NAME,
         OOD.ORGANIZATION_CODE,
         --OOD.OPERATING_UNIT,
         --OOD.ORGANIZATION_ID,
         --OHQD.SUBINVENTORY_CODE,
         --MSI.DESCRIPTION SUBINVENTORY_NAME,
         MSIB.SEGMENT1 ITEM_CODE,
         MSIB.DESCRIPTION,
         OHQD.LOT_NUMBER,
         CAT.SEGMENT2 ITEM_CATEGORY,
         CAT.SEGMENT3 ITEM_TYPE,
         --OHQD.INVENTORY_ITEM_ID,
         SUM (OHQD.PRIMARY_TRANSACTION_QUANTITY) AS ONHAND_QTY,
         OHQD.TRANSACTION_UOM_CODE UOM_CODE,
         ' ' EXPIRY_DATE
    FROM APPS.MTL_ONHAND_QUANTITIES_DETAIL OHQD,
         APPS.ORG_ORGANIZATION_DEFINITIONS OOD,
         --APPS.MTL_SECONDARY_INVENTORIES MSI,
         APPS.MTL_SYSTEM_ITEMS_B MSIB,
         APPS.MTL_ITEM_CATEGORIES_V CAT
   WHERE     1 = 1
         AND MSIB.ORGANIZATION_ID = OOD.ORGANIZATION_ID
         AND OHQD.ORGANIZATION_ID = OOD.ORGANIZATION_ID
         AND OHQD.INVENTORY_ITEM_ID = MSIB.INVENTORY_ITEM_ID
         --AND OOD.OPERATING_UNIT IN (131)
         AND OOD.ORGANIZATION_CODE IN ('191','193','201','181','183','171')
         --AND OOD.ORGANIZATION_NAME IN ('MYMUN TEXTILES LTD- IO','DB TEX LTD- IO','HAMZA TEXTILES LTD DYEING- IO', 'HAMZA TEXTILES LTD KNITTING- IO', 'COLOR CITY LTD 1- IO', 'COLOR CITY LTD 2- IO')
         AND CAT.SEGMENT2 = 'RAW MATERIAL'
         AND CAT.SEGMENT3 IN ('CHEMICAL', 'DYES')
         --AND MSIB.SEGMENT1 IN ('CMNT.SBAG.0001')
         AND MSIB.INVENTORY_ITEM_ID = CAT.INVENTORY_ITEM_ID
         AND MSIB.ORGANIZATION_ID = CAT.ORGANIZATION_ID
GROUP BY MSIB.SEGMENT1,
         MSIB.DESCRIPTION,
         --OHQD.INVENTORY_ITEM_ID,
         OHQD.LOT_NUMBER,
         --OHQD.SUBINVENTORY_CODE,
         --MSI.DESCRIPTION,
         OHQD.TRANSACTION_UOM_CODE,
         --OOD.ORGANIZATION_ID,
         --OOD.OPERATING_UNIT,
         CAT.SEGMENT2,
         CAT.SEGMENT3,
         OOD.ORGANIZATION_CODE,
         OOD.ORGANIZATION_NAME
ORDER BY ORGANIZATION_CODE;