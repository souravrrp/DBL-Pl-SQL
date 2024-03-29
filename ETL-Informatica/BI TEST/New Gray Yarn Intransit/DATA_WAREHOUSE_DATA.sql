/* Formatted on 2/12/2020 10:02:23 AM (QP5 v5.287) */
SELECT --MIC.*
       MMT.*
  FROM W_MTL_ITEM_CATEGORIES_V MIC,
       W_MTL_SYSTEM_ITEMS_B MIS,
       W_MTL_TRANSACTION_TYPES MTT,
       W_ORG_ORGANIZATION_DEFINITIONS OOD,
       W_MTL_MATERIAL_TRANSACTIONS MMT
 WHERE     1 = 1
       AND MIC.INVENTORY_ITEM_ID = MIS.INVENTORY_ITEM_ID
       AND MIC.ORGANIZATION_ID = MIS.ORGANIZATION_ID
       AND OOD.ORGANIZATION_ID = MIS.ORGANIZATION_ID
       AND MMT.INVENTORY_ITEM_ID = MIS.INVENTORY_ITEM_ID
       AND MMT.ORGANIZATION_ID = MIS.ORGANIZATION_ID
       AND MTT.TRANSACTION_TYPE_ID = MMT.TRANSACTION_TYPE_ID
       --AND MMT.TRANSACTION_ID=2427143
       AND MIC.SEGMENT2 = 'RAW MATERIAL'
       AND MIC.SEGMENT3 = 'YARN'
       AND TO_DATE (MMT.TRANSACTION_DATE, 'DD/MM/RRRR hh12:mi:ssAM') BETWEEN TO_DATE ( :p_StartDate, 'DD/MM/RRRR hh12:mi:ssAM') AND TO_DATE ( :p_EndDate, 'DD/MM/RRRR hh12:mi:ssAM')
       --ORDER BY MMT.TRANSACTION_DATE DESC