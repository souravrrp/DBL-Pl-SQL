/* Formatted on 6/23/2020 11:31:14 AM (QP5 v5.287) */
SELECT cm.GATE_PASS_MASTER_ID,
       cm.TO_HEAD,
       cm.CHALLAN_NO,
       cm.ADDRESS,
       cm.CHALLAN_DATE,
       cm.DELIVERY_DATE,
       cm.VEHICLE_NO,
       cd.GATE_PASS_DETAIL_ID,
       --cd.ITEM_DESCRIPTION,
       --cd.ITEM_DESCRIPTION_MANUAL,
       COALESCE (cd.ITEM_DESCRIPTION, cd.ITEM_DESCRIPTION_MANUAL)
          ITEM_DESCRIPTION,
       cd.UNIT,
       cd.QUANTITY,
       cd.REMARKS,
       cd.PURPOSE
  FROM XXDBL_CERAMIC_GATE_PASS_MASTER cm, XXDBL_CERAMIC_GATE_PASS_DETAIL cd
 WHERE     cm.GATE_PASS_MASTER_ID = cd.GATE_PASS_MASTER_ID --AND cm.CHALLAN_NO = :p_Challan_No
       AND cm.GATE_PASS_MASTER_ID = 31;



SELECT cm.GATE_PASS_MASTER_ID,
       cm.TO_HEAD,
       cm.CHALLAN_NO,
       cm.ADDRESS,
       cm.CHALLAN_DATE,
       cm.DELIVERY_DATE,
       cm.VEHICLE_NO,
       cd.GATE_PASS_DETAIL_ID,
       COALESCE (cd.ITEM_DESCRIPTION, cd.ITEM_DESCRIPTION_MANUAL)
          ITEM_DESCRIPTION,
       cd.UNIT,
       cd.QUANTITY,
       cd.REMARKS,
       cd.PURPOSE
  FROM XXDBL_CERAMIC_GATE_PASS_MASTER cm, XXDBL_CERAMIC_GATE_PASS_DETAIL cd
 WHERE     cm.GATE_PASS_MASTER_ID = cd.GATE_PASS_MASTER_ID
 and CHALLAN_NO='CHA-104627'
       --AND cm.GATE_PASS_MASTER_ID = 31;