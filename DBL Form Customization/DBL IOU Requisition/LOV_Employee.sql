/* Formatted on 9/19/2020 3:30:00 PM (QP5 v5.287) */
SELECT NVL (PAPF.EMPLOYEE_NUMBER, PAPF.NPW_NUMBER) EMPLOYEE_NUMBER,
       (PAPF.FIRST_NAME || ' ' || PAPF.MIDDLE_NAMES || ' ' || PAPF.LAST_NAME)
          AS EMPLOYEE_NAME
  FROM APPS.PER_ALL_ASSIGNMENTS_F PAAF,
       APPS.PER_ALL_PEOPLE_F PAPF,
       APPS.PER_JOBS PJ,
       APPS.HR_ALL_ORGANIZATION_UNITS HAOU,
       APPS.PER_PAY_BASES PPB,
       APPS.PAY_PEOPLE_GROUPS PPG,
       APPS.PAY_PAYROLLS_F PPF,
       APPS.HR_LOCATIONS_ALL HLA,
       FND_USER FU
 WHERE     1 = 1
       AND PAAF.BUSINESS_GROUP_ID = 81
       AND PAPF.PERSON_ID = PAAF.PERSON_ID(+)
       AND PAAF.JOB_ID = PJ.JOB_ID(+)
       AND PAAF.PAYROLL_ID = PPF.PAYROLL_ID(+)
       AND PAAF.LOCATION_ID = HLA.LOCATION_ID(+)
       AND PAAF.PEOPLE_GROUP_ID = PPG.PEOPLE_GROUP_ID(+)
       AND PAAF.ORGANIZATION_ID = HAOU.ORGANIZATION_ID(+)
       AND TRUNC (SYSDATE) BETWEEN TRUNC (PAAF.EFFECTIVE_START_DATE)
                               AND TRUNC (PAAF.EFFECTIVE_END_DATE)
       AND TRUNC (SYSDATE) BETWEEN TRUNC (PAPF.EFFECTIVE_START_DATE)
                               AND TRUNC (PAPF.EFFECTIVE_END_DATE)
       AND NVL (PAPF.EMPLOYEE_NUMBER, PAPF.NPW_NUMBER) = FU.USER_NAME(+);



--------------------------------------------------------------------------------

SELECT NVL (PAPF.EMPLOYEE_NUMBER, PAPF.NPW_NUMBER) EMPLOYEE_NUMBER,
       (PAPF.FIRST_NAME || ' ' || PAPF.MIDDLE_NAMES || ' ' || PAPF.LAST_NAME)
          AS EMPLOYEE_NAME,
       SUBSTR (PJ.NAME, INSTR (PJ.NAME, '.') + 1) DESIGNATION,
       HAOU.NAME DEPARTMENT
  FROM APPS.PER_ALL_ASSIGNMENTS_F PAAF,
       APPS.PER_ALL_PEOPLE_F PAPF,
       APPS.PER_JOBS PJ,
       APPS.HR_ALL_ORGANIZATION_UNITS HAOU,
       APPS.PER_PAY_BASES PPB,
       APPS.PAY_PEOPLE_GROUPS PPG,
       APPS.PAY_PAYROLLS_F PPF,
       APPS.HR_LOCATIONS_ALL HLA,
       FND_USER FU
 WHERE     1 = 1
       AND PAAF.BUSINESS_GROUP_ID = 81
       AND PAPF.PERSON_ID = PAAF.PERSON_ID(+)
       AND PAAF.JOB_ID = PJ.JOB_ID(+)
       AND PAAF.PAYROLL_ID = PPF.PAYROLL_ID(+)
       AND PAAF.LOCATION_ID = HLA.LOCATION_ID(+)
       AND PAAF.PEOPLE_GROUP_ID = PPG.PEOPLE_GROUP_ID(+)
       AND PAAF.ORGANIZATION_ID = HAOU.ORGANIZATION_ID(+)
       AND TRUNC (SYSDATE) BETWEEN TRUNC (PAAF.EFFECTIVE_START_DATE)
                               AND TRUNC (PAAF.EFFECTIVE_END_DATE)
       AND TRUNC (SYSDATE) BETWEEN TRUNC (PAPF.EFFECTIVE_START_DATE)
                               AND TRUNC (PAPF.EFFECTIVE_END_DATE)
       AND NVL (PAPF.EMPLOYEE_NUMBER, PAPF.NPW_NUMBER) = FU.USER_NAME(+);


--------------------------------------------------------------------------------


SELECT NVL (PAPF.EMPLOYEE_NUMBER, PAPF.NPW_NUMBER) EMPLOYEE_NUMBER,
       (PAPF.FIRST_NAME || ' ' || PAPF.MIDDLE_NAMES || ' ' || PAPF.LAST_NAME)
          AS EMPLOYEE_NAME
  FROM APPS.PER_ALL_PEOPLE_F PAPF, FND_USER FU
 WHERE     1 = 1
       AND TRUNC (SYSDATE) BETWEEN TRUNC (PAPF.EFFECTIVE_START_DATE)
                               AND TRUNC (PAPF.EFFECTIVE_END_DATE)
       AND NVL (PAPF.EMPLOYEE_NUMBER, PAPF.NPW_NUMBER) = FU.USER_NAME(+);


--------------------------------------------------------------------------------

select fu.user_name into v_emp_no from fnd_user fu where fu.user_id=:p_user_id;


--------------------------------------------------------------------------------

SELECT    DESCRIPTION
       || ', '
       || ADDRESS_LINE_1
       || DECODE (ADDRESS_LINE_2, NULL, ' ', ' , ')
       || DECODE (ADDRESS_LINE_3, NULL, ' ', ' , ')
          LOCATION_NAME
  FROM APPS.HR_LOCATIONS_ALL HLA
 WHERE 1 = 1 AND HLA.DESCRIPTION = 'Mymun Complex'