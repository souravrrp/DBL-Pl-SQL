/* Formatted on 5/11/2021 12:38:34 PM (QP5 v5.354) */
SELECT ROW_NUMBER () OVER (ORDER BY PAPF.PERSON_ID DESC)
           SL_NO,
       PAPF.PERSON_ID,
       NVL (PAPF.EMPLOYEE_NUMBER, PAPF.NPW_NUMBER)
           AS EMPLOYEE_NUMBER,
       UPPER (
           TRIM (
                  PAPF.FIRST_NAME
               || ' '
               || PAPF.MIDDLE_NAMES
               || ' '
               || PAPF.LAST_NAME))
           AS FULL_NAME,
       HAOU.NAME
           AS ORGANIZATION_NAME,
       SUBSTR (PJ.NAME, 1, INSTR (PJ.NAME, '.') - 1)
           AS JOB_CATEGORY,
       SUBSTR (PJ.NAME, INSTR (PJ.NAME, '.') + 1)
           AS JOB_DESIGNATION,
       IR.IOU_NUMBER
           AS REQUISITION_NO,
       IR.IOU_DATE
           AS REQUISITION_DATE,
       IR.OPERATING_UNIT,
       IR.OU_NAME
           AS UNIT_NAME,
       IR.LOCATION_NAME,
       IR.ADVANCE_AMOUNT,
       IR.REASON_FOR_ADVANCE,
       IR.ADJUST_DATE,
       APPS.XX_COM_PKG.AMOUNT_IN_WORD (IR.ADVANCE_AMOUNT)
           ADVANCE_IN_AMOUNT,
       IR.STATUS,
       IR.PAYMENT_DATE,
       IR.FIRST_APPROVER,
       IR.FST_APPROVER_NAME,
       REGEXP_SUBSTR (
           APPS.DESIGNATION_FROM_USER_NAME_ID (IR.FIRST_APPROVER, NULL),
           '[^.]+',
           1,
           1)
           FST_DEPARTMENT,
       REGEXP_SUBSTR (
           APPS.DESIGNATION_FROM_USER_NAME_ID (IR.FIRST_APPROVER, NULL),
           '[^.]+',
           1,
           2)
           FST_DESIGNATION,
       IR.SECOND_APPROVER,
       IR.SND_APPROVER_NAME,
       REGEXP_SUBSTR (
           APPS.DESIGNATION_FROM_USER_NAME_ID (IR.SECOND_APPROVER, NULL),
           '[^.]+',
           1,
           1)
           SND_DEPARTMENT,
       REGEXP_SUBSTR (
           APPS.DESIGNATION_FROM_USER_NAME_ID (IR.SECOND_APPROVER, NULL),
           '[^.]+',
           1,
           2)
           SND_DESIGNATION,
       IR.RETURN_DAYS
  FROM FND_USER                        PPF,
       APPS.PER_PEOPLE_F               PAPF,
       PER_ALL_ASSIGNMENTS_F           PAAF,
       APPS.HR_ALL_ORGANIZATION_UNITS  HAOU,
       APPS.PER_JOBS                   PJ,
       XXDBL.XXDBL_IOU_REQ_DTL         IR
 WHERE     1 = 1
       AND PAPF.PERSON_ID = PAAF.PERSON_ID
       AND PAAF.ORGANIZATION_ID = HAOU.ORGANIZATION_ID(+)
       AND PJ.JOB_ID(+) = PAAF.JOB_ID
       AND SYSDATE BETWEEN PAAF.EFFECTIVE_START_DATE
                       AND PAAF.EFFECTIVE_END_DATE
       AND SYSDATE BETWEEN PAPF.EFFECTIVE_START_DATE
                       AND PAPF.EFFECTIVE_END_DATE
       AND ppf.employee_id = papf.person_id(+)
       AND ir.created_by = ppf.user_id(+)
       AND IR.IOU_NUMBER = :P_IOU_NUMBER;