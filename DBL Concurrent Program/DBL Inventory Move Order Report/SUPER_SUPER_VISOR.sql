/* Formatted on 1/20/2020 5:44:31 PM (QP5 v5.287) */
SELECT --DISTINCT
      FU.USER_ID,
      PAPF.PERSON_ID,
      NVL(PAPF.EMPLOYEE_NUMBER,PAPF.NPW_NUMBER) EMPLOYEE_NUMBER,
       (PAPF.FIRST_NAME || ' ' || PAPF.MIDDLE_NAMES || ' ' || PAPF.LAST_NAME)
          AS EMPLOYEE_NAME,
       SUBSTR (PJ.NAME, INSTR (PJ.NAME, '.') + 1) DESIGNATION,
       PAPF.START_DATE AS DATE_OF_JOINING,
       HAOU.NAME DEPARTMENT,
       HLA.DESCRIPTION JOB_LOCATION
       ,PAPF.CURRENT_EMP_OR_APL_FLAG
       ,PAAF.PRIMARY_FLAG
       ,PAPFS.PERSON_ID SUPERV_PERSON_ID
       ,NVL (PAPFS.EMPLOYEE_NUMBER, PAPFS.NPW_NUMBER) SUPERV_EMPNO
       ,(PAPFS.FIRST_NAME || ' ' || PAPFS.MIDDLE_NAMES || ' ' || PAPFS.LAST_NAME)
          AS SUPERVISOR_NAME
       ,PAPFS2.PERSON_ID SUPERV_PERSON_ID
       ,NVL (PAPFS2.EMPLOYEE_NUMBER, PAPFS2.NPW_NUMBER) SUPERV_EMPNO
       ,(PAPFS2.FIRST_NAME || ' ' || PAPFS2.MIDDLE_NAMES || ' ' || PAPFS2.LAST_NAME)
          AS SUPERVISOR_NAME
       --,PAAF.*
       --,PAPF.*
       --,PJ.*
       ---,POSE.*
       --,HAOU.*
       --,HLA.*
  FROM APPS.PER_ALL_ASSIGNMENTS_F PAAF,
       APPS.PER_ALL_PEOPLE_F PAPF,
       APPS.PER_JOBS PJ,
       APPS.HR_ALL_ORGANIZATION_UNITS HAOU,
       APPS.HR_LOCATIONS_ALL HLA,
       FND_USER FU,
       HR.PER_ALL_ASSIGNMENTS_F PAAFS,
       HR.PER_ALL_PEOPLE_F PAPFS,
       HR.PER_ALL_ASSIGNMENTS_F PAAFS2,
       HR.PER_ALL_PEOPLE_F PAPFS2
 WHERE    1=1 
       AND PAAF.BUSINESS_GROUP_ID = 81
       AND PAPF.PERSON_ID = PAAF.PERSON_ID(+)
       AND PAAF.JOB_ID=PJ.JOB_ID(+)
       AND PAAF.LOCATION_ID = HLA.LOCATION_ID(+)
       AND PAAF.ORGANIZATION_ID=HAOU.ORGANIZATION_ID(+)
       AND TRUNC (SYSDATE) BETWEEN TRUNC (PAAF.EFFECTIVE_START_DATE) AND TRUNC (PAAF.EFFECTIVE_END_DATE)
       AND TRUNC (SYSDATE) BETWEEN TRUNC (PAPF.EFFECTIVE_START_DATE) AND TRUNC (PAPF.EFFECTIVE_END_DATE)
       AND NVL(PAPF.EMPLOYEE_NUMBER,PAPF.NPW_NUMBER)= FU.USER_NAME(+)
       AND PAAF.SUPERVISOR_ID = PAPFS.PERSON_ID(+)
       AND PAPFS.PERSON_ID = PAAFS.PERSON_ID(+)
       AND TRUNC (SYSDATE) BETWEEN TRUNC (PAAFS.EFFECTIVE_START_DATE) AND TRUNC (PAAFS.EFFECTIVE_END_DATE)
       AND TRUNC (SYSDATE) BETWEEN TRUNC (PAPFS.EFFECTIVE_START_DATE) AND TRUNC (PAPFS.EFFECTIVE_END_DATE)
       AND PAAFS.SUPERVISOR_ID = PAPFS2.PERSON_ID(+)
       AND PAPFS2.PERSON_ID = PAAFS2.PERSON_ID(+)
       AND TRUNC (SYSDATE) BETWEEN TRUNC (PAAFS2.EFFECTIVE_START_DATE) AND TRUNC (PAAFS2.EFFECTIVE_END_DATE)
       AND TRUNC (SYSDATE) BETWEEN TRUNC (PAPFS2.EFFECTIVE_START_DATE) AND TRUNC (PAPFS2.EFFECTIVE_END_DATE)
       AND user_id = 6223
       ;