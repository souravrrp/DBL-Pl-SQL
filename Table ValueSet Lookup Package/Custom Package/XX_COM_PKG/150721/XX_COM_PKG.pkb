/* Formatted on 7/15/2021 10:48:08 AM (QP5 v5.287) */
CREATE OR REPLACE PACKAGE BODY APPS.XX_COM_PKG
AS
   FUNCTION GET_USER_NAME (P_USER_ID IN NUMBER)
      RETURN VARCHAR2
   IS
      V_USER_NAME   FND_USER.USER_NAME%TYPE := '';

      CURSOR P_USER_CURSOR
      IS
         SELECT USER_NAME
           FROM FND_USER
          WHERE USER_ID = P_USER_ID;
   BEGIN
      OPEN P_USER_CURSOR;

      FETCH P_USER_CURSOR INTO V_USER_NAME;

      CLOSE P_USER_CURSOR;

      RETURN V_USER_NAME;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN NULL;
   END;

   FUNCTION GET_EMP_NAME_FROM_USER_ID (P_USER_ID IN NUMBER)
      RETURN VARCHAR2
   IS
      V_RESULT   VARCHAR2 (128);

      CURSOR P_CURSOR
      IS
         SELECT NVL (
                      DECODE (EMP.FIRST_NAME, NULL, NULL, EMP.FIRST_NAME)
                   || DECODE (EMP.MIDDLE_NAMES,
                              NULL, NULL,
                              ' ' || EMP.MIDDLE_NAMES)
                   || DECODE (EMP.LAST_NAME,
                              NULL, NULL,
                              ' ' || EMP.LAST_NAME),
                   USER_NAME)
           FROM FND_USER USR, PER_ALL_PEOPLE_F EMP
          WHERE     USR.EMPLOYEE_ID = EMP.PERSON_ID(+)
                AND EMP.EFFECTIVE_END_DATE(+) > SYSDATE
                AND USR.USER_ID = P_USER_ID;
   BEGIN
      OPEN P_CURSOR;

      FETCH P_CURSOR INTO V_RESULT;

      CLOSE P_CURSOR;

      RETURN V_RESULT;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN NULL;
   END;

   FUNCTION GET_EMP_NAME_FROM_USER_NAME (P_USER_NAME IN VARCHAR2)
      RETURN VARCHAR2
   IS
      V_RESULT   VARCHAR2 (128);

      CURSOR P_CURSOR
      IS
         SELECT    DECODE (EMP.FIRST_NAME, NULL, NULL, EMP.FIRST_NAME)
                || DECODE (EMP.MIDDLE_NAMES,
                           NULL, NULL,
                           ' ' || EMP.MIDDLE_NAMES)
                || DECODE (EMP.LAST_NAME, NULL, NULL, ' ' || EMP.LAST_NAME)
           FROM FND_USER USR, PER_ALL_PEOPLE_F EMP
          WHERE     USR.EMPLOYEE_ID = EMP.PERSON_ID
                AND USR.USER_NAME = P_USER_NAME
                AND EFFECTIVE_END_DATE > SYSDATE;
   BEGIN
      OPEN P_CURSOR;

      FETCH P_CURSOR INTO V_RESULT;

      CLOSE P_CURSOR;

      RETURN V_RESULT;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN NULL;
   END;

   FUNCTION GET_RESPONSIBILITY_NAME (P_RESPONSIBILITY_ID IN NUMBER)
      RETURN VARCHAR2
   IS
      V_RESPONSIBILITY_NAME   FND_RESPONSIBILITY_TL.RESPONSIBILITY_NAME%TYPE
                                 := '';

      CURSOR P_RESPONSIBILITY_CURSOR
      IS
         SELECT RESPONSIBILITY_NAME
           FROM FND_RESPONSIBILITY_TL
          WHERE RESPONSIBILITY_ID = P_RESPONSIBILITY_ID;
   BEGIN
      OPEN P_RESPONSIBILITY_CURSOR;

      FETCH P_RESPONSIBILITY_CURSOR INTO V_RESPONSIBILITY_NAME;

      CLOSE P_RESPONSIBILITY_CURSOR;

      RETURN (V_RESPONSIBILITY_NAME);
   END;

   FUNCTION GET_APPLICATION_NAME (P_APPLICATION_ID IN NUMBER)
      RETURN VARCHAR2
   IS
      V_APPLICATION_NAME   FND_APPLICATION_TL.APPLICATION_NAME%TYPE := '';

      CURSOR P_APPLICATION_CURSOR
      IS
         SELECT APPLICATION_NAME
           FROM FND_APPLICATION_TL
          WHERE APPLICATION_ID = P_APPLICATION_ID;
   BEGIN
      OPEN P_APPLICATION_CURSOR;

      FETCH P_APPLICATION_CURSOR INTO V_APPLICATION_NAME;

      CLOSE P_APPLICATION_CURSOR;

      RETURN (V_APPLICATION_NAME);
   END;

   FUNCTION GET_UNIT_NAME (P_ORG_ID IN NUMBER)
      RETURN VARCHAR2
   IS
      V_UNIT_NAME   FND_LOOKUP_VALUES_VL.MEANING%TYPE;

      CURSOR P_ORG_CURSOR
      IS
         SELECT MEANING
           FROM FND_LOOKUP_VALUES_VL
          WHERE LOOKUP_TYPE = 'XX_OU_NAMES' AND LOOKUP_CODE = P_ORG_ID;
   BEGIN
      OPEN P_ORG_CURSOR;

      FETCH P_ORG_CURSOR INTO V_UNIT_NAME;

      CLOSE P_ORG_CURSOR;

      RETURN V_UNIT_NAME;
   END GET_UNIT_NAME;


   FUNCTION GET_HR_OPERATING_UNIT (P_ORG_ID IN NUMBER)
      RETURN VARCHAR2
   IS
      V_UNIT_NAME   HR_OPERATING_UNITS.NAME%TYPE := '';

      CURSOR P_UNIT_CURSOR
      IS
         SELECT NAME
           FROM HR_OPERATING_UNITS
          WHERE ORGANIZATION_ID = P_ORG_ID;
   BEGIN
      OPEN P_UNIT_CURSOR;

      FETCH P_UNIT_CURSOR INTO V_UNIT_NAME;

      CLOSE P_UNIT_CURSOR;

      RETURN V_UNIT_NAME;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN NULL;
   END;

   FUNCTION GET_UNIT_ADDRESS (P_ORG_ID IN NUMBER)
      RETURN VARCHAR2
   IS
      V_UNIT_ADDRESS   FND_LOOKUP_VALUES_VL.DESCRIPTION%TYPE;

      CURSOR P_ORG_CURSOR
      IS
         SELECT DESCRIPTION
           FROM FND_LOOKUP_VALUES_VL
          WHERE LOOKUP_TYPE = 'XX_OU_NAMES' AND LOOKUP_CODE = P_ORG_ID;
   BEGIN
      OPEN P_ORG_CURSOR;

      FETCH P_ORG_CURSOR INTO V_UNIT_ADDRESS;

      CLOSE P_ORG_CURSOR;

      RETURN V_UNIT_ADDRESS;
   END GET_UNIT_ADDRESS;

   FUNCTION GET_FLEX_VALUES_FROM_FLEX_ID (P_SEGMENT_VALUE     VARCHAR2,
                                          P_SEGMENT_NUMBER    NUMBER)
      RETURN VARCHAR2
   IS
      V_RESULT   VARCHAR2 (240);

      CURSOR P_CURSOR
      IS
         SELECT FVV.DESCRIPTION
           FROM FND_ID_FLEX_SEGMENTS_VL FVD, FND_FLEX_VALUES_VL FVV
          WHERE     FVD.FLEX_VALUE_SET_ID = FVV.FLEX_VALUE_SET_ID
                AND FVD.APPLICATION_ID = 101
                AND FVD.ID_FLEX_CODE = 'GL#'
                --AND FVV.SUMMARY_FLAG = 'N'  -- for parrent value include
                AND SUBSTR (FVD.APPLICATION_COLUMN_NAME, 8, 1) =
                       TO_CHAR (P_SEGMENT_NUMBER)
                AND FVV.FLEX_VALUE = P_SEGMENT_VALUE;
   BEGIN
      OPEN P_CURSOR;

      FETCH P_CURSOR INTO V_RESULT;

      CLOSE P_CURSOR;

      RETURN (V_RESULT);
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN NULL;
   END;

   FUNCTION GET_CONCAT_DESC_FROM_CCID (P_CCID         NUMBER,
                                       P_SEPARATOR    VARCHAR2 DEFAULT '.')
      RETURN VARCHAR2
   AS
      V_CONCAT_DESC   VARCHAR2 (2000);
   BEGIN
      SELECT    XX_COM_PKG.GET_FLEX_VALUES_FROM_FLEX_ID (SEGMENT1, 1)
             || P_SEPARATOR
             || XX_COM_PKG.GET_FLEX_VALUES_FROM_FLEX_ID (SEGMENT2, 2)
             || P_SEPARATOR
             || XX_COM_PKG.GET_FLEX_VALUES_FROM_FLEX_ID (SEGMENT3, 3)
             || P_SEPARATOR
             || XX_COM_PKG.GET_FLEX_VALUES_FROM_FLEX_ID (SEGMENT4, 4)
             || P_SEPARATOR
             || XX_COM_PKG.GET_FLEX_VALUES_FROM_FLEX_ID (SEGMENT5, 5)
             || XX_COM_PKG.GET_FLEX_VALUES_FROM_FLEX_ID (SEGMENT6, 6)
        INTO V_CONCAT_DESC
        FROM GL_CODE_COMBINATIONS_KFV
       WHERE CODE_COMBINATION_ID = P_CCID;

      RETURN V_CONCAT_DESC;
   EXCEPTION
      WHEN OTHERS
      THEN
         NULL;
   END;

   FUNCTION GET_CONCAT_CODE_FROM_CCID (P_CCID         NUMBER,
                                       P_SEPARATOR    VARCHAR2 DEFAULT '.')
      RETURN VARCHAR2
   AS
      V_CONCAT_DESC   VARCHAR2 (2000);
   BEGIN
      SELECT CONCATENATED_SEGMENTS
        INTO V_CONCAT_DESC
        FROM GL_CODE_COMBINATIONS_KFV
       WHERE CODE_COMBINATION_ID = P_CCID;

      RETURN V_CONCAT_DESC;
   EXCEPTION
      WHEN OTHERS
      THEN
         NULL;
   END;

   FUNCTION GET_ORG_ID_FROM_CCID (P_CCID IN NUMBER)
      RETURN NUMBER
   AS
      V_OUTPUT   NUMBER;
   BEGIN
      SELECT UCM.ORG_ID
        INTO V_OUTPUT
        FROM GL_CODE_COMBINATIONS GCC, XX_UNIT_COMPANY_MAPPING UCM
       WHERE GCC.SEGMENT1 = UCM.BAL_SEG AND GCC.CODE_COMBINATION_ID = P_CCID;

      RETURN V_OUTPUT;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN NULL;
   END;

   FUNCTION GET_SEGMENT_VALUE_FROM_CCID (P_CCID             IN NUMBER,
                                         P_SEGMENT_NUMBER      NUMBER)
      RETURN VARCHAR2
   AS
      V_SEGMENT_VALUE   VARCHAR2 (128);
   BEGIN
      SELECT DECODE (P_SEGMENT_NUMBER,
                     1, SEGMENT1,
                     2, SEGMENT2,
                     3, SEGMENT3,
                     4, SEGMENT4,
                     5, SEGMENT5,
                     6, SEGMENT6,
                     7, SEGMENT7,
                     8, SEGMENT8,
                     9, SEGMENT9)
        INTO V_SEGMENT_VALUE
        FROM GL_CODE_COMBINATIONS_KFV
       WHERE CODE_COMBINATION_ID = P_CCID;

      RETURN V_SEGMENT_VALUE;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN NULL;
   END;



   FUNCTION GET_GL_CODE_DESC_FROM_CCID (P_CCID IN NUMBER)
      RETURN VARCHAR2
   IS
      V_OUTPUT   VARCHAR2 (240);

      CURSOR P_CURSOR
      IS
         SELECT FVV.FLEX_VALUE || ' - ' || FVV.DESCRIPTION
           FROM FND_ID_FLEX_SEGMENTS_VL FVD,
                FND_SEGMENT_ATTRIBUTE_VALUES SAV,
                FND_FLEX_VALUES_VL FVV,
                GL_CODE_COMBINATIONS GCC
          WHERE     FVD.ID_FLEX_NUM = SAV.ID_FLEX_NUM
                AND FVD.ID_FLEX_CODE = SAV.ID_FLEX_CODE
                AND FVD.APPLICATION_ID = SAV.APPLICATION_ID
                AND FVD.APPLICATION_COLUMN_NAME = SAV.APPLICATION_COLUMN_NAME
                AND FVD.FLEX_VALUE_SET_ID = FVV.FLEX_VALUE_SET_ID
                AND FVD.ID_FLEX_NUM = GCC.CHART_OF_ACCOUNTS_ID
                AND FVV.FLEX_VALUE =
                       DECODE (SUBSTR (FVD.APPLICATION_COLUMN_NAME, 8, 1),
                               '1', GCC.SEGMENT1,
                               '2', GCC.SEGMENT2,
                               '3', GCC.SEGMENT3,
                               '4', GCC.SEGMENT4,
                               '5', GCC.SEGMENT5,
                               '6', GCC.SEGMENT6,
                               '7', GCC.SEGMENT7,
                               '8', GCC.SEGMENT8,
                               '9', GCC.SEGMENT9)
                AND FVD.APPLICATION_ID = 101
                AND FVD.ID_FLEX_CODE = 'GL#'
                AND SAV.SEGMENT_ATTRIBUTE_TYPE = 'GL_ACCOUNT'
                AND SAV.ATTRIBUTE_VALUE = 'Y'
                AND GCC.CODE_COMBINATION_ID = P_CCID;
   BEGIN
      OPEN P_CURSOR;

      FETCH P_CURSOR INTO V_OUTPUT;

      CLOSE P_CURSOR;

      RETURN (V_OUTPUT);
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN NULL;
   END;



   FUNCTION GET_GL_DESC_FROM_CCID (P_CCID IN NUMBER)
      RETURN VARCHAR2
   IS
      V_OUTPUT   VARCHAR2 (240);

      CURSOR P_CURSOR
      IS
         SELECT FVV.DESCRIPTION
           FROM FND_ID_FLEX_SEGMENTS_VL FVD,
                FND_SEGMENT_ATTRIBUTE_VALUES SAV,
                FND_FLEX_VALUES_VL FVV,
                GL_CODE_COMBINATIONS GCC
          WHERE     FVD.ID_FLEX_NUM = SAV.ID_FLEX_NUM
                AND FVD.ID_FLEX_CODE = SAV.ID_FLEX_CODE
                AND FVD.APPLICATION_ID = SAV.APPLICATION_ID
                AND FVD.APPLICATION_COLUMN_NAME = SAV.APPLICATION_COLUMN_NAME
                AND FVD.FLEX_VALUE_SET_ID = FVV.FLEX_VALUE_SET_ID
                AND FVD.ID_FLEX_NUM = GCC.CHART_OF_ACCOUNTS_ID
                AND FVV.FLEX_VALUE =
                       DECODE (SUBSTR (FVD.APPLICATION_COLUMN_NAME, 8, 1),
                               '1', GCC.SEGMENT1,
                               '2', GCC.SEGMENT2,
                               '3', GCC.SEGMENT3,
                               '4', GCC.SEGMENT4,
                               '5', GCC.SEGMENT5,
                               '6', GCC.SEGMENT6,
                               '7', GCC.SEGMENT7,
                               '8', GCC.SEGMENT8,
                               '9', GCC.SEGMENT9)
                AND FVD.APPLICATION_ID = 101
                AND FVD.ID_FLEX_CODE = 'GL#'
                AND SAV.SEGMENT_ATTRIBUTE_TYPE = 'GL_ACCOUNT'
                AND SAV.ATTRIBUTE_VALUE = 'Y'
                AND GCC.CODE_COMBINATION_ID = P_CCID;
   BEGIN
      OPEN P_CURSOR;

      FETCH P_CURSOR INTO V_OUTPUT;

      CLOSE P_CURSOR;

      RETURN (V_OUTPUT);
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN NULL;
   END;



   FUNCTION GET_GL_CODE_DESC_FROM_CCID_IC (P_CCID IN NUMBER)
      RETURN VARCHAR2
   AS
      V_RESULT   VARCHAR2 (240);

      CURSOR P_CURSOR
      IS
         SELECT DECODE (
                   GCC.SEGMENT3,
                   '1080101',    FVN.FLEX_VALUE
                              || ' - '
                              || FVN.DESCRIPTION
                              || ' ('
                              || FVI.DESCRIPTION
                              || ')',
                   FVN.FLEX_VALUE || ' - ' || FVN.DESCRIPTION)
           FROM FND_FLEX_VALUES_VL FVN,
                GL_CODE_COMBINATIONS GCC,
                FND_FLEX_VALUES_VL FVI
          WHERE     GCC.SEGMENT3 = FVN.FLEX_VALUE
                AND GCC.SEGMENT4 = FVI.FLEX_VALUE
                AND FVN.FLEX_VALUE_SET_ID = 1014889
                AND FVI.FLEX_VALUE_SET_ID = 1014967
                AND GCC.CODE_COMBINATION_ID = P_CCID;
   BEGIN
      OPEN P_CURSOR;

      FETCH P_CURSOR INTO V_RESULT;

      CLOSE P_CURSOR;

      RETURN V_RESULT;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN NULL;
   END;

   FUNCTION GET_BS_SHORT_CODE (P_SEGMENT_VALUE IN VARCHAR2)
      RETURN VARCHAR2
   AS
      V_OUTPUT   VARCHAR2 (100);

      CURSOR P_CURSOR
      IS
         SELECT FVV.DESCRIPTION
           FROM FND_ID_FLEX_SEGMENTS_VL FVD,
                FND_FLEX_VALUES_VL FVV,
                FND_SEGMENT_ATTRIBUTE_VALUES SAV
          WHERE     FVD.APPLICATION_ID = SAV.APPLICATION_ID
                AND FVD.ID_FLEX_CODE = SAV.ID_FLEX_CODE
                AND FVD.ID_FLEX_NUM = SAV.ID_FLEX_NUM
                AND FVD.APPLICATION_COLUMN_NAME = SAV.APPLICATION_COLUMN_NAME
                AND FVD.FLEX_VALUE_SET_ID = FVV.FLEX_VALUE_SET_ID
                AND FVD.APPLICATION_ID = 101
                AND FVD.ID_FLEX_CODE = 'GL#'
                AND FVV.SUMMARY_FLAG = 'N'
                AND SAV.SEGMENT_ATTRIBUTE_TYPE = 'GL_BALANCING'
                AND SAV.ATTRIBUTE_VALUE = 'Y'
                AND FVV.FLEX_VALUE = P_SEGMENT_VALUE;
   BEGIN
      OPEN P_CURSOR;

      FETCH P_CURSOR INTO V_OUTPUT;

      CLOSE P_CURSOR;

      RETURN (V_OUTPUT);
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN NULL;
   END;

   FUNCTION GET_VALUE_SET_ID (P_SEGMENT IN VARCHAR2)
      RETURN NUMBER
   AS
      V_RESULT   NUMBER (10);

      CURSOR P_CURSOR
      IS
         SELECT FLEX_VALUE_SET_ID
           FROM FND_ID_FLEX_SEGMENTS_VL
          WHERE     APPLICATION_ID = 101
                AND ID_FLEX_CODE = 'GL#'
                AND APPLICATION_COLUMN_NAME = P_SEGMENT;
   BEGIN
      OPEN P_CURSOR;

      FETCH P_CURSOR INTO V_RESULT;

      CLOSE P_CURSOR;

      RETURN (V_RESULT);
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN NULL;
   END;

   FUNCTION CONVERT_UOM_TO_PCS (P_INVENTORY_ITEM_ID      NUMBER,
                                P_FROM_UOM               VARCHAR2,
                                P_QTY                    NUMBER,
                                P_TO_UOM              IN VARCHAR2)
      RETURN NUMBER
   AS
      V_PCS_QTY         NUMBER;
      V_PCS_TOTAL_QTY   NUMBER;
   BEGIN
      --IF  P_FROM_UOM=P_TO_UOM THEN
      -- V_PCS_TOTAL_QTY:=P_QTY*1;
      --   ELSE
      IF P_FROM_UOM = 'FT'
      THEN
         SELECT ROUND ( (C.CONVERSION_RATE * A.CONVERSION_RATE), 3)
           INTO V_PCS_QTY
           FROM MTL_UOM_CONVERSIONS C,
                MTL_UNITS_OF_MEASURE B,
                MTL_UOM_CLASS_CONVERSIONS A
          WHERE     C.INVENTORY_ITEM_ID = P_INVENTORY_ITEM_ID
                AND C.UOM_CODE = P_FROM_UOM
                AND B.UOM_CLASS = C.UOM_CLASS
                AND B.BASE_UOM_FLAG = 'Y'
                AND C.INVENTORY_ITEM_ID = A.INVENTORY_ITEM_ID
                AND A.TO_UOM_CODE = B.UOM_CODE
                AND A.FROM_UOM_CODE = P_TO_UOM;
      ELSE
         SELECT ROUND ( (C.CONVERSION_RATE * A.CONVERSION_RATE), 2)
           INTO V_PCS_QTY
           FROM MTL_UOM_CONVERSIONS C,
                MTL_UNITS_OF_MEASURE B,
                MTL_UOM_CLASS_CONVERSIONS A
          WHERE     C.INVENTORY_ITEM_ID = P_INVENTORY_ITEM_ID
                AND C.UOM_CODE = P_FROM_UOM
                AND B.UOM_CLASS = C.UOM_CLASS
                AND B.BASE_UOM_FLAG = 'Y'
                AND C.INVENTORY_ITEM_ID = A.INVENTORY_ITEM_ID
                AND A.TO_UOM_CODE = B.UOM_CODE
                AND A.FROM_UOM_CODE = P_TO_UOM;
      END IF;

      ---  END IF;
      V_PCS_TOTAL_QTY := ROUND (NVL (V_PCS_QTY, 0) * NVL (P_QTY, 0));
      RETURN V_PCS_TOTAL_QTY;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN 0;
   END;

   FUNCTION GET_SECCOND_FROM_TIME_DIFF (P_DATE_FROM   IN DATE,
                                        P_DATE_TO     IN DATE)
      RETURN NUMBER
   IS
      NDATE_1     NUMBER;
      NDATE_2     NUMBER;
      NSECOND_1   NUMBER (5, 0);
      NSECOND_2   NUMBER (5, 0);
   BEGIN
      -- Get Julian date number from first date (DATE_1)
      NDATE_1 := TO_NUMBER (TO_CHAR (P_DATE_FROM, 'J'));

      -- Get Julian date number from second date (DATE_2)
      NDATE_2 := TO_NUMBER (TO_CHAR (P_DATE_TO, 'J'));

      -- Get seconds since midnight from first date (DATE_1)
      NSECOND_1 := TO_NUMBER (TO_CHAR (P_DATE_FROM, 'SSSSS'));

      -- Get seconds since midnight from second date (DATE_2)
      NSECOND_2 := TO_NUMBER (TO_CHAR (P_DATE_TO, 'SSSSS'));

      RETURN FLOOR (
                  ( (P_DATE_TO - P_DATE_FROM) * 86400)
                + (P_DATE_TO - P_DATE_FROM));
   END;

   FUNCTION GET_DIFF_TIME (P_DATE_FROM IN DATE, P_DATE_TO IN DATE)
      RETURN VARCHAR2
   AS
      V_TIME   VARCHAR2 (100);
   BEGIN
      SELECT    DECODE (
                   FLOOR (
                        GET_SECCOND_FROM_TIME_DIFF (P_DATE_FROM, P_DATE_TO)
                      / 86400),
                   0, '',
                      FLOOR (
                           GET_SECCOND_FROM_TIME_DIFF (P_DATE_FROM,
                                                       P_DATE_TO)
                         / 86400)
                   || ' day(s), ')
             || TO_CHAR (
                   TO_DATE (
                      MOD (
                         FLOOR (
                            GET_SECCOND_FROM_TIME_DIFF (P_DATE_FROM,
                                                        P_DATE_TO)),
                         86400),
                      'SSSSS'),
                   'HH24:MI:SS')
        INTO V_TIME
        FROM DUAL;

      RETURN (V_TIME);
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN 'Error';
   END;

   FUNCTION GET_LE_ID_FROM_LEDGER_ID (P_LEDGER_ID IN NUMBER)
      RETURN NUMBER
   IS
      V_LEGAL_ENTITY   ORG_ORGANIZATION_DEFINITIONS.LEGAL_ENTITY%TYPE := '';

      CURSOR P_LEGAL_ENTITY_CURSOR
      IS
         SELECT MAX (LEGAL_ENTITY)
           FROM ORG_ORGANIZATION_DEFINITIONS
          WHERE SET_OF_BOOKS_ID = P_LEDGER_ID;
   BEGIN
      OPEN P_LEGAL_ENTITY_CURSOR;

      FETCH P_LEGAL_ENTITY_CURSOR INTO V_LEGAL_ENTITY;

      CLOSE P_LEGAL_ENTITY_CURSOR;

      RETURN (V_LEGAL_ENTITY);
   END;

   FUNCTION GET_LE_ID_FROM_ORG_ID (P_ORG_ID IN NUMBER)
      RETURN NUMBER
   IS
      V_LEGAL_ENTITY   ORG_ORGANIZATION_DEFINITIONS.LEGAL_ENTITY%TYPE := '';

      CURSOR P_LEGAL_ENTITY_CURSOR
      IS
         SELECT MAX (LEGAL_ENTITY)
           FROM ORG_ORGANIZATION_DEFINITIONS
          WHERE OPERATING_UNIT = P_ORG_ID;
   BEGIN
      OPEN P_LEGAL_ENTITY_CURSOR;

      FETCH P_LEGAL_ENTITY_CURSOR INTO V_LEGAL_ENTITY;

      CLOSE P_LEGAL_ENTITY_CURSOR;

      RETURN (V_LEGAL_ENTITY);
   END;

   FUNCTION GET_LE_NAME_FROM_LE_ID (P_LE_ID IN NUMBER)
      RETURN VARCHAR2
   IS
      V_RESULT   VARCHAR2 (240);

      CURSOR P_CURSOR
      IS
         SELECT NAME
           FROM XLE.XLE_ENTITY_PROFILES
          WHERE LEGAL_ENTITY_ID = P_LE_ID;
   BEGIN
      OPEN P_CURSOR;

      FETCH P_CURSOR INTO V_RESULT;

      CLOSE P_CURSOR;

      RETURN (V_RESULT);
   END;

   FUNCTION GET_LEDGER_ID_FROM_ORG_ID (P_ORG_ID IN NUMBER)
      RETURN NUMBER
   IS
      V_LEDGER_ID   NUMBER;

      CURSOR P_LEDGER_CURSOR
      IS
         SELECT SET_OF_BOOKS_ID
           FROM HR_OPERATING_UNITS
          WHERE ORGANIZATION_ID = P_ORG_ID;
   BEGIN
      OPEN P_LEDGER_CURSOR;

      FETCH P_LEDGER_CURSOR INTO V_LEDGER_ID;

      CLOSE P_LEDGER_CURSOR;

      RETURN (V_LEDGER_ID);
   END;

   FUNCTION GET_SUPPLIERS_COUNTRY_NAME (P_VENDOR_ID IN NUMBER)
      RETURN VARCHAR2
   IS
      V_COUNTRY_NAME   FND_TERRITORIES_TL.TERRITORY_SHORT_NAME%TYPE := '';

      CURSOR P_COUNTRY_CURSOR
      IS
           SELECT MAX (CO.TERRITORY_SHORT_NAME)
             FROM AP_SUPPLIERS AV,
                  AP_SUPPLIER_SITES_ALL ST,
                  FND_TERRITORIES_TL CO
            WHERE     AV.VENDOR_ID = ST.VENDOR_ID
                  AND ST.COUNTRY = CO.TERRITORY_CODE
                  AND AV.VENDOR_ID = P_VENDOR_ID
         GROUP BY AV.VENDOR_ID;
   BEGIN
      OPEN P_COUNTRY_CURSOR;

      FETCH P_COUNTRY_CURSOR INTO V_COUNTRY_NAME;

      CLOSE P_COUNTRY_CURSOR;

      RETURN (NVL (V_COUNTRY_NAME, 'Not Defined'));
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN NULL;
   END;


   FUNCTION GET_COMPANY_NAME (P_COMPANY_CODE IN VARCHAR2)
      RETURN VARCHAR2
   IS
      V_COMPANY_NAME   FND_LOOKUP_VALUES_VL.MEANING%TYPE;

      CURSOR P_COMPANY_CURSOR
      IS
         SELECT DESCRIPTION
           FROM FND_FLEX_VALUES_VL
          WHERE FLEX_VALUE_SET_ID = 1017028 AND FLEX_VALUE = P_COMPANY_CODE;
   BEGIN
      OPEN P_COMPANY_CURSOR;

      FETCH P_COMPANY_CURSOR INTO V_COMPANY_NAME;

      CLOSE P_COMPANY_CURSOR;

      RETURN V_COMPANY_NAME;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN NULL;
   END;

   FUNCTION GET_UNIT_NAME_FROM_BS (P_COMPANY_CODE IN VARCHAR2)
      RETURN VARCHAR2
   IS
      V_COMPANY_NAME   FND_LOOKUP_VALUES_VL.MEANING%TYPE;

      CURSOR P_COMPANY_CURSOR
      IS
         SELECT DISTINCT OU.LEGAL_ENTITY_NAME
           FROM FND_FLEX_VALUES_VL BS, XXDBL_COMPANY_LE_MAPPING_V OU
          WHERE     BS.FLEX_VALUE_MEANING = OU.COMPANY_CODE
                AND BS.FLEX_VALUE_SET_ID = 1017028
                AND BS.FLEX_VALUE = P_COMPANY_CODE;
   BEGIN
      OPEN P_COMPANY_CURSOR;

      FETCH P_COMPANY_CURSOR INTO V_COMPANY_NAME;

      CLOSE P_COMPANY_CURSOR;

      RETURN V_COMPANY_NAME;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN NULL;
   END;

   FUNCTION GET_ORGANIZATION_NAME (P_ORG_ID IN NUMBER)
      RETURN VARCHAR2
   IS
      V_ORGANIZATION_NAME   VARCHAR2 (4000);

      CURSOR P_ORGNAME_CURSOR
      IS
         SELECT NAME
           FROM HR_ALL_ORGANIZATION_UNITS
          WHERE ORGANIZATION_ID = P_ORG_ID;
   BEGIN
      OPEN P_ORGNAME_CURSOR;

      FETCH P_ORGNAME_CURSOR INTO V_ORGANIZATION_NAME;

      CLOSE P_ORGNAME_CURSOR;

      RETURN V_ORGANIZATION_NAME;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN NULL;
   END;

   FUNCTION GET_ORGANIZATION_ADDRESS (P_ORG_ID IN NUMBER)
      RETURN VARCHAR2
   IS
      V_ORGANIZATION_ADDRESSE   VARCHAR2 (4000);

      CURSOR P_ADDRESS_CURSOR
      IS
         SELECT    ADDRESS_LINE_1
                || ' '
                || ADDRESS_LINE_2
                || ' '
                || ADDRESS_LINE_3
                || DECODE (TOWN_OR_CITY, NULL, NULL, ', ' || TOWN_OR_CITY)
                   ADDRESS
           FROM HR_LOCATIONS_ALL LOC, HR_ALL_ORGANIZATION_UNITS ORG
          WHERE     LOC.LOCATION_ID = ORG.LOCATION_ID
                AND ORG.ORGANIZATION_ID = P_ORG_ID;
   BEGIN
      OPEN P_ADDRESS_CURSOR;

      FETCH P_ADDRESS_CURSOR INTO V_ORGANIZATION_ADDRESSE;

      CLOSE P_ADDRESS_CURSOR;

      RETURN V_ORGANIZATION_ADDRESSE;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN NULL;
   END;

   FUNCTION AMOUNT_IN_WORD (P_AMT IN NUMBER)
      RETURN VARCHAR2
   IS
      M_MAIN_AMT_TEXT     VARCHAR2 (2000);
      M_TOP_AMT_TEXT      VARCHAR2 (2000);
      M_BOTTOM_AMT_TEXT   VARCHAR2 (2000);
      M_DECIMAL_TEXT      VARCHAR2 (2000);
      M_TOP               NUMBER (20, 5);
      M_MAIN_AMT          NUMBER (20, 5);
      M_TOP_AMT           NUMBER (20, 5);
      M_BOTTOM_AMT        NUMBER (20, 5);
      M_DECIMAL           NUMBER (20, 5);
      M_AMT               NUMBER (20, 5);
      M_TEXT              VARCHAR2 (2000);
   BEGIN
      M_MAIN_AMT := NULL;
      M_TOP_AMT_TEXT := NULL;
      M_BOTTOM_AMT_TEXT := NULL;
      M_DECIMAL_TEXT := NULL;
      M_DECIMAL := TRUNC (ABS (P_AMT), 2) - TRUNC (ABS (P_AMT));

      IF M_DECIMAL > 0
      THEN
         M_DECIMAL := M_DECIMAL * 100;
      END IF;

      M_AMT := TRUNC (ABS (P_AMT));
      M_TOP := TRUNC (M_AMT / 100000);
      M_MAIN_AMT := TRUNC (M_TOP / 100);
      M_TOP_AMT := M_TOP - M_MAIN_AMT * 100;
      M_BOTTOM_AMT := M_AMT - (M_TOP * 100000);

      IF M_MAIN_AMT > 0
      THEN
         M_MAIN_AMT_TEXT := TO_CHAR (TO_DATE (M_MAIN_AMT, 'J'), 'JSP');

         IF M_MAIN_AMT = 1
         THEN
            M_MAIN_AMT_TEXT := M_MAIN_AMT_TEXT || ' CRORE ';
         ELSE
            M_MAIN_AMT_TEXT := M_MAIN_AMT_TEXT || ' CRORES ';
         END IF;
      END IF;

      IF M_TOP_AMT > 0
      THEN
         M_TOP_AMT_TEXT := TO_CHAR (TO_DATE (M_TOP_AMT, 'J'), 'JSP');

         IF M_TOP_AMT = 1
         THEN
            M_TOP_AMT_TEXT := M_TOP_AMT_TEXT || ' LAC ';
         ELSE
            M_TOP_AMT_TEXT := M_TOP_AMT_TEXT || ' LACS ';
         END IF;
      END IF;

      IF M_BOTTOM_AMT > 0
      THEN
         M_BOTTOM_AMT_TEXT := TO_CHAR (TO_DATE (M_BOTTOM_AMT, 'J'), 'JSP');
      END IF;

      IF M_DECIMAL > 0
      THEN
         IF NVL (M_BOTTOM_AMT, 0) + NVL (M_TOP_AMT, 0) > 0
         THEN
            M_DECIMAL_TEXT :=
                  'and '
               || INITCAP (TO_CHAR (TO_DATE (M_DECIMAL, 'J'), 'JSP'))
               || ' Paisa ';
         ELSE
            M_DECIMAL_TEXT :=
                  'and '
               || INITCAP (TO_CHAR (TO_DATE (M_DECIMAL, 'J'), 'JSP'))
               || ' Paisa ';
         END IF;
      END IF;

      M_TEXT :=
            INITCAP (M_MAIN_AMT_TEXT)
         || INITCAP (M_TOP_AMT_TEXT)
         || INITCAP (M_BOTTOM_AMT_TEXT)
         || ' Taka '
         || M_DECIMAL_TEXT
         || 'Only';
      M_TEXT := UPPER (SUBSTR (M_TEXT, 1, 1)) || SUBSTR (M_TEXT, 2);
      M_TEXT := ' ' || M_TEXT;
      RETURN (TRIM (
                 CASE
                    WHEN SUBSTR (TRIM (REPLACE (M_TEXT, '-', ' ')), 1, 4) =
                            'Taka'
                    THEN
                       SUBSTR (TRIM (REPLACE (M_TEXT, '-', ' ')), 10, 2000)
                    ELSE
                       TRIM (REPLACE (M_TEXT, '-', ' '))
                 END));
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN 'Input is too long to display';
   END;

   FUNCTION GET_SEQUENCE_VALUE (P_TABLE_NAME      VARCHAR2,
                                P_COLUMN_NAME     VARCHAR2,
                                P_WHERE_CLAUSE    VARCHAR2 DEFAULT NULL)
      RETURN NUMBER
   IS
      V_SEQUENCE_VALUE   NUMBER;
      V_SQL_STATEMENT    VARCHAR2 (2000);
   BEGIN
      IF P_WHERE_CLAUSE IS NOT NULL
      THEN
         V_SQL_STATEMENT :=
               'SELECT NVL(MAX('
            || P_COLUMN_NAME
            || '),10000) + 1 FROM XX.'
            || P_TABLE_NAME
            || ' WHERE '
            || P_WHERE_CLAUSE;
      ELSE
         V_SQL_STATEMENT :=
               'SELECT NVL(MAX('
            || P_COLUMN_NAME
            || '),10000) + 1 FROM '
            || P_TABLE_NAME;
      END IF;

      EXECUTE IMMEDIATE V_SQL_STATEMENT INTO V_SEQUENCE_VALUE;

      RETURN V_SEQUENCE_VALUE;
   END;

   FUNCTION IS_NUMBER (P_INPUT VARCHAR2)
      RETURN NUMBER
   AS
      V_INPUT   NUMBER;
   BEGIN
      V_INPUT := NVL (TRANSLATE ( (P_INPUT), '.', 1), 'AKG');
      RETURN 1;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN NULL;
   END;

   FUNCTION GET_NUMBER_FROM_STRING (P_STRING IN VARCHAR2)
      RETURN VARCHAR2
   AS
      V_LENGTH   NUMBER;
      V_INPUT    VARCHAR2 (1);
      V_OUTPUT   VARCHAR2 (4000);
   BEGIN
      V_LENGTH := LENGTH (P_STRING);

      FOR I IN 1 .. V_LENGTH
      LOOP
         V_INPUT := SUBSTR (P_STRING, I, 1);

         IF IS_NUMBER (V_INPUT) = 1
         THEN
            V_OUTPUT := V_OUTPUT || V_INPUT;
         END IF;
      END LOOP;

      RETURN V_OUTPUT;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN NULL;
   END;

   FUNCTION REMOVE_NUMBER_FROM_STRING (P_STRING IN VARCHAR2)
      RETURN VARCHAR2
   AS
      V_LENGTH   NUMBER;
      V_INPUT    VARCHAR2 (1);
      V_OUTPUT   VARCHAR2 (4000);
   BEGIN
      V_LENGTH := LENGTH (P_STRING);

      FOR I IN 1 .. V_LENGTH
      LOOP
         V_INPUT := SUBSTR (P_STRING, I, 1);

         IF IS_NUMBER (V_INPUT) = 0
         THEN
            V_OUTPUT := V_OUTPUT || V_INPUT;
         END IF;
      END LOOP;

      RETURN V_OUTPUT;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN NULL;
   END;

   FUNCTION GET_EVENT_ID_FROM_DESCRIPTION (P_DESCRIPTION IN VARCHAR2)
      RETURN NUMBER
   IS
      V_RESULT   NUMBER;

      CURSOR P_CURSOR
      IS
         SELECT GET_NUMBER_FROM_STRING (
                   SUBSTR (P_DESCRIPTION,
                           INSTR (P_DESCRIPTION, 'event_id of'),
                           24))
           FROM DUAL;
   BEGIN
      OPEN P_CURSOR;

      FETCH P_CURSOR INTO V_RESULT;

      CLOSE P_CURSOR;

      RETURN V_RESULT;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN NULL;
   END;

   PROCEDURE TRUNCATE_TABLE (P_TABLE_NAME IN VARCHAR2)
   IS
   --   PRAGMA AUTONOMOUS_TRANSACTION;
   BEGIN
      EXECUTE IMMEDIATE 'TRUNCATE TABLE ' || P_TABLE_NAME;
   END;

   FUNCTION GET_LEDGER_NAME_FROM_ID (P_LEDGER_ID IN NUMBER)
      RETURN VARCHAR2
   IS
      V_RESULT   VARCHAR2 (30);

      CURSOR P_CURSOR
      IS
         SELECT NAME
           FROM GL_LEDGERS
          WHERE LEDGER_ID = P_LEDGER_ID;
   BEGIN
      OPEN P_CURSOR;

      FETCH P_CURSOR INTO V_RESULT;

      CLOSE P_CURSOR;

      RETURN (V_RESULT);
   END;

   PROCEDURE WRITELOG (P_TEXT VARCHAR2)
   IS
   -- Wrapper Prc
   -- Write LOG or 'dbms_output'
   BEGIN
      IF FND_GLOBAL.CONC_REQUEST_ID > 0
      THEN
         FND_FILE.PUT_LINE (FND_FILE.LOG, P_TEXT);
      ELSE
         DBMS_OUTPUT.ENABLE (1000000);
         DBMS_OUTPUT.PUT_LINE (P_TEXT);
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         NULL;
   END WRITELOG;

   FUNCTION Move_order_names (P_CUST_ID NUMBER)
      RETURN VARCHAR2
   IS
      V   VARCHAR2 (150);
   BEGIN
      SELECT DISTINCT REQUEST_NUMBER
        INTO V
        FROM mtl_txn_request_headers
       WHERE HEADER_ID = P_CUST_ID;

      RETURN V;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN NULL;
   END Move_order_names;

   FUNCTION GET_DEPT_FROM_USER_NAME_ID (P_USER_NAME   IN VARCHAR2,
                                        P_USER_ID     IN NUMBER)
      RETURN VARCHAR2
   IS
      V_RESULT   VARCHAR2 (1000);

      -- PURPOSE : GET EMPLOYEE DEPT NAME FROM USER NAME OR USER ID

      CURSOR P_CURSOR
      IS
         SELECT HAOU.NAME
           FROM HR.PER_ALL_PEOPLE_F PAPF,
                HR.PER_ALL_ASSIGNMENTS_F PAAF,
                HR.HR_ALL_ORGANIZATION_UNITS HAOU,
                FND_USER FU
          WHERE     SYSDATE BETWEEN PAPF.EFFECTIVE_START_DATE
                                AND PAPF.EFFECTIVE_END_DATE
                AND SYSDATE BETWEEN PAAF.EFFECTIVE_START_DATE
                                AND PAAF.EFFECTIVE_END_DATE
                AND PAPF.PERSON_ID = PAAF.PERSON_ID
                AND PAAF.ORGANIZATION_ID = HAOU.ORGANIZATION_ID
                AND FU.EMPLOYEE_ID = PAPF.PERSON_ID(+)
                AND FU.USER_NAME = NVL (P_USER_NAME, FU.USER_NAME)
                AND FU.USER_ID = NVL (P_USER_ID, FU.USER_ID);
   BEGIN
      OPEN P_CURSOR;

      FETCH P_CURSOR INTO V_RESULT;

      CLOSE P_CURSOR;

      RETURN V_RESULT;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN NULL;
   END;

   FUNCTION DESIGNATION_FROM_USER_NAME_ID (P_USER_NAME   IN VARCHAR2,
                                           P_USER_ID     IN NUMBER)
      RETURN VARCHAR2
   IS
      v_result   VARCHAR2 (1000);

      -- CREATED BY : SOURAV PAUL
      -- CREATION DATE : 31-DEC-2020
      -- LAST UPDATE DATE :31-DEC-2020
      -- PURPOSE : GET EMPLOYEE DESIGNATION FROM USER NAME OR USER ID

      CURSOR p_cursor
      IS
         SELECT SUBSTR (pj.name, INSTR (pj.name, '.') + 1) designation
           FROM hr.per_all_people_f papf,
                hr.per_all_assignments_f paaf,
                apps.per_jobs pj,
                fnd_user fu
          WHERE     SYSDATE BETWEEN papf.effective_start_date
                                AND papf.effective_end_date
                AND SYSDATE BETWEEN paaf.effective_start_date
                                AND paaf.effective_end_date
                AND papf.person_id = paaf.person_id
                AND paaf.job_id = pj.job_id(+)
                AND fu.employee_id = papf.person_id(+)
                AND fu.user_name = NVL (p_user_name, fu.user_name)
                AND fu.user_id = NVL (p_user_id, fu.user_id);
   BEGIN
      OPEN p_cursor;

      FETCH p_cursor INTO v_result;

      CLOSE p_cursor;

      RETURN v_result;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN NULL;
   END;
END;
/