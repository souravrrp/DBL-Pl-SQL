/* Formatted on 5/25/2021 5:06:17 PM (QP5 v5.354) */
  SELECT MSI.SEGMENT1                             ITM_CODE,
         MSI.ATTRIBUTE1                           AS "Legacy Code",
         MIC.SEGMENT2                             ITEM_CATG,
         MIC.SEGMENT3                             ITM_TYPE,
         MSI.DESCRIPTION,
         ORG.ORGANIZATION_CODE,
         ORG.ORGANIZATION_NAME,
         SI.SECONDARY_INVENTORY_NAME,
         -- MMT.inventory_item_id,
         MMT.ORGANIZATION_ID,
         MSI.PRIMARY_UOM_CODE,
         MSI.SECONDARY_UOM_CODE,
         --lot_number,
         SUM (PRIMARY_QUANTITY)                   ON_HAND,
         SUM (SECONDARY_TRANSACTION_QUANTITY)     "Secondary"
    FROM MTL_MATERIAL_TRANSACTIONS   MMT,
         ORG_ORGANIZATION_DEFINITIONS ORG,
         MTL_SYSTEM_ITEMS_B          MSI,
         MTL_ITEM_CATEGORIES_V       MIC,
         MTL_SECONDARY_INVENTORIES   SI,
         XXDBL_COMPANY_LE_MAPPING_V  OU,
         HR_OPERATING_UNITS          HOU
   WHERE     1 = 1
         AND MMT.ORGANIZATION_ID = ORG.ORGANIZATION_ID
         AND HOU.ORGANIZATION_ID = ORG.OPERATING_UNIT
         AND ORG.OPERATING_UNIT = OU.ORG_ID
         AND MMT.ORGANIZATION_ID = MSI.ORGANIZATION_ID
         AND MMT.INVENTORY_ITEM_ID = MSI.INVENTORY_ITEM_ID
         AND MMT.ORGANIZATION_ID = MIC.ORGANIZATION_ID
         AND MMT.INVENTORY_ITEM_ID = MIC.INVENTORY_ITEM_ID
         AND MMT.ORGANIZATION_ID = SI.ORGANIZATION_ID
         AND MSI.ORGANIZATION_ID = SI.ORGANIZATION_ID
         AND MIC.ORGANIZATION_ID = SI.ORGANIZATION_ID
         AND MMT.SUBINVENTORY_CODE = SI.SECONDARY_INVENTORY_NAME
         AND MIC.CATEGORY_SET_ID = 1
         AND ORG.ORGANIZATION_CODE =
             NVL ( :P_ORGANIZATION_CODE, ORG.ORGANIZATION_CODE)
         AND MSI.SEGMENT1 = NVL ( :P_ITEM_CODE, MSI.SEGMENT1)
         AND MMT.SUBINVENTORY_CODE =
             NVL ( :P_SUBINVENTORY, MMT.SUBINVENTORY_CODE)
         AND MIC.SEGMENT2 = NVL ( :P_ITEM_CATGORY, MIC.SEGMENT2)
         AND MIC.SEGMENT3 = NVL ( :P_ITEM_TYPE, MIC.SEGMENT3)
         --  AND MMT.transaction_date <= NVL (:P_date_to, SYSDATE) + .99999 --'MSML-SPCNS'
         AND MMT.TRANSACTION_DATE <= NVL ( :P_DATE_TO, SYSDATE) + .99999
         --  AND MMT.TRANSACTION_TYPE_ID <> 98
         AND SI.DISABLE_DATE IS NULL
--   AND (LOGICAL_TRANSACTION = 2 OR LOGICAL_TRANSACTION IS NULL)
--   AND MMT.TRANSACTION_TYPE_ID NOT IN (80, 98, 99, 120, 52, 26, 64) --'MSML-SPCNS'
--and msi.ATTRIBUTE_CATEGORY='Maintain Items'
GROUP BY MMT.INVENTORY_ITEM_ID,
         MMT.ORGANIZATION_ID,
         ORG.ORGANIZATION_CODE,
         ORG.ORGANIZATION_NAME,
         SI.SECONDARY_INVENTORY_NAME,
         MSI.PRIMARY_UOM_CODE,
         MSI.SECONDARY_UOM_CODE,
         MSI.SEGMENT1,
         MSI.DESCRIPTION,
         --         lot_number,
         MIC.SEGMENT2,
         MIC.SEGMENT3,
         MSI.ATTRIBUTE1
  HAVING SUM (PRIMARY_QUANTITY) <> 0;

