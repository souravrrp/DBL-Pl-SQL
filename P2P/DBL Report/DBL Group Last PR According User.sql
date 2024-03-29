/* Formatted on 7/14/2020 9:50:27 AM (QP5 v5.287) */
  SELECT PRH.ORG_ID,
         HOU.NAME,
         OU.LEDGER_NAME,
         OU.LEGAL_ENTITY_NAME,
         MAX (PRH.SEGMENT1) "Last Requisition Number",
         PRH.AUTHORIZATION_STATUS REQ_STATUS,
         MAX (PRH.CREATION_DATE) REQ_CREATION_DATE,
         NVL(PPF.EMPLOYEE_NUMBER,PPF.NPW_NUMBER) REQUESTOR_ID,
         (PPF.FIRST_NAME || ' ' || PPF.MIDDLE_NAMES || ' ' || PPF.LAST_NAME) REQUESTOR_NAME
    --,PRH.*
    --,PPF.*
    --,OOD.*
    FROM APPS.PO_REQUISITION_HEADERS_ALL PRH,
         APPS.HR_OPERATING_UNITS HOU,
         --ORG_ORGANIZATION_DEFINITIONS OOD,
         XXDBL_COMPANY_LE_MAPPING_V OU,
         APPS.PER_ALL_PEOPLE_F PPF
   WHERE     1 = 1
         AND HOU.ORGANIZATION_ID = PRH.ORG_ID
         AND HOU.ORGANIZATION_ID = OU.ORG_ID
         AND PRH.PREPARER_ID = PPF.PERSON_ID(+)
         --AND ( ( :P_ORG_ID IS NULL) OR (PRH.ORG_ID = :P_ORG_ID))
         --AND ( :P_REQ_NO IS NULL OR (PRH.SEGMENT1 = :P_REQ_NO))
         --AND ( ( :P_EMP_ID IS NULL) OR (PPF.EMPLOYEE_NUMBER = :P_EMP_ID))
         AND PRH.AUTHORIZATION_STATUS = 'APPROVED'
GROUP BY PRH.ORG_ID,
         HOU.NAME,
         OU.LEDGER_NAME,
         OU.LEGAL_ENTITY_NAME,
         --PRH.SEGMENT1,
         PRH.AUTHORIZATION_STATUS,
         --PRH.CREATION_DATE,
         (PPF.FIRST_NAME || ' ' || PPF.MIDDLE_NAMES || ' ' || PPF.LAST_NAME),
         NVL(PPF.EMPLOYEE_NUMBER,PPF.NPW_NUMBER);