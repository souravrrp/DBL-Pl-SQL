ALTER TABLE XXDBL.XXDBL_COMM_INV_HEADERS
   ADD (DOC_HOVER_GRP_COM DATE ,
        MAN_COM_INV_NO  VARCHAR2 (100 BYTE) ,
        RESN_DEL_BANK  VARCHAR2 (500 BYTE) ,
        DISCOUNT_DATE DATE ,
        DIS_AMNT NUMBER ,
        BANK_REF_NO  VARCHAR2 (100 BYTE)
        );