/* Formatted on 7/28/2019 6:10:08 PM (QP5 v5.287) */
SELECT FFVS.FLEX_VALUE_SET_ID,
       FFVS.FLEX_VALUE_SET_NAME,
       FFVS.DESCRIPTION SET_DESCRIPTION,
       FFVS.VALIDATION_TYPE,
       FFV.FLEX_VALUE,
       FFV.FLEX_VALUE_MEANING MEANING,
       FFV.DESCRIPTION VALUE_DESCRIPTION,
       FFV.ENABLED_FLAG,
       FFV.SUMMARY_FLAG,
       FFV.VALUE_CATEGORY
       --,FFV.*
       --,FFVS.*
  FROM APPS.FND_FLEX_VALUE_SETS FFVS, APPS.FND_FLEX_VALUES_VL FFV
 WHERE     1 = 1
       AND FFVS.FLEX_VALUE_SET_ID = FFV.FLEX_VALUE_SET_ID
       AND (   :P_VALUE_SET IS NULL OR (UPPER (FFVS.FLEX_VALUE_SET_NAME) LIKE UPPER ('%' || :P_VALUE_SET || '%')))
       --AND FFVS.FLEX_VALUE_SET_NAME IN ('DBL_LINE_OF_BUSINESS')
       --AND FFV.FLEX_VALUE IN ('DYED YARN')
       --AND FFVS.FLEX_VALUE_SET_ID='1015022'
       --AND FFV.DESCRIPTION IN ('1-D')
       AND (   :P_VALUE IS NULL OR (UPPER (FFV.FLEX_VALUE) LIKE UPPER ('%' || :P_VALUE || '%')))
       AND (   :P_MEANING IS NULL OR (UPPER (FFV.FLEX_VALUE_MEANING) LIKE UPPER ('%' || :P_MEANING || '%')))
       AND (   :P_DESCRIPTION IS NULL OR (UPPER (FFV.DESCRIPTION) LIKE UPPER ('%' || :P_DESCRIPTION || '%'))) 
;

-----------------------------------------------------------------------------

SELECT *
  FROM APPS.FND_FLEX_VALUE_SETS VAL_SET
 WHERE 1 = 1 AND FLEX_VALUE_SET_NAME = 'XXAKG_DRIVER_VS';


SELECT FLEX_VALUE, FFV.*
  FROM APPS.FND_FLEX_VALUES FFV
 WHERE 1 = 1 AND FLEX_VALUE LIKE '%DYED YARN%'
--AND FLEX_VALUE_SET_ID='1015022'
;

------------------------------------------------------------------------------------------------

SELECT VS.FLEX_VALUE_SET_NAME,
       VT.APPLICATION_TABLE_NAME,
       VT.VALUE_COLUMN_NAME DFF_VALUE,
       VT.MEANING_COLUMN_NAME DFF_DESCRIPTION,
       VT.ADDITIONAL_QUICKPICK_COLUMNS
  --,VT.*
  --,VS.*
  FROM APPS.FND_FLEX_VALUE_SETS VS, APPS.FND_FLEX_VALIDATION_TABLES VT
 WHERE     1 = 1
       AND VS.FLEX_VALUE_SET_ID = VT.FLEX_VALUE_SET_ID
       AND VS.FLEX_VALUE_SET_NAME = 'XXAKG_DRIVER_VS';

-------------------------************----------------------------------------------------

SELECT FFVS.FLEX_VALUE_SET_ID,
       FFVS.FLEX_VALUE_SET_NAME,
       FFVS.DESCRIPTION SET_DESCRIPTION,
       FFVS.VALIDATION_TYPE,
       FFVT.VALUE_COLUMN_NAME,
       FFVT.MEANING_COLUMN_NAME,
       FFVT.ID_COLUMN_NAME,
       FFVT.APPLICATION_TABLE_NAME,
       FFVT.ADDITIONAL_WHERE_CLAUSE
  FROM APPS.FND_FLEX_VALUE_SETS FFVS, APPS.FND_FLEX_VALIDATION_TABLES FFVT
 WHERE     FFVS.FLEX_VALUE_SET_ID = FFVT.FLEX_VALUE_SET_ID
       AND FFVS.FLEX_VALUE_SET_NAME = 'XXAKG_DRIVER_VS';


SELECT FFVS.FLEX_VALUE_SET_ID,
       FFVS.FLEX_VALUE_SET_NAME,
       FFVS.DESCRIPTION SET_DESCRIPTION,
       FFVS.VALIDATION_TYPE,
       FFV.FLEX_VALUE_ID,
       FFV.FLEX_VALUE,
       FFVT.FLEX_VALUE_MEANING,
       FFVT.DESCRIPTION VALUE_DESCRIPTION
  FROM APPS.FND_FLEX_VALUE_SETS FFVS,
       APPS.FND_FLEX_VALUES FFV,
       APPS.FND_FLEX_VALUES_TL FFVT
 WHERE     FFVS.FLEX_VALUE_SET_ID = FFV.FLEX_VALUE_SET_ID
       AND FFV.FLEX_VALUE_ID = FFVT.FLEX_VALUE_ID
       AND FFVT.LANGUAGE = USERENV ('LANG')
       AND FFVS.FLEX_VALUE_SET_NAME LIKE '%AKG_Cement_Item_Price_Location%';