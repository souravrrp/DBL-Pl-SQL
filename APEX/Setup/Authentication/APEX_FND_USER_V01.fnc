CREATE OR REPLACE Function APPS.apex_fnd_user_v01  (p_username   IN VARCHAR2,
                                        p_password   IN VARCHAR2)
   RETURN BOOLEAN
IS
   l_password          VARCHAR2 (4000);
   l_stored_password   VARCHAR2 (4000);
   l_expires_on        DATE;
   l_count             NUMBER;
BEGIN
   SELECT COUNT (*)
     INTO l_count
     FROM USER_INFORMATION
    WHERE UPPER (LOGIN_NAME) = UPPER (p_username);

 

 

   IF l_count != 0
   THEN
      SELECT pwd
        INTO l_stored_password
        FROM USER_INFORMATION
       WHERE UPPER (LOGIN_NAME) = UPPER (p_username);

 


      l_password := f_Password (UPPER (p_username), p_password);

 


      IF l_password = l_stored_password
      THEN
         RETURN TRUE;
      ELSE
         RETURN FALSE;
      END IF;
   END IF;
END;
/