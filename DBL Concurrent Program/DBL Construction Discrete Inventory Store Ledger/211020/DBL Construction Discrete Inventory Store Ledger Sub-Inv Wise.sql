/* Formatted on 10/21/2020 10:47:56 AM (QP5 v5.354) */
WITH
    MAINS
    AS
        (SELECT MSIK.ORGANIZATION_ID,
                OOD.ORGANIZATION_NAME,
                MSI.SECONDARY_INVENTORY_NAME     SECONDARY_INVENTORY,
                MSIK.INVENTORY_ITEM_ID,
                MSIK.CONCATENATED_SEGMENTS       ITEM_CODE,
                MSIK.DESCRIPTION                 ITEM_NAME,
                MSIK.PRIMARY_UOM_CODE            UOM,
                MIC.SEGMENT2                     ITEM_MJR_CAT,
                MIC.SEGMENT3                     ITEM_MNR_CAT
           FROM ORG_ORGANIZATION_DEFINITIONS  OOD,
                MTL_SYSTEM_ITEMS_B_KFV        MSIK,
                MTL_ITEM_CATEGORIES_V         MIC,
                MTL_SECONDARY_INVENTORIES     MSI
          WHERE     MSIK.ORGANIZATION_ID = MIC.ORGANIZATION_ID
                AND MSIK.ORGANIZATION_ID = OOD.ORGANIZATION_ID
                AND MSIK.INVENTORY_ITEM_ID = MIC.INVENTORY_ITEM_ID
                AND MIC.CATEGORY_SET_ID = 1
                AND ( :P_ORG_ID IS NULL OR MSIK.ORGANIZATION_ID = :P_ORG_ID)
                AND MSI.ORGANIZATION_ID = OOD.ORGANIZATION_ID
                --AND ( :P_ITEM_CODE IS NULL OR MSIK.SEGMENT1 = :P_ITEM_CODE)
                AND (   :P_SUB_INVENTORY IS NULL
                     OR MSI.SECONDARY_INVENTORY_NAME = :P_SUB_INVENTORY)
                AND (   :P_ITEM_ID IS NULL
                     OR MSIK.INVENTORY_ITEM_ID = :P_ITEM_ID)
                AND ( :P_MJR_CAT IS NULL OR MIC.SEGMENT2 = :P_MJR_CAT)
                AND ( :P_MNR_CAT IS NULL OR MIC.SEGMENT3 = :P_MNR_CAT)),
    RECEIVE
    AS
        (  SELECT ORGANIZATION_ID,
                  INVENTORY_ITEM_ID,
                  SUM (PO_RCV_QTY)         PO_RCV_QTY,
                  SUM (INT_ORG_RCV_QTY)    INT_ORG_RCV_QTY,
                  SUM (SUB_INV_RCV_QTY)    SUB_INV_RCV_QTY,
                  SUM (RTN_ISU_QTY)        RTN_ISU_QTY,
                  (  SUM (PO_RCV_QTY)
                   + SUM (INT_ORG_RCV_QTY)
                   + SUM (SUB_INV_RCV_QTY)
                   + SUM (RTN_ISU_QTY))    RCV_QTY,
                  SUM (PO_RCV_VAL)         PO_RCV_VAL,
                  SUM (INT_ORG_RCV_VAL)    INT_ORG_RCV_VAL,
                  SUM (SUB_INV_RCV_VAL)    SUB_INV_RCV_VAL,
                  SUM (RTN_ISU_VAL)        RTN_ISU_VAL,
                  (  SUM (PO_RCV_VAL)
                   + SUM (INT_ORG_RCV_VAL)
                   + SUM (SUB_INV_RCV_VAL)
                   + SUM (RTN_ISU_VAL))    RCV_VAL
             FROM (       --------------------------PO_RECEIPT----------------
                     SELECT MMT.ORGANIZATION_ID,
                            MMT.INVENTORY_ITEM_ID,
                            SUM (MMT.PRIMARY_QUANTITY)
                                PO_RCV_QTY,
                            SUM (MMT.PRIMARY_QUANTITY) * MMT.ACTUAL_COST
                                PO_RCV_VAL,
                            TO_NUMBER (0)
                                RTN_ISU_QTY,
                            TO_NUMBER (0)
                                RTN_ISU_VAL,
                            TO_NUMBER (0)
                                INT_ORG_RCV_QTY,
                            TO_NUMBER (0)
                                INT_ORG_RCV_VAL,
                            TO_NUMBER (0)
                                SUB_INV_RCV_QTY,
                            TO_NUMBER (0)
                                SUB_INV_RCV_VAL
                       FROM MTL_MATERIAL_TRANSACTIONS MMT
                      WHERE     (   :P_ORG_ID IS NULL
                                 OR MMT.ORGANIZATION_ID = :P_ORG_ID)
                            AND (   :P_SUB_INVENTORY IS NULL
                                 OR MMT.SUBINVENTORY_CODE = :P_SUB_INVENTORY)
                            AND (   :P_ITEM_ID IS NULL
                                 OR MMT.INVENTORY_ITEM_ID = :P_ITEM_ID)
                            AND TRUNC (MMT.TRANSACTION_DATE) BETWEEN :P_DATE_FR
                                                                 AND :P_DATE_TO
                            AND MMT.TRANSACTION_TYPE_ID = 18
                            AND SIGN (PRIMARY_QUANTITY) = 1
                   GROUP BY MMT.ORGANIZATION_ID,
                            MMT.INVENTORY_ITEM_ID,
                            MMT.ACTUAL_COST
                   UNION ALL --------------------------RETURN_TO_VENDOR-----------
                     SELECT MMT.ORGANIZATION_ID,
                            MMT.INVENTORY_ITEM_ID,
                            TO_NUMBER (0)
                                PO_RCV_QTY,
                            TO_NUMBER (0)
                                PO_RCV_VAL,
                            SUM (MMT.PRIMARY_QUANTITY)
                                RTN_ISU_QTY,
                            SUM (MMT.PRIMARY_QUANTITY) * MMT.ACTUAL_COST
                                RTN_ISU_VAL,
                            TO_NUMBER (0)
                                INT_ORG_RCV_QTY,
                            TO_NUMBER (0)
                                INT_ORG_RCV_VAL,
                            TO_NUMBER (0)
                                SUB_INV_RCV_QTY,
                            TO_NUMBER (0)
                                SUB_INV_RCV_VAL
                       FROM MTL_MATERIAL_TRANSACTIONS MMT
                      WHERE     (   :P_ORG_ID IS NULL
                                 OR MMT.ORGANIZATION_ID = :P_ORG_ID)
                            AND (   :P_SUB_INVENTORY IS NULL
                                 OR MMT.SUBINVENTORY_CODE = :P_SUB_INVENTORY)
                            AND (   :P_ITEM_ID IS NULL
                                 OR MMT.INVENTORY_ITEM_ID = :P_ITEM_ID)
                            AND TRUNC (MMT.TRANSACTION_DATE) BETWEEN :P_DATE_FR
                                                                 AND :P_DATE_TO
                            AND MMT.TRANSACTION_TYPE_ID = 36
                            AND SIGN (PRIMARY_QUANTITY) = -1
                   GROUP BY MMT.ORGANIZATION_ID,
                            MMT.INVENTORY_ITEM_ID,
                            MMT.ACTUAL_COST
                   UNION ALL ---------INTRANSIT_SHIPMENT+INTER_ORG_TRNS---------
                     SELECT MMT.ORGANIZATION_ID,
                            MMT.INVENTORY_ITEM_ID,
                            TO_NUMBER (0)
                                PO_RCV_QTY,
                            TO_NUMBER (0)
                                PO_RCV_VAL,
                            TO_NUMBER (0)
                                RTN_ISU_QTY,
                            TO_NUMBER (0)
                                RTN_ISU_VAL,
                            SUM (MMT.PRIMARY_QUANTITY)
                                INT_ORG_RCV_QTY,
                            SUM (MMT.PRIMARY_QUANTITY) * MMT.ACTUAL_COST
                                INT_ORG_RCV_VAL,
                            TO_NUMBER (0)
                                SUB_INV_RCV_QTY,
                            TO_NUMBER (0)
                                SUB_INV_RCV_VAL
                       FROM MTL_MATERIAL_TRANSACTIONS MMT
                      WHERE     (   :P_ORG_ID IS NULL
                                 OR MMT.ORGANIZATION_ID = :P_ORG_ID)
                            AND (   :P_SUB_INVENTORY IS NULL
                                 OR MMT.SUBINVENTORY_CODE = :P_SUB_INVENTORY)
                            AND (   :P_ITEM_ID IS NULL
                                 OR MMT.INVENTORY_ITEM_ID = :P_ITEM_ID)
                            AND TRUNC (MMT.TRANSACTION_DATE) BETWEEN :P_DATE_FR
                                                                 AND :P_DATE_TO
                            AND MMT.TRANSACTION_TYPE_ID IN (3, 21)
                            AND SIGN (PRIMARY_QUANTITY) = 1
                   GROUP BY MMT.ORGANIZATION_ID,
                            MMT.INVENTORY_ITEM_ID,
                            MMT.ACTUAL_COST
                   UNION ALL --------------------------SUB_INV_TRNS------------
                     SELECT MMT.ORGANIZATION_ID,
                            MMT.INVENTORY_ITEM_ID,
                            TO_NUMBER (0)                                   PO_RCV_QTY,
                            TO_NUMBER (0)                                   PO_RCV_VAL,
                            TO_NUMBER (0)                                   RTN_ISU_QTY,
                            TO_NUMBER (0)                                   RTN_ISU_VAL,
                            TO_NUMBER (0)                                   INT_ORG_RCV_QTY,
                            TO_NUMBER (0)                                   INT_ORG_VAL,
                            SUM (MMT.PRIMARY_QUANTITY)                      SUB_INV_RCV_QTY,
                            SUM (MMT.PRIMARY_QUANTITY) * MMT.ACTUAL_COST    SUB_INV_RCV_VAL
                       FROM MTL_MATERIAL_TRANSACTIONS MMT
                      WHERE     (   :P_ORG_ID IS NULL
                                 OR MMT.ORGANIZATION_ID = :P_ORG_ID)
                            AND (   :P_SUB_INVENTORY IS NULL
                                 OR MMT.SUBINVENTORY_CODE = :P_SUB_INVENTORY)
                            AND (   :P_ITEM_ID IS NULL
                                 OR MMT.INVENTORY_ITEM_ID = :P_ITEM_ID)
                            AND TRUNC (MMT.TRANSACTION_DATE) BETWEEN :P_DATE_FR
                                                                 AND :P_DATE_TO
                            AND MMT.TRANSACTION_TYPE_ID = 2
                            AND SIGN (PRIMARY_QUANTITY) = 1
                   GROUP BY MMT.ORGANIZATION_ID,
                            MMT.INVENTORY_ITEM_ID,
                            MMT.ACTUAL_COST
                   UNION ALL        --------------------------DUAL------------
                   SELECT TO_NUMBER ( :P_ORG_ID)      ORGANIZATION_ID,
                          TO_NUMBER ( :P_ITEM_ID)     INVENTORY_ITEM_ID,
                          TO_NUMBER (0)               PO_RCV_QTY,
                          TO_NUMBER (0)               PO_RCV_VAL,
                          TO_NUMBER (0)               RTN_ISU_QTY,
                          TO_NUMBER (0)               RTN_ISU_VAL,
                          TO_NUMBER (0)               INT_ORG_RCV_QTY,
                          TO_NUMBER (0)               INT_ORG_VAL,
                          TO_NUMBER (0)               SUB_INV_RCV_QTY,
                          TO_NUMBER (0)               SUB_INV_RCV_VAL
                     FROM DUAL)
         GROUP BY ORGANIZATION_ID, INVENTORY_ITEM_ID),
    ISSUE
    AS
        (  SELECT ORGANIZATION_ID,
                  INVENTORY_ITEM_ID,
                  SUM (INT_ORG_ISU_QTY)
                      INT_ORG_ISU_QTY,
                  SUM (SUB_INV_ISU_QTY)
                      SUB_INV_ISU_QTY,
                  (SUM (INT_ORG_ISU_QTY) + SUM (SUB_INV_ISU_QTY))
                      ISU_QTY,
                  SUM (INT_ORG_ISU_VAL)
                      INT_ORG_ISU_VAL,
                  SUM (SUB_INV_ISU_VAL)
                      SUB_INV_ISU_VAL,
                  (SUM (INT_ORG_ISU_VAL) + SUM (SUB_INV_ISU_VAL))
                      ISU_VAL
             FROM (        ---------INTRANSIT_SHIPMENT+INTER_ORG_TRNS---------
                     SELECT MMT.ORGANIZATION_ID,
                            MMT.INVENTORY_ITEM_ID,
                            SUM (MMT.PRIMARY_QUANTITY)
                                INT_ORG_ISU_QTY,
                            SUM (MMT.PRIMARY_QUANTITY) * MMT.ACTUAL_COST
                                INT_ORG_ISU_VAL,
                            TO_NUMBER (0)
                                SUB_INV_ISU_QTY,
                            TO_NUMBER (0)
                                SUB_INV_ISU_VAL
                       FROM MTL_MATERIAL_TRANSACTIONS MMT
                      WHERE     (   :P_ORG_ID IS NULL
                                 OR MMT.ORGANIZATION_ID = :P_ORG_ID)
                            AND (   :P_SUB_INVENTORY IS NULL
                                 OR MMT.SUBINVENTORY_CODE = :P_SUB_INVENTORY)
                            AND (   :P_ITEM_ID IS NULL
                                 OR MMT.INVENTORY_ITEM_ID = :P_ITEM_ID)
                            AND TRUNC (MMT.TRANSACTION_DATE) BETWEEN :P_DATE_FR
                                                                 AND :P_DATE_TO
                            AND MMT.TRANSACTION_TYPE_ID IN (3, 21)
                            AND SIGN (PRIMARY_QUANTITY) = -1
                   GROUP BY MMT.ORGANIZATION_ID,
                            MMT.INVENTORY_ITEM_ID,
                            MMT.ACTUAL_COST
                   UNION ALL --------------------------SUB_INV_TRNS------------
                     SELECT MMT.ORGANIZATION_ID,
                            MMT.INVENTORY_ITEM_ID,
                            TO_NUMBER (0)                                   INT_ORG_ISU_QTY,
                            TO_NUMBER (0)                                   INT_ORG_ISU_VAL,
                            SUM (MMT.PRIMARY_QUANTITY)                      SUB_INV_ISU_QTY,
                            SUM (MMT.PRIMARY_QUANTITY) * MMT.ACTUAL_COST    SUB_INV_ISU_VAL
                       FROM MTL_MATERIAL_TRANSACTIONS MMT
                      WHERE     (   :P_ORG_ID IS NULL
                                 OR MMT.ORGANIZATION_ID = :P_ORG_ID)
                            AND (   :P_SUB_INVENTORY IS NULL
                                 OR MMT.SUBINVENTORY_CODE = :P_SUB_INVENTORY)
                            AND (   :P_ITEM_ID IS NULL
                                 OR MMT.INVENTORY_ITEM_ID = :P_ITEM_ID)
                            AND TRUNC (MMT.TRANSACTION_DATE) BETWEEN :P_DATE_FR
                                                                 AND :P_DATE_TO
                            AND MMT.TRANSACTION_TYPE_ID = 2
                            AND SIGN (PRIMARY_QUANTITY) = -1
                   GROUP BY MMT.ORGANIZATION_ID,
                            MMT.INVENTORY_ITEM_ID,
                            MMT.ACTUAL_COST
                   UNION ALL        --------------------------DUAL------------
                   SELECT TO_NUMBER ( :P_ORG_ID)      ORGANIZATION_ID,
                          TO_NUMBER ( :P_ITEM_ID)     INVENTORY_ITEM_ID,
                          TO_NUMBER (0)               INT_ORG_ISU_QTY,
                          TO_NUMBER (0)               INT_ORG_ISU_VAL,
                          TO_NUMBER (0)               SUB_INV_ISU_QTY,
                          TO_NUMBER (0)               SUB_INV_ISU_VAL
                     FROM DUAL)
         GROUP BY ORGANIZATION_ID, INVENTORY_ITEM_ID),
    CONSUME
    AS
        (  SELECT ORGANIZATION_ID,
                  INVENTORY_ITEM_ID,
                  SUM (MO_ISU_QTY)                           MO_ISU_QTY,
                  SUM (MSC_RCV_QTY)                          MSC_RCV_QTY,
                  (SUM (MO_ISU_QTY) + SUM (MSC_RCV_QTY))     CON_QTY,
                  SUM (MO_ISU_VAL)                           MO_ISU_VAL,
                  SUM (MSC_RCV_VAL)                          MSC_RCV_VAL,
                  (SUM (MO_ISU_VAL) + SUM (MSC_RCV_VAL))     CON_VAL
             FROM (       --------------------------MOVE_ORD_ISSUE------------
                     SELECT MMT.ORGANIZATION_ID,
                            MMT.INVENTORY_ITEM_ID,
                            SUM (MMT.PRIMARY_QUANTITY)
                                MO_ISU_QTY,
                            SUM (MMT.PRIMARY_QUANTITY) * MMT.ACTUAL_COST
                                MO_ISU_VAL,
                            TO_NUMBER (0)
                                MSC_RCV_QTY,
                            TO_NUMBER (0)
                                MSC_RCV_VAL
                       FROM MTL_MATERIAL_TRANSACTIONS MMT
                      WHERE     (   :P_ORG_ID IS NULL
                                 OR MMT.ORGANIZATION_ID = :P_ORG_ID)
                            AND (   :P_SUB_INVENTORY IS NULL
                                 OR MMT.SUBINVENTORY_CODE = :P_SUB_INVENTORY)
                            AND (   :P_ITEM_ID IS NULL
                                 OR MMT.INVENTORY_ITEM_ID = :P_ITEM_ID)
                            AND TRUNC (MMT.TRANSACTION_DATE) BETWEEN :P_DATE_FR
                                                                 AND :P_DATE_TO
                            AND MMT.TRANSACTION_TYPE_ID = 63
                            AND TRANSACTION_ACTION_ID != 24
                            AND SIGN (PRIMARY_QUANTITY) = -1
                   GROUP BY MMT.ORGANIZATION_ID,
                            MMT.INVENTORY_ITEM_ID,
                            MMT.ACTUAL_COST
                   UNION ALL --------------MISCELLANEOUS_RECEIPT----------------
                     SELECT MMT.ORGANIZATION_ID,
                            MMT.INVENTORY_ITEM_ID,
                            TO_NUMBER (0)                                   MO_ISU_QTY,
                            TO_NUMBER (0)                                   MO_ISU_VAL,
                            SUM (MMT.PRIMARY_QUANTITY)                      MSC_RCV_QTY,
                            SUM (MMT.PRIMARY_QUANTITY) * MMT.ACTUAL_COST    MSC_RCV_VAL
                       FROM MTL_MATERIAL_TRANSACTIONS MMT
                      WHERE     (   :P_ORG_ID IS NULL
                                 OR MMT.ORGANIZATION_ID = :P_ORG_ID)
                            AND (   :P_SUB_INVENTORY IS NULL
                                 OR MMT.SUBINVENTORY_CODE = :P_SUB_INVENTORY)
                            AND (   :P_ITEM_ID IS NULL
                                 OR MMT.INVENTORY_ITEM_ID = :P_ITEM_ID)
                            AND TRUNC (MMT.TRANSACTION_DATE) BETWEEN :P_DATE_FR
                                                                 AND :P_DATE_TO
                            AND MMT.TRANSACTION_TYPE_ID = 42
                            AND TRANSACTION_ACTION_ID != 24
                            AND SIGN (PRIMARY_QUANTITY) = 1
                   GROUP BY MMT.ORGANIZATION_ID,
                            MMT.INVENTORY_ITEM_ID,
                            MMT.ACTUAL_COST
                   UNION ALL        --------------------------DUAL------------
                   SELECT TO_NUMBER ( :P_ORG_ID)      ORGANIZATION_ID,
                          TO_NUMBER ( :P_ITEM_ID)     INVENTORY_ITEM_ID,
                          TO_NUMBER (0)               MO_ISU_QTY,
                          TO_NUMBER (0)               MO_ISU_VAL,
                          TO_NUMBER (0)               MSC_RCV_QTY,
                          TO_NUMBER (0)               MSC_RCV_VAL
                     FROM DUAL)
         GROUP BY ORGANIZATION_ID, INVENTORY_ITEM_ID)
  SELECT ORGANIZATION_ID,
         ORGANIZATION_NAME,
         SECONDARY_INVENTORY,
         ITEM_MJR_CAT,
         ITEM_MNR_CAT,
         INVENTORY_ITEM_ID,
         ITEM_CODE,
         ITEM_NAME,
         UOM,
         SUM (PO_RCV_QTY)                                   PO_RCV_QTY,
         SUM (PO_RCV_VAL)                                   PO_RCV_VAL,
         SUM (RTN_ISU_QTY)                                  RTN_ISU_QTY,
         SUM (RTN_ISU_VAL)                                  RTN_ISU_VAL,
         SUM (INT_ORG_RCV_QTY)                              INT_ORG_RCV_QTY,
         SUM (INT_ORG_RCV_VAL)                              INT_ORG_RCV_VAL,
         SUM (SUB_INV_RCV_QTY)                              SUB_INV_RCV_QTY,
         SUM (SUB_INV_RCV_VAL)                              SUB_INV_RCV_VAL,
         SUM (RCV_QTY)                                      RCV_QTY,
         SUM (RCV_VAL)                                      RCV_VAL,
         SUM (INT_ORG_ISU_QTY)                              INT_ORG_ISU_QTY,
         SUM (INT_ORG_ISU_VAL)                              INT_ORG_ISU_VAL,
         SUM (SUB_INV_ISU_QTY)                              SUB_INV_ISU_QTY,
         SUM (SUB_INV_ISU_VAL)                              SUB_INV_ISU_VAL,
         SUM (ISU_QTY)                                      ISU_QTY,
         SUM (ISU_VAL)                                      ISU_VAL,
         (SUM (RCV_QTY) + SUM (ISU_QTY))                    NET_RCV_QTY,
         (SUM (RCV_VAL) + SUM (ISU_VAL))                    NET_RCV_VAL,
         SUM (MO_ISU_QTY)                                   MO_ISU_QTY,
         SUM (MO_ISU_VAL)                                   MO_ISU_VAL,
         SUM (MSC_RCV_QTY)                                  MSC_RCV_QTY,
         SUM (MSC_RCV_VAL)                                  MSC_RCV_VAL,
         SUM (CON_QTY)                                      CON_QTY,
         SUM (CON_VAL)                                      CON_VAL,
         (SUM (RCV_QTY) + SUM (ISU_QTY) + SUM (CON_QTY))    CLOSING_QTY,
         (SUM (RCV_VAL) + SUM (ISU_VAL) + SUM (CON_VAL))    CLOSING_VAL,
         ROUND ((SUM (ISU_VAL) / DECODE (SUM (ISU_QTY), 0, 1, SUM (ISU_QTY))),
                2)                                          AVG_ISS_VAL
    FROM (SELECT M.ORGANIZATION_ID,
                 M.ORGANIZATION_NAME,
                 M.SECONDARY_INVENTORY,
                 M.ITEM_MJR_CAT,
                 M.ITEM_MNR_CAT,
                 M.INVENTORY_ITEM_ID,
                 M.ITEM_CODE,
                 M.ITEM_NAME,
                 M.UOM,
                 R.PO_RCV_QTY,
                 R.PO_RCV_VAL,
                 R.RTN_ISU_QTY,
                 R.RTN_ISU_VAL,
                 R.INT_ORG_RCV_QTY,
                 R.INT_ORG_RCV_VAL,
                 R.SUB_INV_RCV_QTY,
                 R.SUB_INV_RCV_VAL,
                 R.RCV_QTY,
                 R.RCV_VAL,
                 TO_NUMBER (0)     INT_ORG_ISU_QTY,
                 TO_NUMBER (0)     INT_ORG_ISU_VAL,
                 TO_NUMBER (0)     SUB_INV_ISU_QTY,
                 TO_NUMBER (0)     SUB_INV_ISU_VAL,
                 TO_NUMBER (0)     ISU_QTY,
                 TO_NUMBER (0)     ISU_VAL,
                 TO_NUMBER (0)     MO_ISU_QTY,
                 TO_NUMBER (0)     MO_ISU_VAL,
                 TO_NUMBER (0)     MSC_RCV_QTY,
                 TO_NUMBER (0)     MSC_RCV_VAL,
                 TO_NUMBER (0)     CON_QTY,
                 TO_NUMBER (0)     CON_VAL
            FROM MAINS M, RECEIVE R
           WHERE     1 = 1
                 AND M.ORGANIZATION_ID = R.ORGANIZATION_ID
                 AND M.INVENTORY_ITEM_ID = R.INVENTORY_ITEM_ID
                 AND :P_REPORT_TYPE = 'YES'
                 AND R.RCV_QTY > 0
          UNION ALL
          SELECT M.ORGANIZATION_ID,
                 M.ORGANIZATION_NAME,
                 M.SECONDARY_INVENTORY,
                 M.ITEM_MJR_CAT,
                 M.ITEM_MNR_CAT,
                 M.INVENTORY_ITEM_ID,
                 M.ITEM_CODE,
                 M.ITEM_NAME,
                 M.UOM,
                 TO_NUMBER (0)     PO_RCV_QTY,
                 TO_NUMBER (0)     PO_RCV_VAL,
                 TO_NUMBER (0)     RTN_ISU_QTY,
                 TO_NUMBER (0)     RTN_ISU_VAL,
                 TO_NUMBER (0)     INT_ORG_RCV_QTY,
                 TO_NUMBER (0)     INT_ORG_RCV_VAL,
                 TO_NUMBER (0)     SUB_INV_RCV_QTY,
                 TO_NUMBER (0)     SUB_INV_RCV_VAL,
                 TO_NUMBER (0)     RCV_QTY,
                 TO_NUMBER (0)     RCV_VAL,
                 I.INT_ORG_ISU_QTY,
                 I.INT_ORG_ISU_VAL,
                 I.SUB_INV_ISU_QTY,
                 I.SUB_INV_ISU_VAL,
                 I.ISU_QTY,
                 I.ISU_VAL,
                 TO_NUMBER (0)     MO_ISU_QTY,
                 TO_NUMBER (0)     MO_ISU_VAL,
                 TO_NUMBER (0)     MSC_RCV_QTY,
                 TO_NUMBER (0)     MSC_RCV_VAL,
                 TO_NUMBER (0)     CON_QTY,
                 TO_NUMBER (0)     CON_VAL
            FROM MAINS M, ISSUE I
           WHERE     1 = 1
                 AND M.ORGANIZATION_ID = I.ORGANIZATION_ID
                 AND M.INVENTORY_ITEM_ID = I.INVENTORY_ITEM_ID
                 AND :P_REPORT_TYPE = 'YES'
                 AND I.ISU_QTY <> 0
          UNION ALL
          SELECT M.ORGANIZATION_ID,
                 M.ORGANIZATION_NAME,
                 M.SECONDARY_INVENTORY,
                 M.ITEM_MJR_CAT,
                 M.ITEM_MNR_CAT,
                 M.INVENTORY_ITEM_ID,
                 M.ITEM_CODE,
                 M.ITEM_NAME,
                 M.UOM,
                 TO_NUMBER (0)     PO_RCV_QTY,
                 TO_NUMBER (0)     PO_RCV_VAL,
                 TO_NUMBER (0)     RTN_ISU_QTY,
                 TO_NUMBER (0)     RTN_ISU_VAL,
                 TO_NUMBER (0)     INT_ORG_RCV_QTY,
                 TO_NUMBER (0)     INT_ORG_RCV_VAL,
                 TO_NUMBER (0)     SUB_INV_RCV_QTY,
                 TO_NUMBER (0)     SUB_INV_RCV_VAL,
                 TO_NUMBER (0)     RCV_QTY,
                 TO_NUMBER (0)     RCV_VAL,
                 TO_NUMBER (0)     INT_ORG_ISU_QTY,
                 TO_NUMBER (0)     INT_ORG_ISU_VAL,
                 TO_NUMBER (0)     SUB_INV_ISU_QTY,
                 TO_NUMBER (0)     SUB_INV_ISU_VAL,
                 TO_NUMBER (0)     ISU_QTY,
                 TO_NUMBER (0)     ISU_VAL,
                 N.MO_ISU_QTY,
                 N.MO_ISU_VAL,
                 N.MSC_RCV_QTY,
                 N.MSC_RCV_VAL,
                 N.CON_QTY,
                 N.CON_VAL
            FROM MAINS M, CONSUME N
           WHERE     1 = 1
                 AND M.ORGANIZATION_ID = N.ORGANIZATION_ID
                 AND M.INVENTORY_ITEM_ID = N.INVENTORY_ITEM_ID
                 AND :P_REPORT_TYPE = 'YES')
GROUP BY ORGANIZATION_ID,
         ORGANIZATION_NAME,
         SECONDARY_INVENTORY,
         ITEM_MJR_CAT,
         ITEM_MNR_CAT,
         INVENTORY_ITEM_ID,
         ITEM_CODE,
         ITEM_NAME,
         UOM;