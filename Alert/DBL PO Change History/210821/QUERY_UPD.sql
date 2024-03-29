/* Formatted on 8/23/2021 2:30:19 PM (QP5 v5.354) */
  SELECT DISTINCT
         POH.ORG_ID,
         APPS.XX_COM_PKG.GET_HR_OPERATING_UNIT (POH.ORG_ID)
             UNIT_NAME,
         POH.SEGMENT1
             PO_NUM,
         --PHA.REVISION_NUM,
         POL.LINE_NUM
             PO_LINE_NUM,
         POL.ITEM_DESCRIPTION,
         PLH.UNIT_MEAS_LOOKUP_CODE
             UOM,
         PLH.LIST_PRICE_PER_UNIT,
         PLH.QUANTITY
             PO_LINE_QUANTITY,
         POH.CREATION_DATE,
         PHA.REVISED_DATE,
         APPS.XX_COM_PKG.GET_EMP_NAME_FROM_USER_ID (PHA.LAST_UPDATED_BY)
             UPDATED_BY,
         POH.TYPE_LOOKUP_CODE || ' PO'
             REMARKS
    INTO &ORG_ID,
         &UNIT_NAME,
         &PO_NUM,
         &REVISION_NUM,
         &PO_LINE_NUM,
         &ITEM_DESCRIPTION,
         &UOM,
         &LIST_PRICE_PER_UNIT,
         &PO_LINE_QUANTITY,
         &UPDATED_BY,
         &CREATION_DATE,
         &MODIFIED_DATE,
         &REMARKS
    FROM PO_HEADERS_ALL                    POH,
         PO_LINES_ALL                      POL,
         PO_HEADERS_ARCHIVE_ALL            PHA,
         PO_LINES_ARCHIVE_ALL              PLH,
         APPS.PO_LINE_LOCATIONS_ARCHIVE_ALL PLLA,
         PO_LINE_LOCATIONS_ALL             PLL,
         PO_DISTRIBUTIONS_ARCHIVE_ALL      PDAA,
         PO_DISTRIBUTIONS_ALL              PDA
   --        GL_CODE_COMBINATIONS_KFV GCC
   WHERE     POH.PO_HEADER_ID = POL.PO_HEADER_ID
         AND POH.PO_HEADER_ID = PHA.PO_HEADER_ID
         AND PHA.PO_HEADER_ID = PLH.PO_HEADER_ID
         AND POL.PO_LINE_ID = PLH.PO_LINE_ID
         AND POL.PO_HEADER_ID = PLLA.PO_HEADER_ID
         AND POL.PO_LINE_ID = PLLA.PO_LINE_ID
         AND POL.PO_LINE_ID = PLL.PO_LINE_ID
         AND POL.PO_LINE_ID = PDAA.PO_LINE_ID
         AND PDA.PO_LINE_ID = PDAA.PO_LINE_ID
         AND PDA.PO_DISTRIBUTION_ID = PDAA.PO_DISTRIBUTION_ID
         --AND     PDA.CODE_COMBINATION_ID = GCC.CODE_COMBINATION_ID
         --AND POH.SEGMENT1 = '10123000199'
         AND PHA.REVISION_NUM >0
         AND (PLH.CANCEL_FLAG IS NULL OR PLH.CANCEL_FLAG = 'N')
GROUP BY POH.ORG_ID,
         POH.SEGMENT1,
         POL.LINE_NUM,
         --PHA.REVISION_NUM,
         PHA.REVISED_DATE,
         POH.CREATION_DATE,
         POH.TYPE_LOOKUP_CODE,
         POL.ITEM_DESCRIPTION,
         PLH.UNIT_MEAS_LOOKUP_CODE,
         PLH.LIST_PRICE_PER_UNIT,
         PLH.QUANTITY,
         PHA.LAST_UPDATED_BY
ORDER BY POH.SEGMENT1, POL.LINE_NUM;