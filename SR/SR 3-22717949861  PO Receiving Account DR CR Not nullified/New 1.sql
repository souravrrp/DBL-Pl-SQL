---30424100099
--196618

---30424100115
--222151

--rrsl
SELECT * FROM RCV_RECEIVING_SUB_LEDGER
WHERE RCV_TRANSACTION_ID IN
(SELECT TRANSACTION_ID FROM RCV_TRANSACTIONS
WHERE PO_HEADER_ID =&&PO_HEADER_ID);

--mta
SELECT * FROM MTL_TRANSACTION_ACCOUNTS
WHERE TRANSACTION_ID IN
( SELECT TRANSACTION_ID FROM MTL_MATERIAL_TRANSACTIONS
WHERE TRANSACTION_SOURCE_ID = &&PO_HEADER_ID );

--xalrcv
SELECT *
FROM XLA_AE_LINES XAL
WHERE XAL.APPLICATION_ID = 707
AND AE_HEADER_ID in (SELECT XDL.ae_header_id
FROM XLA_DISTRIBUTION_LINKS XDL
WHERE XDL.SOURCE_DISTRIBUTION_ID_NUM_1
IN (SELECT to_char(RRSL.RCV_SUB_LEDGER_ID)
FROM RCV_RECEIVING_SUB_LEDGER RRSL
WHERE RRSL.RCV_TRANSACTION_ID IN
(SELECT RT.TRANSACTION_ID
FROM RCV_TRANSACTIONS RT
WHERE RT.PO_HEADER_ID = &&PO_HEADER_ID)
)
AND SOURCE_DISTRIBUTION_TYPE = 'RCV_RECEIVING_SUB_LEDGER'
AND APPLICATION_ID = 707
);

--xalinv
SELECT *
FROM XLA_AE_LINES XAL
WHERE XAL.APPLICATION_ID = 707
AND AE_HEADER_ID in (
SELECT XDL.ae_header_id
FROM XLA_DISTRIBUTION_LINKS XDL
WHERE XDL.SOURCE_DISTRIBUTION_ID_NUM_1
IN (SELECT to_char(MTA.INV_SUB_LEDGER_ID)
FROM mtl_transaction_accounts mta
WHERE TRANSACTION_ID IN
(SELECT transaction_id
FROM mtl_material_transactions
WHERE rcv_transaction_id IN
( SELECT transaction_id FROM RCV_TRANSACTIONS
WHERE PO_HEADER_ID =&&PO_HEADER_ID )
)
)
AND SOURCE_DISTRIBUTION_TYPE = 'MTL_TRANSACTION_ACCOUNTS'
AND APPLICATION_ID = 707
);