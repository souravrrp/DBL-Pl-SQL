/* Formatted on 7/18/2020 3:40:56 PM (QP5 v5.287) */
CREATE OR REPLACE PACKAGE APPS.XXDBL_CUSTOM_WORKFLOW
IS
   PROCEDURE XXDBL_REQNOTIFTOBUYER (ERRBUF    OUT VARCHAR2,
                                    RETCODE   OUT VARCHAR2);

   PROCEDURE XXDBL_NOTIF_ATTACH_PROCEDURE (document_id     IN     VARCHAR2,
                                           display_type    IN     VARCHAR2,
                                           document        IN OUT BLOB,
                                           document_type   IN OUT VARCHAR2);

   p_responsibility_id   NUMBER := apps.fnd_global.resp_id;
   p_respappl_id         NUMBER := apps.fnd_global.resp_appl_id;
   p_user_id             NUMBER := apps.fnd_global.user_id;
   p_org_id              NUMBER := apps.fnd_global.org_id;
END XXDBL_CUSTOM_WORKFLOW;
/