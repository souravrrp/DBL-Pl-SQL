/* Formatted on 10/26/2021 2:46:21 PM (QP5 v5.365) */
SELECT *
  FROM DBA_DEPENDENCIES
 WHERE     1 = 1
       --AND OWNER = 'APPS'
       --AND NAME = 'XX_BANK_LEDGER_V'
       --AND TYPE = 'VIEW'
       --AND OBJECT_TYPE IN ('TABLE','VIEW') 
       --AND OBJECT_TYPE IN ('PACKAGE','PACKAGE BODY') 
       --AND OBJECT_TYPE IN ('TRIGGER') 
       --AND OBJECT_TYPE IN ('FUNCTION') 
       --AND OBJECT_TYPE IN ('SEQUENCE')  
       --AND OBJECT_TYPE IN ('MATERIALIZED VIEW')
       AND (   :P_OBJECT_TYPE IS NULL OR (UPPER (OBJECT_TYPE) LIKE UPPER ('%' || :P_OBJECT_TYPE || '%')))
       AND (   :P_OBJECT_NAME IS NULL OR (UPPER (OBJECT_NAME) LIKE UPPER ('%' || :P_OBJECT_NAME || '%')))
       AND (   :P_OWNER_NAME IS NULL OR (UPPER (OWNER) = UPPER ( :P_OWNER_NAME)));