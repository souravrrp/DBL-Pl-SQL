SELECT
*
FROM
W_PRODUCT_D
WHERE 1=1
--AND ROW_WID=169875
--PROD_CAT1_WID=1918083
;

SELECT
*
FROM
W_PROD_CAT_DH
WHERE 1=1
AND TOP_LVL_PRODCAT_NAME='IT'
;

SELECT
CAT.TOP_LVL_PRODCAT_NAME, PROD_NAME
,CAT.*
,PROD.*
FROM
W_PROD_CAT_DH CAT,
W_PRODUCT_D PROD
WHERE CAT.ROW_WID=PROD.PROD_CAT1_WID
AND TOP_LVL_PRODCAT_NAME='IT'
--AND PROD.INTEGRATION_ID='12491'
--AND PROD.PROD_NAME='NETWORK CABLE CAT-6'
AND CAT.ROW_WID!=0


SELECT
PROD_CAT1
FROM				
W_PRODUCT_DS