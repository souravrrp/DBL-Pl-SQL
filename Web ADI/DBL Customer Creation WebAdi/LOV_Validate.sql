/* Formatted on 9/16/2021 12:38:06 PM (QP5 v5.354) */
SELECT * FROM HR_OPERATING_UNITS;

SELECT * FROM AR_CUSTOMERS;


SELECT LOOKUP_CODE, MEANING, DESCRIPTION
  FROM FND_LOOKUP_VALUES_VL FLV
 WHERE 1 = 1 AND LOOKUP_TYPE = 'DEMAND_CLASS' AND ENABLED_FLAG = 'Y';

SELECT LOOKUP_CODE, MEANING, DESCRIPTION
  FROM FND_LOOKUP_VALUES_VL
 WHERE 1 = 1 AND LOOKUP_TYPE = 'CUSTOMER_CATEGORY' AND ENABLED_FLAG = 'Y';

SELECT CONCATENATED_SEGMENTS FROM APPS.GL_CODE_COMBINATIONS_KFV;

SELECT LOOKUP_CODE, MEANING, DESCRIPTION
  FROM FND_LOOKUP_VALUES_VL
 WHERE LOOKUP_TYPE = 'DBL_CUSTOMER_TYPE';

SELECT NAME FROM RA_TERMS;

SELECT EMPLOYEE_NUMBER
  FROM PER_ALL_PEOPLE_F
 WHERE     TRUNC (SYSDATE) BETWEEN TRUNC (EFFECTIVE_START_DATE) AND TRUNC (EFFECTIVE_END_DATE) AND NVL (CURRENT_EMP_OR_APL_FLAG, 'Y') = 'Y';
 
 /* Formatted on 9/16/2021 1:49:35 PM (QP5 v5.354) */
SELECT EMPLOYEE_NUMBER
  FROM PER_ALL_PEOPLE_F
 WHERE     TRUNC (SYSDATE) BETWEEN TRUNC (EFFECTIVE_START_DATE) AND TRUNC (EFFECTIVE_END_DATE) AND NVL (CURRENT_EMP_OR_APL_FLAG, 'Y') = 'Y' AND EXISTS (SELECT 1 FROM JTF_RS_SALESREPS WHERE JTF_RS_SALESREPS.PERSON_ID = PER_ALL_PEOPLE_F.PERSON_ID);