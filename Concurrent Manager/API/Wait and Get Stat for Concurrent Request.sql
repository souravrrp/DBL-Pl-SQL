/* Formatted on 7/16/2020 2:54:04 PM (QP5 v5.287) */
CREATE OR REPLACE PACKAGE BODY MY_PACKAGE
IS
   FUNCTION MY_SUBMIR_REQUEST (P_APPLICATION   IN VARCHAR2 DEFAULT NULL,
                               P_PROGRAM       IN VARCHAR2 DEFAULT NULL,
                               P_DESCRIPTION   IN VARCHAR2 DEFAULT NULL,
                               P_START_TIME    IN VARCHAR2 DEFAULT NULL,
                               P_SUB_REQUEST   IN BOOLEAN DEFAULT FALSE,
                               P_ARGUMENT1     IN VARCHAR2 DEFAULT CHR (0),
                               P_ARGUMENT2     IN VARCHAR2 DEFAULT CHR (0),
                               P_ARGUMENT3     IN VARCHAR2 DEFAULT CHR (0))
      RETURN NUMBER
   IS
      O_REQ_ID              NUMBER;
      L_PHASE               VARCHAR2 (50);
      L_STATUS              VARCHAR2 (50);
      L_DEV_PHASE           VARCHAR2 (50);
      L_DEV_STATUS          VARCHAR2 (50);
      L_MESSAGE             VARCHAR2 (50);
      L_REQ_RETURN_STATUS   BOOLEAN;
   BEGIN
      O_REQ_ID :=
         apps.FND_REQUEST.SUBMIT_REQUEST (P_APPLICATION,
                                          P_PROGRAM,
                                          P_DESCRIPTION,
                                          P_START_TIME,
                                          P_SUB_REQUEST,
                                          P_ARGUMENT1,
                                          P_ARGUMENT2,
                                          P_ARGUMENT3);

      COMMIT;

      IF O_REQ_ID = 0
      THEN
         FND_FILE.PUT_LINE (
            FND_FILE.LOG,
            'Request Not Submitted due to "' || FND_MESSAGE.GET || '".');
      ELSE
         FND_FILE.PUT_LINE (
            FND_FILE.LOG,
               'Cuncurrent Program '
            || P_PROGRAM
            || ' submitted successfully � Request id :'
            || O_REQ_ID);
      END IF;

      IF O_REQ_ID > 0
      THEN
         LOOP
            --
            --To make function execution to wait for 1st program to complete
            --
            L_REQ_RETURN_STATUS :=
               FND_CONCURRENT.WAIT_FOR_REQUEST (REQUEST_ID   => O_REQ_ID,
                                                INTERVAL     => 1 --Number of seconds to wait between checks (i.e., number of seconds to sleep.)
                                                                 ,
                                                MAX_WAIT     => 0 --The maximum time in seconds to wait for the request's completion.
                                                                 ,
                                                PHASE        => L_PHASE,
                                                STATUS       => L_STATUS,
                                                DEV_PHASE    => L_DEV_PHASE,
                                                DEV_STATUS   => L_DEV_STATUS,
                                                MESSAGE      => L_MESSAGE);
            EXIT WHEN    UPPER (L_PHASE) = 'COMPLETED'
                      OR UPPER (L_STATUS) IN
                            ('CANCELLED', 'ERROR', 'TERMINATED');
         END LOOP;

         IF UPPER (L_PHASE) = 'COMPLETED' AND UPPER (L_STATUS) = 'ERROR'
         THEN
            FND_FILE.PUT_LINE (
               FND_FILE.LOG,
                  'The Cuncurrent Program '
               || P_PROGRAM
               || ' completed in error. Oracle request id: '
               || O_REQ_ID
               || ' '
               || SQLERRM);
         ELSIF UPPER (L_PHASE) = 'COMPLETED' AND UPPER (L_STATUS) = 'NORMAL'
         THEN
            FND_FILE.PUT_LINE (
               FND_FILE.LOG,
                  'The Cuncurrent Program '
               || P_PROGRAM
               || ' request is successful for request id: '
               || O_REQ_ID);
         END IF;
      END IF;

      RETURN (O_REQ_ID);
   END MY_SUBMIR_REQUEST;

   PROCEDURE MY_PROCEDURE (ERRBUF        OUT NOCOPY VARCHAR2,
                           RETCODE       OUT NOCOPY NUMBER,
                           P_VALUE1                 VARCHAR2,
                           P_VALUE2                 VARCHAR2)
   AS
      LN_SQLLDR_REQ_ID         NUMBER := 0;
      V_VALUE2                 VARCHAR2 (100);
      LN_PROC_REQ_ID           NUMBER := 0;
      V_HIER_LINES             NUMBER := NULL;
      V_LINES                  NUMBER := NULL;
      V_STATUS_CODE            FND_CONCURRENT_REQUESTS.STATUS_CODE%TYPE := NULL;
      V_COUNT_UNPPLOAD_LINES   NUMBER := 0;
      V_PRIM_COUNT             NUMBER := 0;
      V_DER_COUNT              NUMBER := 0;
      V_ODD_COUNT              NUMBER := 0;
   BEGIN
      FND_FILE.PUT_LINE (FND_FILE.LOG,
                         '*******Start First ConcurRent Program*******');

      LN_SQLLDR_REQ_ID :=
         XXMB_SUBMIR_REQUEST ('APPS',
                              'MY_SQL_LOADER_PROGRAM',
                              '',
                              '',
                              NULL,
                              P_VALUE1,
                              '',
                              '');

      SELECT STATUS_CODE
        INTO V_STATUS_CODE
        FROM FND_CONCURRENT_REQUESTS
       WHERE REQUEST_ID = LN_SQLLDR_REQ_ID;

      IF V_STATUS_CODE = 'E'
      THEN
         --STATUS_CODE value in FND_CONCURRENT_REQUESTS 'E' means request ended with error.
         ERRBUF := FND_MESSAGE.GET;
         RETCODE := 2;

         FND_FILE.PUT_LINE (FND_FILE.LOG, '*******SQL LOADER ERROR!*******');
      ELSE
         FND_FILE.PUT_LINE (FND_FILE.LOG, '<<<<<<>>>>>>');

         FND_FILE.PUT_LINE (FND_FILE.LOG,
                            '*******Start Manipulating data*******');

         LN_PROC_REQ_ID :=
            XXMB_SUBMIR_REQUEST ('APPS',
                                 'MY_CONCURRENT_PROGRAM',
                                 '',
                                 '',
                                 NULL,
                                 V_VALUE2,
                                 '',
                                 '');

         IF LN_PROC_REQ_ID = 0
         THEN
            ERRBUF := FND_MESSAGE.GET;
            RETCODE := 2;
         ELSE
            FND_FILE.PUT_LINE (FND_FILE.LOG, '<<<<<<>>>>>>');

            retcode := 0;
            errbuf := 'Sub-Request submitted!';
         END IF;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         FND_FILE.PUT_LINE (FND_FILE.LOG, 'ERROR:' || SQLERRM);
   END MY_PROCEDURE;
END MY_PACKAGE;