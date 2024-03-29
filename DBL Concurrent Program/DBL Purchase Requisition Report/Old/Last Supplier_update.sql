/* Formatted on 1/16/2020 11:55:41 AM (QP5 v5.287) */
SELECT (CASE
           WHEN     SUP.VENDOR_NAME = 'DBL Distributions Ltd.'
                AND ORG.OPERATING_UNIT = 135
           THEN
              NTH_VALUE (
                 PHA.SEGMENT1,
                 2)
              OVER (
                 PARTITION BY MSI.SEGMENT1
                 ORDER BY PHA.APPROVED_DATE DESC
                 RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
           ELSE
              PHA.SEGMENT1
        END)
          SEGMENT1,
       (CASE
           WHEN     SUP.VENDOR_NAME = 'DBL Distributions Ltd.'
                AND ORG.OPERATING_UNIT = 135
           THEN
              NTH_VALUE (
                 SUP.VENDOR_NAME,
                 2)
              OVER (
                 PARTITION BY MSI.SEGMENT1
                 ORDER BY PHA.APPROVED_DATE DESC
                 RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
           ELSE
              SUP.VENDOR_NAME
        END)
          VENDOR_NAME,
       ROW_NUMBER ()
          OVER (PARTITION BY MSI.SEGMENT1 ORDER BY PHA.APPROVED_DATE DESC)
          CORR
  FROM PO_HEADERS_ALL PHA,
       PO_LINES_ALL PLA,
       AP_SUPPLIERS SUP,
       PO_LINE_LOCATIONS_ALL PLL,
       MTL_SYSTEM_ITEMS_B MSI,
       ORG_ORGANIZATION_DEFINITIONS ORG,
       HR_OPERATING_UNITS HOU
 WHERE     PHA.PO_HEADER_ID = PLA.PO_HEADER_ID
       AND PHA.ORG_ID = PLA.ORG_ID
       AND PHA.VENDOR_ID = SUP.VENDOR_ID
       AND PHA.ORG_ID = HOU.ORGANIZATION_ID
       AND PHA.PO_HEADER_ID = PLL.PO_HEADER_ID
       AND PLA.PO_LINE_ID = PLL.PO_LINE_ID
       AND PLA.ITEM_ID = MSI.INVENTORY_ITEM_ID
       AND PLL.SHIP_TO_ORGANIZATION_ID = MSI.ORGANIZATION_ID
       AND PLL.SHIP_TO_ORGANIZATION_ID = ORG.ORGANIZATION_ID
       AND TYPE_LOOKUP_CODE = 'STANDARD'
       -- and MSI.SEGMENT1='SPRECONS000000035426'
       AND MSI.INVENTORY_ITEM_ID = 7297
       AND PHA.AUTHORIZATION_STATUS = 'APPROVED'
--AND EXISTS(SELECT 1 FROM PO_HEADERS_ALL PH WHERE PHA.PO_HEADER_ID=PHA.PO_HEADER_ID AND
--AND SUP.VENDOR_ID!='1517'
--AND ORG.OPERATING_UNIT = 135