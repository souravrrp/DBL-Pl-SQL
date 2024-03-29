---------------------------------MOVE HEADER----------------------------------------------
SELECT
TRX.TRANSACTION_TYPE_NAME
,TRX.MOVE_ORDER_TYPE_NAME
,H.REQUEST_NUMBER MOVE_ORDER
,H.ORGANIZATION_ID
,H.FROM_SUBINVENTORY_CODE
,H.TO_SUBINVENTORY_CODE
,H.ATTRIBUTE1 VEHICLE_NO
,H.ATTRIBUTE2 PRODUCT_TYPE
,L.INVENTORY_ITEM_ID
--,(SELECT MSI.SEGMENT1||'.'||MSI.SEGMENT2||'.'||MSI.SEGMENT3 FROM APPS.MTL_SYSTEM_ITEMS_B MSI WHERE MSI.INVENTORY_ITEM_ID=L.INVENTORY_ITEM_ID AND MSI.ORGANIZATION_ID=L.ORGANIZATION_ID) ITEM_CODE
,(SELECT MSI.DESCRIPTION FROM APPS.MTL_SYSTEM_ITEMS_B MSI WHERE MSI.INVENTORY_ITEM_ID=L.INVENTORY_ITEM_ID AND MSI.ORGANIZATION_ID=L.ORGANIZATION_ID) ITEM_NAME
,(SELECT MSI.DESCRIPTION FROM APPS.MTL_SYSTEM_ITEMS_B MSI, INV.MTL_ITEM_CATEGORIES MIC WHERE MSI.INVENTORY_ITEM_ID=L.INVENTORY_ITEM_ID AND MSI.ORGANIZATION_ID=L.ORGANIZATION_ID AND MIC.CATEGORY_SET_ID = 1
       AND MSI.INVENTORY_ITEM_ID=MIC.INVENTORY_ITEM_ID AND MSI.ORGANIZATION_ID=MIC.ORGANIZATION_ID  ) ITEM_CATEGORY
,L.UOM_CODE
,L.QUANTITY
,L.QUANTITY_DELIVERED
,L.REASON_ID
,TRX.HEADER_STATUS_NAME
,TRX.STATUS_DATE
--,H.* 
--,L.*
--,TRX.*
--,MMT.*
--MTT.*
FROM
APPS.MTL_TXN_REQUEST_HEADERS H
,APPS.MTL_TXN_REQUEST_LINES L
,APPS.MTL_TXN_REQUEST_HEADERS_V TRX
--,APPS.MTL_MATERIAL_TRANSACTIONS MMT
--,INV.MTL_TRANSACTION_TYPES MTT
WHERE 1=1
--AND MTT.TRANSACTION_TYPE_ID=MMT.TRANSACTION_TYPE_ID
--AND MTT.TRANSACTION_SOURCE_TYPE_ID = MMT.TRANSACTION_SOURCE_TYPE_ID
--AND MMT.TRANSACTION_SOURCE_ID=H.HEADER_ID
--AND L.LINE_ID=MMT.MOVE_ORDER_LINE_ID
--AND H.REQUEST_NUMBER=MMT.TRANSACTION_SOURCE_ID
--AND TO_CHAR (MMT.TRANSACTION_DATE, 'MON-RR') = 'APR-18'
--AND TO_CHAR (MMT.TRANSACTION_DATE, 'RRRR') = '2018'
--AND TO_CHAR (MMT.TRANSACTION_DATE, 'DD-MON-RR') = '27-MAY-17'
AND H.REQUEST_NUMBER=TRX.REQUEST_NUMBER
AND H.HEADER_ID=L.HEADER_ID
AND H.ORGANIZATION_ID=L.ORGANIZATION_ID
AND TRX.HEADER_STATUS_NAME='Approved'
--and TO_CHAR(H.DATE_REQUIRED,'RRRR')='2018'
--and to_char(H.DATE_REQUIRED,'DD-MON-RR')='05-MAY-18'
--and h.FROM_SUBINVENTORY_CODE='AKC-GEN ST'
AND H.ORGANIZATION_ID=193
--AND L.INVENTORY_ITEM_ID='511077'
--AND TRX.MOVE_ORDER_TYPE_NAME='Requisition'
--AND TRX.TRANSACTION_TYPE_NAME='Move Order Issue'
--AND H.REQUEST_NUMBER='15129101'   --9642353
--AND L.LINE_ID='31251259'
--AND H.HEADER_ID='15129101'
ORDER BY H.REQUEST_NUMBER DESC