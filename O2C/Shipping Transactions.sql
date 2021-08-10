----------------------------Shipping Details------------------------------------

SELECT
OSH.ORG_ID
,OSH.ORDER_NUMBER
,OSH.OMSHIPPING_STATUS
,OSH.CUSTOMER_NUMBER
,OSH.CUSTOMER_NAME
,OSH.SCHEDULE_SHIP_DATE_TO SCHEDULE_SHIP_DATE
,OSH.ATTRIBUTE1 LINE_OF_BUSINESS
,OSH.OMSHIPPING_NUMBER SHIPPING_NUMBER
,OSL.ORDER_LINE_NO ORDER_LINE_NUM
,OSL.WAREHOUSE_ID
,OSL.SHIP_TO_WAREHOUSE
,OSL.ITEM_ID
,OSL.ITEM_CODE
,OSL.ITEM_DESC
,OSL.ATTRIBUTE18 DEMAND_CLASS
,OSL.OMSHIPPING_LINE_STATUS LINE_SHIPPING_STATUS
,OSL.DELIVERY_CHALLAN_NUMBER DEL_CHALLAN_NO
,OSL.TRANSPORT_CHALLAN_NUMBER TRANSPORT_CHALLAN_NO
,OSL.TRANSPORT_NAME TRANSPORTER_NAME
,OSL.DELIVERY_DATE GL_DATE
--,OSH.*
,OSL.*
FROM
XXDBL_OMSHIPPING_HEADERS OSH
,XXDBL.XXDBL_OMSHIPPING_LINE_V OSL
WHERE 1=1
AND OSH.OMSHIPPING_HEADER_ID=OSL.OMSHIPPING_HEADER_ID
AND ((:P_ORG_ID IS NULL AND OSH.ORG_ID IN (125)) OR (OSH.ORG_ID=:P_ORG_ID))
AND OSH.ORDER_NUMBER IN ('1552060001724')
AND OSH.OMSHIPPING_STATUS IN ('CLOSED') --CLOSED  --NEW




----------------------------Shipping Headers------------------------------------

SELECT
*
FROM
XXDBL_OMSHIPPING_HEADERS OSH
WHERE 1=1
AND ORDER_NUMBER IN ('1552060001724')


-------------------------Shipping Line------------------------------------------

SELECT
*
FROM
XXDBL.XXDBL_OMSHIPPING_LINE_V