/* Formatted on 11/22/2020 5:15:44 PM (QP5 v5.287) */
CREATE OR REPLACE PACKAGE APPS.XX_COM_PKG
AS
   FUNCTION GET_USER_NAME (P_USER_ID IN NUMBER)
      RETURN VARCHAR2;

   FUNCTION GET_EMP_NAME_FROM_USER_ID (P_USER_ID IN NUMBER)
      RETURN VARCHAR2;

   FUNCTION GET_EMP_NAME_FROM_USER_NAME (P_USER_NAME IN VARCHAR2)
      RETURN VARCHAR2;

   FUNCTION GET_RESPONSIBILITY_NAME (P_RESPONSIBILITY_ID IN NUMBER)
      RETURN VARCHAR2;

   FUNCTION GET_APPLICATION_NAME (P_APPLICATION_ID IN NUMBER)
      RETURN VARCHAR2;

   FUNCTION GET_UNIT_NAME (P_ORG_ID IN NUMBER)
      RETURN VARCHAR2;

   FUNCTION GET_HR_OPERATING_UNIT (P_ORG_ID IN NUMBER)
      RETURN VARCHAR2;

   FUNCTION GET_UNIT_ADDRESS (P_ORG_ID IN NUMBER)
      RETURN VARCHAR2;

   FUNCTION GET_FLEX_VALUES_FROM_FLEX_ID (P_SEGMENT_VALUE     VARCHAR2,
                                          P_SEGMENT_NUMBER    NUMBER)
      RETURN VARCHAR2;

   FUNCTION GET_CONCAT_DESC_FROM_CCID (P_CCID         NUMBER,
                                       P_SEPARATOR    VARCHAR2 DEFAULT '.')
      RETURN VARCHAR2;

   FUNCTION GET_CONCAT_CODE_FROM_CCID (P_CCID         NUMBER,
                                       P_SEPARATOR    VARCHAR2 DEFAULT '.')
      RETURN VARCHAR2;

   FUNCTION AMOUNT_IN_WORD (P_AMT IN NUMBER)
      RETURN VARCHAR2;

   FUNCTION GET_ORG_ID_FROM_CCID (P_CCID IN NUMBER)
      RETURN NUMBER;

   FUNCTION GET_SEGMENT_VALUE_FROM_CCID (P_CCID             IN NUMBER,
                                         P_SEGMENT_NUMBER      NUMBER)
      RETURN VARCHAR2;


   FUNCTION GET_GL_CODE_DESC_FROM_CCID (P_CCID IN NUMBER)
      RETURN VARCHAR2;

   FUNCTION GET_GL_DESC_FROM_CCID (P_CCID IN NUMBER)
      RETURN VARCHAR2;

   FUNCTION GET_GL_CODE_DESC_FROM_CCID_IC (P_CCID IN NUMBER)
      RETURN VARCHAR2;

   FUNCTION GET_BS_SHORT_CODE (P_SEGMENT_VALUE IN VARCHAR2)
      RETURN VARCHAR2;

   FUNCTION GET_VALUE_SET_ID (P_SEGMENT IN VARCHAR2)
      RETURN NUMBER;

   FUNCTION CONVERT_UOM_TO_PCS (P_INVENTORY_ITEM_ID    NUMBER,
                                P_FROM_UOM             VARCHAR2,
                                P_QTY                  NUMBER,
                                P_TO_UOM               VARCHAR2)
      RETURN NUMBER;

   FUNCTION GET_SECCOND_FROM_TIME_DIFF (P_DATE_FROM   IN DATE,
                                        P_DATE_TO     IN DATE)
      RETURN NUMBER;

   FUNCTION GET_DIFF_TIME (P_DATE_FROM IN DATE, P_DATE_TO IN DATE)
      RETURN VARCHAR2;

   FUNCTION GET_LE_ID_FROM_LEDGER_ID (P_LEDGER_ID IN NUMBER)
      RETURN NUMBER;

   FUNCTION GET_LE_ID_FROM_ORG_ID (P_ORG_ID IN NUMBER)
      RETURN NUMBER;

   FUNCTION GET_LE_NAME_FROM_LE_ID (P_LE_ID IN NUMBER)
      RETURN VARCHAR2;

   FUNCTION GET_LEDGER_ID_FROM_ORG_ID (P_ORG_ID IN NUMBER)
      RETURN NUMBER;

   FUNCTION GET_SUPPLIERS_COUNTRY_NAME (P_VENDOR_ID IN NUMBER)
      RETURN VARCHAR2;

   FUNCTION GET_COMPANY_NAME (P_COMPANY_CODE IN VARCHAR2)
      RETURN VARCHAR2;

   FUNCTION GET_UNIT_NAME_FROM_BS (P_COMPANY_CODE IN VARCHAR2)
      RETURN VARCHAR2;

   FUNCTION GET_ORGANIZATION_NAME (P_ORG_ID IN NUMBER)
      RETURN VARCHAR2;

   FUNCTION GET_ORGANIZATION_ADDRESS (P_ORG_ID IN NUMBER)
      RETURN VARCHAR2;

   FUNCTION GET_SEQUENCE_VALUE (P_TABLE_NAME      VARCHAR2,
                                P_COLUMN_NAME     VARCHAR2,
                                P_WHERE_CLAUSE    VARCHAR2 DEFAULT NULL)
      RETURN NUMBER;

   FUNCTION IS_NUMBER (P_INPUT VARCHAR2)
      RETURN NUMBER;

   FUNCTION GET_NUMBER_FROM_STRING (P_STRING IN VARCHAR2)
      RETURN VARCHAR2;

   FUNCTION REMOVE_NUMBER_FROM_STRING (P_STRING IN VARCHAR2)
      RETURN VARCHAR2;

   FUNCTION GET_EVENT_ID_FROM_DESCRIPTION (P_DESCRIPTION IN VARCHAR2)
      RETURN NUMBER;

   PROCEDURE TRUNCATE_TABLE (P_TABLE_NAME IN VARCHAR2);

   FUNCTION GET_LEDGER_NAME_FROM_ID (P_LEDGER_ID IN NUMBER)
      RETURN VARCHAR2;

   PROCEDURE WRITELOG (P_TEXT VARCHAR2);

   FUNCTION Move_order_names (P_CUST_ID NUMBER)
      RETURN VARCHAR2;

   FUNCTION GET_DEPT_FROM_USER_NAME_ID (P_USER_NAME   IN VARCHAR2,
                                        P_USER_ID     IN NUMBER)
      RETURN VARCHAR2;
END;
/