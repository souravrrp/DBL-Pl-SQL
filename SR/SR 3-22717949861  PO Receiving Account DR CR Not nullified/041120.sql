SELECT * FROM RCV_TRANSACTIONS
WHERE TRANSACTION_ID =450332;

SELECT * FROM RCV_RECEIVING_SUB_LEDGER
WHERE RCV_TRANSACTION_ID IN
(SELECT TRANSACTION_ID FROM RCV_TRANSACTIONS
WHERE TRANSACTION_ID =450332);