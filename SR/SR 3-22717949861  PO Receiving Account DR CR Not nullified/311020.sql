/* Formatted on 10/31/2020 10:54:57 AM (QP5 v5.354) */
SELECT *
  FROM RCV_TRANSACTIONS
 WHERE PO_HEADER_ID = 196618 AND SHIPMENT_HEADER_ID = 280491;

SELECT *
  FROM MTL_MATERIAL_TRANSACTIONS
 WHERE     TRANSACTION_SOURCE_ID = 196618
       AND RCV_TRANSACTION_ID IN
               (SELECT TRANSACTION_ID
                  FROM RCV_TRANSACTIONS
                 WHERE PO_HEADER_ID = 196618 AND SHIPMENT_HEADER_ID = 280491);

SELECT *
  FROM RCV_TRANSACTIONS
 WHERE PO_HEADER_ID = 196618 AND SHIPMENT_HEADER_ID = 280945;

SELECT *
  FROM MTL_MATERIAL_TRANSACTIONS
 WHERE     TRANSACTION_SOURCE_ID = 196618
       AND RCV_TRANSACTION_ID IN
               (SELECT TRANSACTION_ID
                  FROM RCV_TRANSACTIONS
                 WHERE PO_HEADER_ID = 196618 AND SHIPMENT_HEADER_ID = 280945);