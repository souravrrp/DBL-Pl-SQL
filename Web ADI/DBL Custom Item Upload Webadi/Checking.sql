/* Formatted on 9/1/2021 12:46:49 PM (QP5 v5.287) */
--EXECUTE APPS.xxdbl_item_conv_prc();

SELECT *
  FROM xxdbl.xxdbl_item_master_conv
 WHERE 1 = 1 
 AND ITEM_CODE IN ('SPRECONS000000086370')
 --AND PRIMARY_UOM='TON'
--Order by desc
;

SELECT pw.ROWID rx, pw.*
  FROM xxdbl.xxdbl_item_master_conv pw
 WHERE     1 = 1
       AND NVL (pw.status, 'X') NOT IN ('I', 'S', 'D')
       AND pw.item_code LIKE 'SPRECONS000000086370%'
       AND pw.organization_code = 'IMO'
       AND NOT EXISTS
              (SELECT 1
                 FROM mtl_system_items_b msb, mtl_parameters mp
                WHERE     msb.organization_id = mp.organization_id
                      AND msb.segment1 = pw.item_code
                      AND mp.organization_code = pw.organization_code);

SELECT msii.SET_PROCESS_ID, msii.*
  FROM inv.mtl_system_items_interface msii
 WHERE     1 = 1
       --AND set_process_id = 1000
       --AND EXISTS (SELECT 1 FROM XXDBL.xxdbl_item_master_conv xxdbl WHERE xxdbl.item_code = msii.segment1)
       AND segment1 = 'SPRECONS000000086370'
       --AND TRUNC (CREATION_DATE) = TRUNC (SYSDATE)
       ;

SELECT *
  FROM MTL_SYSTEM_ITEMS_B
 WHERE     1 = 1
       AND SEGMENT1 = 'SPRECONS000000086220'
       AND TRUNC (CREATION_DATE) = TRUNC (SYSDATE);

SELECT *
  FROM XXDBL.xxdbl_item_master_conv xxdbl
 WHERE     1 = 1
       AND xxdbl.status = 'I'
       AND ITEM_CODE='SPRECONS000000086220'
       AND xxdbl.organization_code = 'IMO'
       --AND EXISTS (SELECT 1 FROM inv.mtl_system_items_interface msii WHERE xxdbl.item_code = msii.segment1 AND TRUNC (msii.creation_date) = TRUNC (SYSDATE))
       AND EXISTS
              (SELECT 1
                 FROM mtl_system_items_b msi
                WHERE     xxdbl.item_code = msi.segment1
                      AND msi.organization_id = 138
                      AND TRUNC (msi.creation_date) = TRUNC (SYSDATE));


--------------------------------------------------------------------------------

INSERT INTO INV.MTL_SYSTEM_ITEMS_INTERFACE (PROCESS_FLAG,
                                            SET_PROCESS_ID,
                                            TRANSACTION_TYPE,
                                            ORGANIZATION_ID,
                                            INVENTORY_ITEM_ID,
                                            MIN_MINMAX_QUANTITY)
   SELECT 1,
          99,
          'UPDATE',
          ORGANIZATION_ID,
          INVENTORY_ITEM_ID,
          MIN_ORDER_QTY
     FROM xxdbl.XXDBL_ITEM_MASTER_CONV
    WHERE STATUS IS NULL;

-----for update status----

UPDATE xxdbl.XXDBL_ITEM_MASTER_CONV
   SET status = 'I', STATUS_MESSAGE = 'INTERFACED'
 WHERE status IS NULL;


DELETE xxdbl.XXDBL_ITEM_MASTER_CONV
 WHERE status IS NULL;
 

--------------------------------------------------------------------------------


INSERT INTO INV.MTL_SYSTEM_ITEMS_INTERFACE (PROCESS_FLAG,
                                            SET_PROCESS_ID,
                                            TRANSACTION_TYPE,
                                            ORGANIZATION_ID,
                                            INVENTORY_ITEM_ID,
                                            ATTRIBUTE1,
                                            ATTRIBUTE_CATEGORY)
   SELECT 1,
          99,
          'UPDATE',
          ORGANIZATION_ID,
          INVENTORY_ITEM_ID,
          LEGACY_ITEM,
          ATTRIBUTE_CATEGORY
     FROM xxdbl.XXDB_ITM_DESC_UPD_STG
    WHERE done IS NULL;

-----for update status----

UPDATE xxdbl.XXDB_ITM_DESC_UPD_STG
   SET done = 'Y'
 WHERE done IS NULL;


SELECT * FROM xxdbl.XXDB_ITM_DESC_UPD_STG;

--------------------------------------------------------------------------------

--ALTER TABLE xxdbl.xxdbl_item_master_conv ADD (set_process_id NUMBER, creaed_by NUMBER, creation_date DATE);


SELECT *
  FROM INV.MTL_CATEGORIES_B MC
 WHERE 1 = 1;


SELECT category_id                                                      --INTO
                  l_category_id
  FROM mtl_categories_b mc
 WHERE     UPPER (mc.segment1) = UPPER ( :P_ITEM_CATEGORY_SEGMENT1)
       AND UPPER (mc.segment2) = UPPER ( :P_ITEM_CATEGORY_SEGMENT2)
       AND UPPER (mc.segment3) = UPPER ( :P_ITEM_CATEGORY_SEGMENT3)
       AND UPPER (mc.segment4) = UPPER ( :P_ITEM_CATEGORY_SEGMENT4);

--------------------------------------------------------------------------------

--ALTER TABLE xxdbl.xxdbl_item_master_conv ADD (CATEGORY_ID NUMBER);

--ALTER TABLE xxdbl.xxdbl_item_master_conv DROP COLUMN CATEGORY_ID;


SELECT COUNT (*)                                                        --INTO
                l_existing_orgh
  FROM xxdbl.xxdbl_item_master_conv imc
 WHERE     1 = 1
       AND imc.item_code = :p_item_code
       AND UPPER (imc.item_description) = UPPER ( :p_item_description)
       AND imc.org_hierarchy = :p_org_hierarchy;

SELECT LENGTH (TRIM ( :p_item_code))                                    --INTO
                                    len_item_code
  FROM DUAL
 WHERE     NOT EXISTS
              (SELECT 1
                 FROM xxdbl.xxdbl_item_master_conv imc
                WHERE     imc.item_code = :p_item_code
                      AND UPPER (imc.item_description) =
                             UPPER ( :p_item_description))
       AND NOT EXISTS
              (SELECT 1
                 FROM mtl_system_items_b msi
                WHERE     msi.segment1 = :p_item_code
                      AND UPPER (msi.description) =
                             UPPER ( :p_item_description)
                      AND msi.organization_id = 138);

SELECT msi.segment1
  FROM mtl_system_items_b msi
 WHERE msi.segment1 = :p_item_code AND msi.organization_id = 138;


SELECT msi.segment1
  FROM mtl_system_items_b msi
 WHERE     (UPPER (msi.description) = UPPER ( :p_item_description))
       AND msi.organization_id = 138;
       
SELECT
*
FROM
MTL_UNITS_OF_MEASURE_TL
WHERE UOM_CODE='TON'