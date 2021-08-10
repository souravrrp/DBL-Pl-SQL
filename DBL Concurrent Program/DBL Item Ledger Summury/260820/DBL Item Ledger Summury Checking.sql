/* Formatted on 8/26/2020 11:46:27 AM (QP5 v5.354) */
SELECT OOD.ORGANIZATION_CODE,
       MMT.ORGANIZATION_ID          ORG_ID,
       MSI.INVENTORY_ITEM_ID        ITEM_ID,
       MIC.SEGMENT2                 AS ITEM_CATG,
       MIC.SEGMENT3                 AS ITEM_TYPE,
       MSI.CONCATENATED_SEGMENTS    ITEM_CODE,
       MSI.DESCRIPTION              ITEM_DESCRIPTION,
       MSI.PRIMARY_UOM_CODE         AS P_UOM,
       MMT.SECONDARY_UOM_CODE       AS S_UOM,
       CASE SIGN (MMT.TRANSACTION_DATE - :P_DATE_FROM)
           WHEN -1 THEN MMT.PRIMARY_QUANTITY
           ELSE 0
       END                          OPEN_BAL,
       CASE SIGN (MMT.TRANSACTION_DATE - :P_DATE_FROM)
           WHEN -1
           THEN
               0
           ELSE
               CASE MMT.TRANSACTION_SOURCE_TYPE_ID
                   WHEN 1 THEN PRIMARY_QUANTITY
               END
       END                          PO_RCV,
       CASE SIGN (MMT.TRANSACTION_DATE - :P_DATE_FROM)
           WHEN -1
           THEN
               0
           ELSE
               CASE SIGN (MMT.PRIMARY_QUANTITY)
                   WHEN 1
                   THEN
                       CASE
                           WHEN MMT.TRANSACTION_TYPE_ID IN (64,
                                                            96,
                                                            50,
                                                            5,
                                                            9,
                                                            2,
                                                            51,
                                                            66,
                                                            67,
                                                            68)
                           THEN
                               PRIMARY_QUANTITY
                           ELSE
                               0
                       END
               END
       END                          INV_OTHER_RCV,
       CASE SIGN (MMT.TRANSACTION_DATE - :P_DATE_FROM)
           WHEN -1
           THEN
               0
           ELSE
               CASE SIGN (MMT.PRIMARY_QUANTITY)
                   WHEN 1
                   THEN
                       CASE
                           WHEN MMT.TRANSACTION_TYPE_ID IN (44, 43, 1002)
                           THEN
                               PRIMARY_QUANTITY
                           ELSE
                               0
                       END
               END
       END                          INV_PROD_RCV,
       CASE SIGN (MMT.TRANSACTION_DATE - :P_DATE_FROM)
           WHEN -1
           THEN
               0
           ELSE
               CASE SIGN (MMT.PRIMARY_QUANTITY)
                   WHEN 1
                   THEN
                       CASE
                           WHEN MMT.TRANSACTION_TYPE_ID IN (3, 12, 21)
                           THEN
                               PRIMARY_QUANTITY
                           ELSE
                               0
                       END
               END
       END                          INV_INTERORG_RCV,
       CASE SIGN (MMT.TRANSACTION_DATE - :P_DATE_FROM)
           WHEN -1
           THEN
               0
           ELSE
               CASE SIGN (MMT.PRIMARY_QUANTITY)
                   WHEN 1
                   THEN
                       CASE
                           WHEN MMT.TRANSACTION_TYPE_ID = 42
                           THEN
                               PRIMARY_QUANTITY
                           ELSE
                               0
                       END
               END
       END                          INV_MISC_RCV,
       CASE SIGN (MMT.TRANSACTION_DATE - :P_DATE_FROM)
           WHEN -1
           THEN
               0
           ELSE
               CASE SIGN (MMT.PRIMARY_QUANTITY)
                   WHEN 1
                   THEN
                       CASE MMT.TRANSACTION_SOURCE_TYPE_ID
                           WHEN 6
                           THEN
                               CASE
                                   WHEN MMT.TRANSACTION_SOURCE_ID IN (144,
                                                                      148,
                                                                      152,
                                                                      156,
                                                                      160,
                                                                      164,
                                                                      168,
                                                                      172,
                                                                      176,
                                                                      180,
                                                                      220,
                                                                      402,
                                                                      404,
                                                                      406,
                                                                      408,
                                                                      410,
                                                                      412,
                                                                      444,
                                                                      448,
                                                                      452,
                                                                      456,
                                                                      460,
                                                                      464,
                                                                      562,
                                                                      584,
                                                                      606,
                                                                      658,
                                                                      846,
                                                                      848)
                                   THEN
                                       PRIMARY_QUANTITY
                                   ELSE
                                       0
                               END
                           ELSE
                               0
                       END
               END
       END                          INV_LOAN_RCV,
       CASE SIGN (MMT.TRANSACTION_DATE - :P_DATE_FROM)
           WHEN -1
           THEN
               0
           ELSE
               CASE SIGN (MMT.PRIMARY_QUANTITY)
                   WHEN 1
                   THEN
                       CASE MMT.TRANSACTION_SOURCE_TYPE_ID
                           WHEN 6
                           THEN
                               CASE
                                   WHEN MMT.TRANSACTION_SOURCE_ID NOT IN
                                            (144,
                                             148,
                                             152,
                                             156,
                                             160,
                                             164,
                                             168,
                                             172,
                                             176,
                                             180,
                                             220,
                                             402,
                                             404,
                                             406,
                                             408,
                                             410,
                                             412,
                                             444,
                                             448,
                                             452,
                                             456,
                                             460,
                                             464,
                                             562,
                                             584,
                                             606,
                                             658,
                                             846,
                                             848)
                                   THEN
                                       PRIMARY_QUANTITY
                                   ELSE
                                       0
                               END
                           ELSE
                               0
                       END
               END
       END                          INV_AAL_RCV,
       CASE SIGN (MMT.TRANSACTION_DATE - :P_DATE_FROM)
           WHEN -1
           THEN
               0
           ELSE
               CASE SIGN (MMT.PRIMARY_QUANTITY)
                   WHEN 1 THEN MMT.PRIMARY_QUANTITY
                   ELSE 0
               END
       END                          RCV_QTY,
       CASE SIGN (MMT.TRANSACTION_DATE - :P_DATE_FROM)
           WHEN -1
           THEN
               0
           ELSE
               CASE SIGN (MMT.PRIMARY_QUANTITY)
                   WHEN -1 THEN MMT.PRIMARY_QUANTITY
                   ELSE 0
               END
       END                          ISU_QTY,
       CASE SIGN (MMT.TRANSACTION_DATE - :P_DATE_FROM)
           WHEN -1
           THEN
               0
           ELSE
               CASE SIGN (MMT.PRIMARY_QUANTITY)
                   WHEN -1
                   THEN
                       CASE
                           WHEN MMT.TRANSACTION_TYPE_ID IN (64,
                                                            96,
                                                            50,
                                                            5,
                                                            9,
                                                            2,
                                                            51,
                                                            66,
                                                            67,
                                                            68)
                           THEN
                               PRIMARY_QUANTITY
                           ELSE
                               0
                       END
               END
       END                          INV_OTHER_ISU,
       CASE SIGN (MMT.TRANSACTION_DATE - :P_DATE_FROM)
           WHEN -1
           THEN
               0
           ELSE
               CASE SIGN (MMT.PRIMARY_QUANTITY)
                   WHEN -1
                   THEN
                       CASE
                           WHEN MMT.TRANSACTION_TYPE_ID = 32
                           THEN
                               PRIMARY_QUANTITY
                           ELSE
                               0
                       END
               END
       END                          INV_MISC_ISU,
       CASE SIGN (MMT.TRANSACTION_DATE - :P_DATE_FROM)
           WHEN -1
           THEN
               0
           ELSE
               CASE SIGN (MMT.PRIMARY_QUANTITY)
                   WHEN -1
                   THEN
                       CASE
                           WHEN MMT.TRANSACTION_TYPE_ID IN (3, 12, 21)
                           THEN
                               PRIMARY_QUANTITY
                           ELSE
                               0
                       END
               END
       END                          INV_INTERORG_ISU,
       CASE SIGN (MMT.TRANSACTION_DATE - :P_DATE_FROM)
           WHEN -1
           THEN
               0
           ELSE
               CASE SIGN (MMT.PRIMARY_QUANTITY)
                   WHEN -1
                   THEN
                       CASE
                           WHEN MMT.TRANSACTION_TYPE_ID IN (1003, 17, 35)
                           THEN
                               PRIMARY_QUANTITY
                           ELSE
                               0
                       END
               END
       END                          INV_PROD_ISU,
       CASE SIGN (MMT.TRANSACTION_DATE - :P_DATE_FROM)
           WHEN -1
           THEN
               0
           ELSE
               CASE SIGN (MMT.PRIMARY_QUANTITY)
                   WHEN -1
                   THEN
                       CASE
                           WHEN MMT.TRANSACTION_TYPE_ID = 33
                           THEN
                               PRIMARY_QUANTITY
                           ELSE
                               0
                       END
               END
       END                          INV_SO_ISU,
       CASE SIGN (MMT.TRANSACTION_DATE - :P_DATE_FROM)
           WHEN -1
           THEN
               0
           ELSE
               CASE SIGN (MMT.PRIMARY_QUANTITY)
                   WHEN -1
                   THEN
                       CASE MMT.TRANSACTION_SOURCE_TYPE_ID
                           WHEN 6
                           THEN
                               CASE
                                   WHEN MMT.TRANSACTION_SOURCE_ID IN (542,
                                                                      414,
                                                                      416,
                                                                      418,
                                                                      420,
                                                                      422,
                                                                      424,
                                                                      142,
                                                                      146,
                                                                      150,
                                                                      154,
                                                                      158,
                                                                      162,
                                                                      166,
                                                                      170,
                                                                      174,
                                                                      178,
                                                                      222,
                                                                      442,
                                                                      446,
                                                                      450,
                                                                      454,
                                                                      458,
                                                                      462,
                                                                      656,
                                                                      844,
                                                                      850,
                                                                      564,
                                                                      582)
                                   THEN
                                       PRIMARY_QUANTITY
                                   ELSE
                                       0
                               END
                           ELSE
                               0
                       END
               END
       END                          INV_LOAN_ISU,
       CASE SIGN (MMT.TRANSACTION_DATE - :P_DATE_FROM)
           WHEN -1
           THEN
               0
           ELSE
               CASE SIGN (MMT.PRIMARY_QUANTITY)
                   WHEN -1
                   THEN
                       CASE MMT.TRANSACTION_SOURCE_TYPE_ID
                           WHEN 6
                           THEN
                               CASE
                                   WHEN MMT.TRANSACTION_SOURCE_ID NOT IN
                                            (542,
                                             414,
                                             416,
                                             418,
                                             420,
                                             422,
                                             424,
                                             142,
                                             146,
                                             150,
                                             154,
                                             158,
                                             162,
                                             166,
                                             170,
                                             174,
                                             178,
                                             222,
                                             442,
                                             446,
                                             450,
                                             454,
                                             458,
                                             462,
                                             656,
                                             844,
                                             850,
                                             564,
                                             582)
                                   THEN
                                       PRIMARY_QUANTITY
                                   ELSE
                                       0
                               END
                           ELSE
                               0
                       END
               END
       END                          INV_AAL_ISU,
       CASE SIGN (MMT.TRANSACTION_DATE - :P_DATE_FROM)
           WHEN -1
           THEN
               0
           ELSE
               CASE SIGN (MMT.PRIMARY_QUANTITY)
                   WHEN -1
                   THEN
                       CASE MMT.TRANSACTION_TYPE_ID
                           WHEN 63 THEN PRIMARY_QUANTITY
                           ELSE 0
                       END
               END
       END                          INV_MO_ISU,
       MMT.TRANSACTION_SOURCE_NAME,
       MMT.TRANSACTION_SOURCE_ID,
       MMT.TRANSACTION_ID,
       GB.BATCH_NO,
       MMT.TRANSACTION_QUANTITY
       --,MTT.*
  FROM INV.MTL_MATERIAL_TRANSACTIONS      MMT,
       INV.MTL_TRANSACTION_TYPES          MTT,
       APPS.MTL_SYSTEM_ITEMS_B_KFV        MSI,
       APPS.MTL_ITEM_CATEGORIES_V         MIC,
       APPS.ORG_ORGANIZATION_DEFINITIONS  OOD,
       APPS.GME_BATCH_HEADER              GB
 WHERE     MMT.INVENTORY_ITEM_ID = MSI.INVENTORY_ITEM_ID
       AND MMT.ORGANIZATION_ID = MSI.ORGANIZATION_ID
       AND MSI.INVENTORY_ITEM_ID = MIC.INVENTORY_ITEM_ID
       AND MSI.ORGANIZATION_ID = MIC.ORGANIZATION_ID
       AND MMT.ORGANIZATION_ID = OOD.ORGANIZATION_ID
       AND MIC.CATEGORY_SET_ID = 1
       AND MMT.TRANSACTION_SOURCE_ID = GB.BATCH_ID(+)
       AND TO_CHAR (MMT.TRANSACTION_TYPE_ID) NOT IN (TO_CHAR ( :CP_TRX_TYPE))
       --AND MMT.TRANSACTION_TYPE_ID <> 98
       AND (LOGICAL_TRANSACTION = 2 OR LOGICAL_TRANSACTION IS NULL)
       --AND MMT.TRANSACTION_TYPE_ID NOT IN (80, 98, 99, 120, 52, 26, 64)
       AND MMT.ORGANIZATION_ID = NVL ( :P_ORG_ID, MMT.ORGANIZATION_ID)
       AND MMT.SUBINVENTORY_CODE = NVL ( :P_SUB_INV, MMT.SUBINVENTORY_CODE)
       AND MSI.CONCATENATED_SEGMENTS =
           NVL ( :P_ITEM, MSI.CONCATENATED_SEGMENTS)
       AND MIC.SEGMENT3 = NVL ( :P_ITEM_TYPE, MIC.SEGMENT3)
       AND MIC.SEGMENT2 = NVL ( :P_ITEM_CATEGORY, MIC.SEGMENT2)
       -- AND MSI.CONCATENATED_SEGMENTS = 'PAMCAR00000000000035'
       --AND MSI.PRIMARY_UOM_CODE = 'CON'
       AND MTT.TRANSACTION_TYPE_ID = MMT.TRANSACTION_TYPE_ID
       AND MTT.TRANSACTION_SOURCE_TYPE_ID = MMT.TRANSACTION_SOURCE_TYPE_ID
       AND MIC.CATEGORY_CONCAT_SEGS NOT LIKE 'ECO THREAD.SEMI FINISH GOODS%'
       AND MMT.TRANSACTION_DATE BETWEEN '01-JAN-2010' AND :P_DATE_TO + .99999