--------------------------------------------------------------------------------

  SELECT MSI.SEGMENT1 ITM_CODE,
         MSI.ATTRIBUTE1 AS "Legacy Code",
         MIL.SEGMENT1 AS "Locator",
         MIC.SEGMENT2 ITEM_CATG,
         MIC.SEGMENT3 ITM_TYPE,
         MSI.DESCRIPTION,
         ORG.ORGANIZATION_CODE,
         ORG.ORGANIZATION_NAME,
         SI.SECONDARY_INVENTORY_NAME,
         -- moq.inventory_item_id,
         MOQ.ORGANIZATION_ID,
         MSI.PRIMARY_UOM_CODE,
         MSI.SECONDARY_UOM_CODE,
         --lot_number,
         SUM (PRIMARY_QUANTITY) ON_HAND,
         SUM (SECONDARY_TRANSACTION_QUANTITY) "Secondary"
    FROM MTL_MATERIAL_TRANSACTIONS MOQ,           --mtl_onhand_quantities moq,
         ORG_ORGANIZATION_DEFINITIONS ORG,
         MTL_SYSTEM_ITEMS_B MSI,
         MTL_ITEM_CATEGORIES_V MIC,
         MTL_SECONDARY_INVENTORIES SI,
         INV.MTL_ITEM_LOCATIONS MIL,
         XXDBL_COMPANY_LE_MAPPING_V OU,
         HR_OPERATING_UNITS HOU
   WHERE     1 = 1
         AND MOQ.ORGANIZATION_ID = ORG.ORGANIZATION_ID
         AND HOU.ORGANIZATION_ID = ORG.OPERATING_UNIT
         AND ORG.OPERATING_UNIT = OU.ORG_ID
         AND MOQ.ORGANIZATION_ID = MSI.ORGANIZATION_ID
         AND MOQ.INVENTORY_ITEM_ID = MSI.INVENTORY_ITEM_ID
         AND MOQ.ORGANIZATION_ID = MIC.ORGANIZATION_ID
         AND MOQ.INVENTORY_ITEM_ID = MIC.INVENTORY_ITEM_ID
         AND MOQ.ORGANIZATION_ID = SI.ORGANIZATION_ID
         AND MSI.ORGANIZATION_ID = SI.ORGANIZATION_ID
         AND MIC.ORGANIZATION_ID = SI.ORGANIZATION_ID
         AND MOQ.SUBINVENTORY_CODE = SI.SECONDARY_INVENTORY_NAME
         AND MIC.CATEGORY_SET_ID = 1
         AND ORG.ORGANIZATION_CODE = NVL ( :P_ORGANIZATION_CODE, ORG.ORGANIZATION_CODE)
         AND MSI.SEGMENT1 = NVL ( :P_ITEM_CODE, MSI.SEGMENT1)
         AND MOQ.SUBINVENTORY_CODE = NVL ( :P_SUBINVENTORY, MOQ.SUBINVENTORY_CODE)
         AND MIL.SEGMENT1 = NVL ( :P_LOCATOR_NAME, MIL.SEGMENT1)
         AND MIC.SEGMENT2 = NVL ( :P_ITEM_CATGORY, MIC.SEGMENT2)
         AND MIC.SEGMENT3 = NVL ( :P_ITEM_TYPE, MIC.SEGMENT3)
         --  AND moq.transaction_date <= NVL (:P_date_to, SYSDATE) + .99999 --'MSML-SPCNS'
         AND MOQ.TRANSACTION_DATE <= NVL ( :P_DATE_TO, SYSDATE) + .99999
         --  AND moq.TRANSACTION_TYPE_ID <> 98
         AND SI.DISABLE_DATE IS NULL
         AND MOQ.LOCATOR_ID = MIL.INVENTORY_LOCATION_ID(+)
--   AND (LOGICAL_TRANSACTION = 2 OR LOGICAL_TRANSACTION IS NULL)
--   AND moq.TRANSACTION_TYPE_ID NOT IN (80, 98, 99, 120, 52, 26, 64) --'MSML-SPCNS'
--and msi.ATTRIBUTE_CATEGORY='Maintain Items'
GROUP BY MOQ.INVENTORY_ITEM_ID,
         MOQ.ORGANIZATION_ID,
         ORG.ORGANIZATION_CODE,
         ORG.ORGANIZATION_NAME,
         SI.SECONDARY_INVENTORY_NAME,
         MSI.PRIMARY_UOM_CODE,
         MSI.SECONDARY_UOM_CODE,
         MSI.SEGMENT1,
         MSI.DESCRIPTION,
         --         lot_number,
         MIC.SEGMENT2,
         MIC.SEGMENT3,
         MSI.ATTRIBUTE1,
         MIL.SEGMENT1
  HAVING SUM (PRIMARY_QUANTITY) <> 0