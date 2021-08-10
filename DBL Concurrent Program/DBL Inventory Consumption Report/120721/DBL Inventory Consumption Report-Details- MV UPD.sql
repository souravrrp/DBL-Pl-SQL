/* Formatted on 7/3/2021 10:32:13 AM (QP5 v5.354) */
  SELECT ICRM.TR_TYPE,
         ICRM.ITEM_CODE,
         ICRM.ITEM_DESCRIPTION,
         ICRM.UOM,
         ICRM.ITEM_CATEGORY,
         ICRM.ITEM_TYPE,
         APPS.XX_COM_PKG.GET_DEPT_FROM_USER_NAME_ID (NULL, ICRM.CREATED_BY)
             DEPARTMENT,
         ICRM.NATURAL_ACCOUNT_DESC
             NATURAL_ACC,
         ICRM.PRODUCT_LINE_DESC,
         ICRM.COST_CENTER_DESC
       || ' - '
       || (SELECT DESCRIPTION
             FROM FND_FLEX_VALUES_VL
            WHERE     FLEX_VALUE_SET_ID = 1017032
                  AND FLEX_VALUE = ICRM.COST_CENTER_DESC)
           COST_CENTER_DESC,
         ICRM.NATURAL_ACCOUNT_DESC
       || ' - '
       || (SELECT DESCRIPTION
             FROM FND_FLEX_VALUES_VL
            WHERE     FLEX_VALUE_SET_ID = 1017040
                  AND FLEX_VALUE = ICRM.NATURAL_ACCOUNT_DESC)
           NATURAL_ACCOUNT_DESC,
         ICRM.SUB_ACCCOUNT_DESC
       || ' - '
       || (SELECT DESCRIPTION
             FROM APPS.FND_FLEX_VALUES_TL
            WHERE FLEX_VALUE_ID =
                  (SELECT FLEX_VALUE_ID
                     FROM APPS.FND_FLEX_VALUES
                    WHERE     FLEX_VALUE_SET_ID =
                              (SELECT FLEX_VALUE_SET_ID
                                 FROM APPS.FND_FLEX_VALUE_SETS
                                WHERE FLEX_VALUE_SET_NAME =
                                      'XXDBL_SUB_ACCOUNT_COA')
                          AND FLEX_VALUE = ICRM.SUB_ACCCOUNT_DESC
                          AND PARENT_FLEX_VALUE_LOW =
                              (SELECT FLEX_VALUE
                                 FROM FND_FLEX_VALUES_VL B
                                WHERE     FLEX_VALUE_SET_ID = 1017040
                                      AND B.FLEX_VALUE =
                                          ICRM.NATURAL_ACCOUNT_DESC)))
           SUB_ACCCOUNT_DESC,
         ICRM.EXP_CATEGORY_DESC,
         APPS.XX_COM_PKG.GET_HR_OPERATING_UNIT (ICRM.ORGANIZATION_ID)
             ORG_ID,
         ICRM.ORGANIZATION_NAME,
         ICRM.UNIT_COST,
         SUM (ICRM.QTY)
             QTY,
         SUM (ICRM.TOTAL_COST)
             TOT_COST
    FROM APPS.XXDBL_INV_CON_RPT_MV ICRM
   WHERE     (   :P_SET_OF_BOOKS_ID IS NULL
              OR ICRM.SET_OF_BOOKS_ID = :P_SET_OF_BOOKS_ID)
         AND ( :P_COMPANY IS NULL OR ICRM.COMPANY_CODE = :P_COMPANY)
         AND ( :P_ORG_ID IS NULL OR ICRM.ORGANIZATION_ID = :P_ORG_ID)
         AND ( :P_ACCOUNT IS NULL OR ICRM.NATURAL_ACC = :P_ACCOUNT)
         AND :P_REPORT_TYPE = 'Details'
         AND TRUNC (ICRM.TRANSACTION_DATE) BETWEEN :P_DATE_FROM AND :P_DATE_TO
GROUP BY ICRM.TR_TYPE,
         ICRM.ITEM_CODE,
         ICRM.ITEM_DESCRIPTION,
         ICRM.UOM,
         ICRM.ITEM_CATEGORY,
         ICRM.ITEM_TYPE,
         ICRM.CREATED_BY,
         ICRM.PRODUCT_LINE_DESC,
         ICRM.COST_CENTER_DESC,
         ICRM.NATURAL_ACCOUNT_DESC,
         ICRM.SUB_ACCCOUNT_DESC,
         ICRM.EXP_CATEGORY_DESC,
         ICRM.ORGANIZATION_ID,
         ICRM.ORGANIZATION_NAME,
         ICRM.UNIT_COST;