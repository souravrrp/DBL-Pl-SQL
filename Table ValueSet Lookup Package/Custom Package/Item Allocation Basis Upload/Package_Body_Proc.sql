/* Formatted on 2/14/2021 5:09:43 PM (QP5 v5.287) */
CREATE OR REPLACE PACKAGE BODY APPS.xxdbl_cer_item_upld_pkg
IS
   -- CREATED BY : SOURAV PAUL
   -- CREATION DATE : 26-AUG-2020
   -- LAST UPDATE DATE :27-AUG-2020
   -- PURPOSE : Update GL Item Allocation Basis
   FUNCTION check_error_log_to_import_data
      RETURN NUMBER
   IS
      l_return_status   VARCHAR2 (1);
      l_sl_no           NUMBER;

      CURSOR cur_stg
      IS
         SELECT '251' organization_code,
                msib.segment1 item_code,
                mst.alloc_code,
                'Fixed%' basis_type,
                'IND' cost_analysis_code,
                NULL status,
                NULL status_id,
                NULL set_proc_id
           FROM mtl_system_items_b msib,
                gl_aloc_mst mst,
                apps.mtl_item_categories_v cat
          WHERE     msib.organization_id = 152
                AND msib.inventory_item_id = cat.inventory_item_id
                AND msib.organization_id = cat.organization_id
                AND cat.segment2 = 'FINISH GOODS'
                --AND msib.segment1 LIKE 'FG%'
                AND mst.legal_entity_id = 23282
                AND cat.category_set_id = 1
                AND mst.alloc_code LIKE '%FG%'
                AND mst.alloc_code NOT LIKE '%FT%'
                --AND msib.segment1 = 'FT-GP6060-044P'
                AND NOT EXISTS
                       (SELECT 1
                          FROM gl_aloc_bas x
                         WHERE     x.organization_id = 152
                               AND msib.inventory_item_id =
                                      x.inventory_item_id)
                AND msib.segment1 NOT IN
                       (SELECT item_code
                          FROM xxdbl.xxdbl_item_aloc_basis_stg stg
                         WHERE stg.organization_code = 251)
         UNION
         SELECT '251' organization_code,
                msib.segment1 item_code,
                mst.alloc_code,
                'Fixed%' basis_type,
                'IND' cost_analysis_code,
                NULL status,
                NULL status_id,
                NULL set_proc_id
           FROM mtl_system_items_b msib,
                gl_aloc_mst mst,
                apps.mtl_item_categories_v cat
          WHERE     msib.organization_id = 152
                --AND msib.segment1 LIKE 'FT%'
                AND cat.segment2 = 'SEMI FINISH GOODS'
                AND cat.category_set_id = 1
                AND msib.inventory_item_id = cat.inventory_item_id
                AND msib.organization_id = cat.organization_id
                AND mst.legal_entity_id = 23282
                AND mst.alloc_code LIKE '%FT%'
                --AND msib.segment1 = 'FT-GP6060-044P'
                AND NOT EXISTS
                       (SELECT 1
                          FROM gl_aloc_bas x
                         WHERE     x.organization_id = 152
                               AND msib.inventory_item_id =
                                      x.inventory_item_id)
                AND msib.segment1 NOT IN
                       (SELECT item_code
                          FROM xxdbl.xxdbl_item_aloc_basis_stg stg
                         WHERE stg.organization_code = 251);
   BEGIN
      FOR ln_cur_stg IN cur_stg
      LOOP
         BEGIN
            l_return_status := NULL;
            --SELECT ra_customer_trx_lines_s.CURRVAL INTO vl_interface_line_id FROM DUAL;
            l_sl_no := xxdbl.xxdbl_itm_aloc_bs_s.NEXTVAL;


            INSERT INTO xxdbl.xxdbl_item_aloc_basis_stg (organization_code,
                                                         item_code,
                                                         alloc_code,
                                                         basis_type,
                                                         cost_analysis_code,
                                                         set_proc_id,
                                                         sl_no,
                                                         creation_date,
                                                         created_by)
                 VALUES (ln_cur_stg.organization_code,
                         ln_cur_stg.item_code,
                         ln_cur_stg.alloc_code,
                         ln_cur_stg.basis_type,
                         ln_cur_stg.cost_analysis_code,
                         ln_cur_stg.set_proc_id,
                         l_sl_no,
                         SYSDATE,
                         p_user_id);

            COMMIT;

            IF    l_return_status = fnd_api.g_ret_sts_error
               OR l_return_status = fnd_api.g_ret_sts_unexp_error
            THEN
               DBMS_OUTPUT.put_line ('unexpected errors found!');
               fnd_file.put_line (
                  fnd_file.LOG,
                  '--------------Unexpected errors found!--------------------');
            END IF;
         EXCEPTION
            WHEN OTHERS
            THEN
               fnd_file.put_line (
                  fnd_file.LOG,
                     'Error while inserting records into Interface lines table.'
                  || SQLERRM);
         END;
      END LOOP;

      RETURN 0;
   END;

   PROCEDURE item_basis_upd (errbuf       OUT NOCOPY NUMBER,
                             retcode      OUT NOCOPY VARCHAR2)
   IS
      l_retcode     NUMBER;
      conc_status   BOOLEAN;
      l_error       VARCHAR2 (100);
   BEGIN
      fnd_file.put_line (fnd_file.LOG, 'Parameter received');


      l_retcode := check_error_log_to_import_data;

      IF l_retcode = 0
      THEN
         retcode := 'Success';
         conc_status :=
            fnd_concurrent.set_completion_status ('NORMAL', 'Completed');
         fnd_file.put_line (fnd_file.LOG, 'Status :' || l_retcode);

         BEGIN
            gl_aloc_basis_proc;
            COMMIT;
         END;
      ELSIF l_retcode = 1
      THEN
         retcode := 'Warning';
         conc_status :=
            fnd_concurrent.set_completion_status ('WARNING', 'Warning');
      ELSIF l_retcode = 2
      THEN
         retcode := 'Error';
         conc_status :=
            fnd_concurrent.set_completion_status ('ERROR', 'Error');
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         l_error := 'error while executing the procedure ' || SQLERRM;
         errbuf := l_error;
         retcode := 1;
         fnd_file.put_line (fnd_file.LOG, 'Status :' || l_retcode);
   END item_basis_upd;

   PROCEDURE gl_aloc_basis_proc
   IS
      CURSOR cur_stg
      IS
         SELECT pw.ROWID rx, pw.*
           FROM xxdbl.xxdbl_item_aloc_basis_stg pw
          WHERE 1 = 1 AND NVL (pw.status, 'X') NOT IN ('I', 'E');

      l_organization_code    VARCHAR2 (10 BYTE);
      l_item_code            VARCHAR2 (100 BYTE);
      l_alloc_code           VARCHAR2 (100 BYTE);
      l_basis_type           VARCHAR2 (100 BYTE);
      l_cost_analysis_code   VARCHAR2 (10 BYTE);
      l_status               VARCHAR2 (10 BYTE);
      l_status_message       VARCHAR2 (240 BYTE);
      l_error                VARCHAR2 (240 BYTE);
   BEGIN
      FOR r IN cur_stg
      LOOP
         BEGIN
            l_organization_code := r.organization_code;
            l_item_code := r.item_code;
            l_alloc_code := r.alloc_code;
            l_basis_type := r.basis_type;
            l_cost_analysis_code := r.cost_analysis_code;
            l_status := r.status;
            l_status_message := r.status_message;

            INSERT INTO gl_aloc_bas (alloc_id,
                                     line_no,
                                     alloc_method,
                                     fixed_percent,
                                     cmpntcls_id,
                                     analysis_code,
                                     whse_code,
                                     creation_date,
                                     created_by,
                                     last_update_date,
                                     last_updated_by,
                                     last_update_login,
                                     trans_cnt,
                                     text_code,
                                     delete_mark,
                                     basis_account_id,
                                     basis_type,
                                     inventory_item_id,
                                     organization_id)
                    VALUES (
                              (SELECT alloc_id
                                 FROM gl_aloc_mst
                                WHERE UPPER (alloc_code) =
                                         UPPER (l_alloc_code)),
                              (  NVL (
                                    (SELECT MAX (line_no)          --COUNT (*)
                                       FROM gl_aloc_bas
                                      WHERE alloc_id =
                                               (SELECT alloc_id
                                                  FROM gl_aloc_mst
                                                 WHERE UPPER (
                                                          alloc_code) =
                                                          UPPER (
                                                             l_alloc_code))),
                                    0)
                               + 1),
                              1,
                              0,
                              (SELECT cost_cmpntcls_id
                                 FROM cm_cmpt_mst
                                WHERE     delete_mark = 0
                                      AND usage_ind = 4
                                      AND UPPER (cost_cmpntcls_desc) =
                                             UPPER (l_alloc_code)),
                              (SELECT cost_analysis_code
                                 FROM cm_alys_mst
                                WHERE     delete_mark = 0
                                      AND cost_analysis_code =
                                             l_cost_analysis_code),
                              NULL,
                              SYSDATE,
                              1130,
                              SYSDATE,
                              1130,
                              3904211,
                              0,
                              NULL,
                              0,
                              NULL,
                              1,
                              (SELECT inventory_item_id
                                 FROM mtl_system_items_kfv
                                WHERE     concatenated_segments = l_item_code
                                      AND ROWNUM = 1),
                              (SELECT organization_id
                                 FROM mtl_parameters
                                WHERE organization_code = l_organization_code));

            UPDATE xxdbl.xxdbl_item_aloc_basis_stg pw
               SET pw.status = 'I'
             WHERE     1 = 1
                   AND pw.alloc_code = l_alloc_code
                   AND pw.organization_code = l_organization_code
                   AND pw.item_code = l_item_code
                   AND pw.status IS NULL;
         EXCEPTION
            WHEN OTHERS
            THEN
               -- ROLLBACK TO SAVEPOINT xx_item;
               l_error := SUBSTRB ('ERROR: ' || SQLERRM, 1, 4000);

               UPDATE xxdbl.xxdbl_item_aloc_basis_stg pw
                  SET pw.status = 'E', pw.status_message = l_error
                WHERE     1 = 1
                      AND pw.alloc_code = l_alloc_code
                      AND pw.organization_code = l_organization_code
                      AND pw.item_code = l_item_code
                      AND pw.status IS NULL;
         END;

         COMMIT;
      END LOOP;
   END gl_aloc_basis_proc;

   PROCEDURE recp_rout_procedure (p_formula_no    IN     VARCHAR2,
                                  x_out_message      OUT VARCHAR2)
   IS
      CURSOR rout_ass_curr (
         p_formula_no_cur   IN VARCHAR2)
      IS
           SELECT mp.organization_id AS org_id,
                  fu.user_id AS user_id,
                  ffm.formula_id AS formula_id,
                  ffm.formula_no AS form_no,
                  ffm.formula_vers AS formu_vers,
                  grb.recipe_no AS rcp_no,
                  grb.recipe_version AS rcp_vers,
                  UPPER (xfus.routing_no) AS routing_no,
                  grb.recipe_id AS rcp_id
             FROM mtl_parameters mp,
                  xxdbl.xxdbl_cer_formula_upd_stg xfus,
                  fnd_user fu,
                  fm_form_mst ffm,
                  gmd_recipes_b grb
            WHERE     mp.organization_code = xfus.owner_organization_code
                  AND fu.user_name = UPPER (xfus.owner_code)
                  AND ffm.formula_no = p_formula_no_cur
                  AND ffm.formula_id =
                         (SELECT formula_id
                            FROM fm_form_mst
                           WHERE     formula_no = xfus.formula_no
                                 AND formula_vers =
                                        (SELECT MAX (formula_vers)
                                           FROM fm_form_mst
                                          WHERE     formula_no =
                                                       xfus.formula_no
                                                AND owner_organization_id =
                                                       mp.organization_id))
                  AND grb.formula_id = ffm.formula_id
                  AND ffm.formula_status =
                         DECODE (xfus.formula_status,
                                 'Approved for General Use', 700,
                                 700)
                  AND xfus.owner_organization_code = '251'
         GROUP BY mp.organization_id,
                  fu.user_id,
                  ffm.formula_id,
                  ffm.formula_no,
                  ffm.formula_vers,
                  grb.recipe_no,
                  grb.recipe_version,
                  xfus.routing_no,
                  grb.recipe_id;

      tbl_recipe_hdr     gmd_recipe_header.recipe_tbl;
      tbl_hdr_flex       gmd_recipe_header.recipe_update_flex;
      lv_status_hdr      VARCHAR2 (200);
      lv_msg_cnt         NUMBER;
      lv_msg_data        VARCHAR2 (3999);
      lv_msg_index_out   VARCHAR2 (100);
      l_verify_flag      VARCHAR2 (3) := 'Y';
      l_msg_cnt          NUMBER;
      l_msg_lst          VARCHAR2 (3999);
      l_ret_status       VARCHAR2 (200);
      l_routing_ver      NUMBER := -1;
   BEGIN
      fnd_global.apps_initialize (user_id        => 1130,
                                  resp_id        => 22882,
                                  resp_appl_id   => 552);

      FOR rt_asn IN rout_ass_curr (p_formula_no)
      LOOP
         DBMS_OUTPUT.put_line ('Routing Number : ' || rt_asn.routing_no);

         BEGIN
            SELECT NVL (MAX (routing_vers), -1)
              INTO l_routing_ver
              FROM gmd_routings_b
             WHERE routing_no = rt_asn.routing_no AND routing_status = 700;

            DBMS_OUTPUT.put_line (
                  'Routing Version : '
               || rt_asn.routing_no
               || '  exist '
               || l_routing_ver);
         EXCEPTION
            WHEN OTHERS
            THEN
               l_routing_ver := -1;
               x_out_message :=
                     'Routing Number : '
                  || rt_asn.routing_no
                  || ' doesnot exist';
               fnd_file.put_line (
                  fnd_file.LOG,
                     'Routing Number : '
                  || rt_asn.routing_no
                  || ' doesnot exist');
               DBMS_OUTPUT.put_line (
                     'Routing Number : '
                  || rt_asn.routing_no
                  || ' doesnot exist');
         END;

         IF l_routing_ver > 0
         THEN
            tbl_recipe_hdr (1).recipe_id := rt_asn.rcp_id;
            tbl_recipe_hdr (1).recipe_no := rt_asn.rcp_no;
            tbl_recipe_hdr (1).recipe_version := rt_asn.rcp_vers;
            tbl_recipe_hdr (1).routing_vers := l_routing_ver;
            tbl_recipe_hdr (1).routing_no := rt_asn.routing_no;
            tbl_recipe_hdr (1).owner_organization_id := rt_asn.org_id;
            tbl_recipe_hdr (1).owner_id := rt_asn.user_id;
            tbl_hdr_flex (1).attribute_category := NULL;
            tbl_hdr_flex (1).attribute1 := NULL;
            tbl_hdr_flex (1).attribute2 := NULL;
            tbl_hdr_flex (1).attribute3 := NULL;
            tbl_hdr_flex (1).attribute4 := NULL;
            tbl_hdr_flex (1).attribute5 := NULL;
            tbl_hdr_flex (1).attribute6 := NULL;
            tbl_hdr_flex (1).attribute7 := NULL;
            tbl_hdr_flex (1).attribute8 := NULL;
            tbl_hdr_flex (1).attribute9 := NULL;
            tbl_hdr_flex (1).attribute10 := NULL;
            tbl_hdr_flex (1).attribute11 := NULL;
            tbl_hdr_flex (1).attribute12 := NULL;
            tbl_hdr_flex (1).attribute13 := NULL;
            tbl_hdr_flex (1).attribute14 := NULL;
            tbl_hdr_flex (1).attribute15 := NULL;
            tbl_hdr_flex (1).attribute16 := NULL;
            tbl_hdr_flex (1).attribute17 := NULL;
            tbl_hdr_flex (1).attribute18 := NULL;
            tbl_hdr_flex (1).attribute19 := NULL;
            tbl_hdr_flex (1).attribute20 := NULL;
            tbl_hdr_flex (1).attribute21 := NULL;
            tbl_hdr_flex (1).attribute22 := NULL;
            tbl_hdr_flex (1).attribute23 := NULL;
            tbl_hdr_flex (1).attribute24 := NULL;
            tbl_hdr_flex (1).attribute25 := NULL;
            tbl_hdr_flex (1).attribute26 := NULL;
            tbl_hdr_flex (1).attribute27 := NULL;
            tbl_hdr_flex (1).attribute28 := NULL;
            tbl_hdr_flex (1).attribute29 := NULL;
            tbl_hdr_flex (1).attribute30 := NULL;
            --dbms_output.put_line('UPDATE_RECIPE_HEADER api starts here ');
            gmd_recipe_header.update_recipe_header (
               p_api_version          => 2.0,
               p_init_msg_list        => fnd_api.g_false,
               p_commit               => fnd_api.g_true,
               p_called_from_forms    => 'NO',
               p_recipe_header_tbl    => tbl_recipe_hdr,
               x_return_status        => lv_status_hdr,
               x_msg_count            => lv_msg_cnt,
               x_msg_data             => lv_msg_data,
               p_recipe_update_flex   => tbl_hdr_flex);

            --dbms_output.put_line('UPDATE_RECIPE_HEADER completed with status code : '||lv_status_hdr||' for recipe number : '||RT_ASN.RCP_NO);
            IF NVL (lv_status_hdr, 'E') <> 'S'
            THEN
               DBMS_OUTPUT.put_line (
                  'After Calling gmd_recipe_header.update_recipe_header Error');
               l_verify_flag := 'N';

               FOR cr_err_rec IN 1 .. lv_msg_cnt
               LOOP
                  fnd_msg_pub.get (p_msg_index       => cr_err_rec,
                                   p_encoded         => fnd_api.g_false,
                                   p_data            => lv_msg_data,
                                   p_msg_index_out   => lv_msg_index_out);
                  fnd_file.put_line (
                     fnd_file.LOG,
                        CHR (10)
                     || lv_status_hdr
                     || '- Routing assignment fails: '
                     || lv_msg_data
                     || '-'
                     || lv_msg_index_out);
                  DBMS_OUTPUT.put_line (
                        CHR (10)
                     || lv_status_hdr
                     || '- Routing assignment fails: '
                     || lv_msg_data
                     || '-'
                     || lv_msg_index_out);

                  IF x_out_message IS NULL
                  THEN
                     x_out_message :=
                           lv_status_hdr
                        || '- Routing assignment fails: '
                        || lv_msg_data
                        || '-'
                        || lv_msg_index_out;
                  ELSE
                     x_out_message :=
                           x_out_message
                        || CHR (10)
                        || lv_status_hdr
                        || '- Routing assignment fails: '
                        || lv_msg_data
                        || '-'
                        || lv_msg_index_out;
                  END IF;
               /*    dbms_output.put_line (lv_status_hdr
                                     || '- Routing assignment fails: '
                                     || lv_msg_data
                                     || '-'
                                     || lv_msg_index_out
                                    );
                   */
               END LOOP;
            ELSE
               DBMS_OUTPUT.put_line ('Else Part');
               gmd_status_pub.modify_status (
                  p_api_version      => 1.0,
                  p_init_msg_list    => TRUE,
                  p_entity_name      => 'Recipe',
                  p_entity_id        => rt_asn.rcp_id             -- Recipe ID
                                                     ,
                  p_entity_no        => NULL                      -- Recipe_no
                                            ,
                  p_entity_version   => NULL                    -- Recipe_vers
                                            ,
                  p_to_status        => '700'              -- Change To status
                                             ,
                  p_ignore_flag      => FALSE,
                  x_message_count    => l_msg_cnt,
                  x_message_list     => l_msg_lst,
                  x_return_status    => l_ret_status);

               IF NVL (l_ret_status, 'E') = 'S'
               THEN
                  DBMS_OUTPUT.put_line (
                     'gmd_status_pub.modify_status: Success');
               --dbms_output.put_line('Recipe status 700 updation competes with status code : '||l_ret_status||' for recipe number : '||RT_ASN.RCP_NO);
               ELSE
                  IF x_out_message IS NULL
                  THEN
                     x_out_message := 'gmd_status_pub.modify_status: Error';
                  ELSE
                     x_out_message :=
                           x_out_message
                        || CHR (10)
                        || 'gmd_status_pub.modify_status: Error';
                  END IF;

                  DBMS_OUTPUT.put_line (
                     'gmd_status_pub.modify_status: Error');
               END IF;
            END IF;
         END IF;
      END LOOP;
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.put_line ('Error in XXDBL_RECP_ROUT_THREAD_ASSIGN');
   END recp_rout_procedure;

   PROCEDURE formula_upload_prc (errbuf              OUT VARCHAR2,
                                 retcode             OUT NUMBER,
                                 p_batch_number   IN     NUMBER)
   IS
      xxdbl_fml_tabtype         gmd_formula_pub.formula_insert_hdr_tbl_type;
      owner_id                  NUMBER;

      CURSOR c1_main
      IS
         SELECT DISTINCT formula_no
           FROM xxdbl.xxdbl_cer_formula_upd_stg
          WHERE     1 = 1
                AND NVL (verify_flag, 'N') = 'N'
                AND NVL (batch_number, -1) =
                       NVL (p_batch_number, NVL (batch_number, -1));

      CURSOR c1 (
         p_formula_no   IN VARCHAR2)
      IS
         SELECT cfus.formula_no,
                cfus.formula_vers,
                cfus.formula_desc1,
                cfus.formula_class,
                NVL (cfus.inactive_ind, 0) inactive_ind,
                ood.organization_id,
                DECODE (cfus.formula_type, 'Yes', 1, 0) formula_type,
                DECODE (cfus.formula_status,
                        'Approved for General Use', 700,
                        700)
                   formula_status,
                cfus.owner_code,
                DECODE (UPPER (cfus.line_type),
                        'PRODUCT', 1,
                        'INGREDIENT', -1,
                        2)
                   line_type,
                cfus.line_no,
                cfus.item_no,
                cfus.qty,
                cfus.detail_uom,
                (TO_NUMBER (NVL (cfus.scrap_factor, 0)) / 100) scrap_factor,
                TO_NUMBER (DECODE (UPPER (cfus.scale_type_hdr), 'YES', 1, 0))
                   scale_type_hdr,
                TO_NUMBER (DECODE (UPPER (cfus.scale_type_hdr), 'YES', 1, 0))
                   scale_type_dtl,
                cfus.cost_alloc,
                DECODE (UPPER (cfus.by_product_type),
                        'SAMPLE', 'S',
                        'REWORK', 'R',
                        'WASTE', 'W',
                        'YIELD', 'Y')
                   by_product_type,
                DECODE (UPPER (cfus.contribute_yield_ind), 'YES', 'Y', 'N')
                   contribute_yield_ind,
                DECODE (UPPER (cfus.contribute_step_qty_ind),
                        'YES', 'Y',
                        'N')
                   contribute_step_qty_ind,
                DECODE (
                   UPPER (cfus.line_type),
                   'PRODUCT', 1,
                   DECODE (UPPER (cfus.prod_or_ingr_scale_type),
                           'PROPORTIONAL', 1,
                           'FIXED', 0,
                           'INTEGER', 2,
                           1))
                   prod_or_ingr_scale_type,
                DECODE (
                   UPPER (
                      (SUBSTR (cfus.yield_or_consumption_type,
                               1,
                               (LENGTH (cfus.yield_or_consumption_type))))),
                   'AUTOMATIC', 0,
                   'MANUAL', 1,
                   'INCREMENTAL', 2,
                   'AUTOMATIC BY STEP', 3)
                   yield_or_consumption_type,
                cfus.attribute3,
                cfus.attribute1 comments,
                cfus.dtl_attribute1,
                cfus.scale_multiple,
                cfus.rounding_direction,
                cfus.scale_rounding_variance,
                NVL (cfus.phantom_type, 0) phantom_type
           FROM xxdbl.xxdbl_cer_formula_upd_stg cfus,
                org_organization_definitions ood
          WHERE     cfus.owner_organization_code = ood.organization_code
                AND cfus.formula_no = p_formula_no
                AND NVL (cfus.verify_flag, 'N') != 'Y'
                AND NVL (batch_number, -1) =
                       NVL (p_batch_number, NVL (batch_number, -1));

      CURSOR c2 (
         p_formula_no   IN VARCHAR2)
      IS
         SELECT DISTINCT formula_no, formula_vers, attribute3
           FROM xxdbl.xxdbl_cer_formula_upd_stg
          WHERE     attribute3 IS NOT NULL
                AND formula_no = p_formula_no
                AND NVL (batch_number, -1) =
                       NVL (p_batch_number, NVL (batch_number, -1));

      CURSOR c3 (
         p_formula_no   IN VARCHAR2)
      IS
         SELECT formula_no,
                formula_vers,
                line_no,
                by_product_type
           FROM xxdbl.xxdbl_cer_formula_upd_stg
          WHERE     1 = 1
                AND formula_no = p_formula_no
                AND line_type LIKE '%By%'
                AND NVL (batch_number, -1) =
                       NVL (p_batch_number, NVL (batch_number, -1));


      CURSOR c4 (
         p_formula_no   IN VARCHAR2)
      IS
           SELECT formula_no,
                  formula_vers,
                  line_no,
                  by_product_type,
                  dtl_attribute1,
                  dtl_attribute2,
                  item_no
             FROM xxdbl.xxdbl_cer_formula_upd_stg
            WHERE     1 = 1
                  AND formula_no = p_formula_no
                  AND line_type = 'INGREDIENT'
                  AND NVL (batch_number, -1) =
                         NVL (p_batch_number, NVL (batch_number, -1))
         ORDER BY line_no;


      cnt                       NUMBER;
      l_return_status           VARCHAR2 (1);
      l_msg_count               NUMBER;
      l_msg_data                VARCHAR2 (1000);
      l_out_index               NUMBER := 0;
      l_user_id                 NUMBER;
      l_responsibility_id       NUMBER;
      l_responsibility_app_id   NUMBER;
      x_routing_upd_msg         VARCHAR2 (4000) := NULL;
      l_recipe_id_count         NUMBER := 0;
   BEGIN
      l_user_id := fnd_profile.VALUE ('USER_ID');
      l_responsibility_id := fnd_profile.VALUE ('RESP_ID');
      l_responsibility_app_id := fnd_profile.VALUE ('RESP_APPL_ID');
      fnd_file.put_line (fnd_file.LOG, 'Initializing......');
      fnd_file.put_line (fnd_file.LOG, 'User Id : ' || l_user_id);
      fnd_file.put_line (fnd_file.LOG,
                         'Responsibility Id : ' || l_responsibility_id);
      fnd_file.put_line (
         fnd_file.LOG,
         'Responsibility Appl Id : ' || l_responsibility_app_id);

      fnd_global.apps_initialize (l_user_id, 22882, 552);

      FOR x1 IN c1_main
      LOOP
         BEGIN
            fnd_file.put_line (
               fnd_file.LOG,
               '---------------------------------------------------------------------------------------------------- ');
            fnd_file.put_line (fnd_file.LOG,
                               'Processing for formula: ' || x1.formula_no);
            fnd_file.put_line (
               fnd_file.LOG,
               '---------------------------------------------------------------------------------------------------- ');
            cnt := 0;
            xxdbl_fml_tabtype.delete;

            FOR i IN c1 (x1.formula_no)
            LOOP
               BEGIN
                  SELECT user_id
                    INTO owner_id
                    FROM fnd_user
                   WHERE UPPER (TRIM (user_name)) =
                            UPPER (TRIM (i.owner_code));
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     fnd_file.put_line (fnd_file.LOG, 'Invalid Owner.... ');
               END;

               DBMS_OUTPUT.put_line (
                  'Owner ID is - ' || owner_id || '-' || i.owner_code); /*NEW LINE FOR TEST*/
               fnd_file.put_line (
                  fnd_file.LOG,
                     'yield_or_consumption_type->'
                  || i.yield_or_consumption_type);
               cnt := cnt + 1;
               xxdbl_fml_tabtype (cnt).formula_no := TRIM (i.formula_no);
               xxdbl_fml_tabtype (cnt).formula_vers := i.formula_vers;
               xxdbl_fml_tabtype (cnt).formula_class := i.formula_class;
               xxdbl_fml_tabtype (cnt).formula_desc1 := i.formula_desc1;
               xxdbl_fml_tabtype (cnt).owner_id := owner_id;
               xxdbl_fml_tabtype (cnt).inactive_ind := i.inactive_ind;
               xxdbl_fml_tabtype (cnt).owner_organization_id :=
                  i.organization_id;
               xxdbl_fml_tabtype (cnt).formula_type := i.formula_type;
               xxdbl_fml_tabtype (cnt).formula_desc2 := i.comments;
               xxdbl_fml_tabtype (cnt).formula_status := i.formula_status;
               xxdbl_fml_tabtype (cnt).line_no := i.line_no;
               xxdbl_fml_tabtype (cnt).line_type := i.line_type;
               xxdbl_fml_tabtype (cnt).item_no := i.item_no;
               xxdbl_fml_tabtype (cnt).qty := i.qty;
               xxdbl_fml_tabtype (cnt).detail_uom := i.detail_uom;
               xxdbl_fml_tabtype (cnt).release_type :=
                  i.yield_or_consumption_type;
               xxdbl_fml_tabtype (cnt).scrap_factor := i.scrap_factor;
               xxdbl_fml_tabtype (cnt).scale_type_hdr := i.scale_type_hdr;
               fnd_file.put_line (fnd_file.LOG,
                                  'scale_type_hdr.....' || i.scale_type_hdr);
               xxdbl_fml_tabtype (cnt).scale_type_dtl :=
                  i.prod_or_ingr_scale_type;
               xxdbl_fml_tabtype (cnt).cost_alloc := i.cost_alloc;
               fnd_file.put_line (fnd_file.LOG,
                                  'cost_alloc....' || i.cost_alloc);
               --Added for test
               xxdbl_fml_tabtype (cnt).phantom_type := i.phantom_type;
               xxdbl_fml_tabtype (cnt).contribute_yield_ind :=
                  i.contribute_yield_ind;
               xxdbl_fml_tabtype (cnt).contribute_step_qty_ind :=
                  i.contribute_step_qty_ind;
               xxdbl_fml_tabtype (cnt).attribute_category := NULL;
               xxdbl_fml_tabtype (cnt).attribute1 := i.dtl_attribute1;
               fnd_file.put_line (fnd_file.LOG, 'attribute1');
               xxdbl_fml_tabtype (cnt).scale_multiple := i.scale_multiple;
               xxdbl_fml_tabtype (cnt).rounding_direction :=
                  i.rounding_direction;
               xxdbl_fml_tabtype (cnt).scale_rounding_variance :=
                  i.scale_rounding_variance;
            END LOOP;

            l_return_status := NULL;
            fnd_file.put_line (fnd_file.LOG, 'Starting API....');
            gmd_formula_pub.insert_formula (
               p_api_version          => 1,
               p_init_msg_list        => apps.fnd_api.g_true,
               p_commit               => apps.fnd_api.g_true,
               p_called_from_forms    => 'YES',
               x_return_status        => l_return_status,
               x_msg_count            => l_msg_count,
               x_msg_data             => l_msg_data,
               p_formula_header_tbl   => xxdbl_fml_tabtype);
            fnd_file.put_line (fnd_file.LOG, '1.Ending API....');
            fnd_file.put_line (fnd_file.LOG,
                               '1.Return status - ' || l_return_status);
            fnd_file.put_line (fnd_file.LOG,
                               '1.Message count - ' || l_msg_count);
            DBMS_OUTPUT.put_line ('Return status - ' || l_return_status);
            DBMS_OUTPUT.put_line ('Message count - ' || l_msg_count);

            IF l_return_status IN ('S', 'Q')
            THEN
               fnd_file.put_line (
                  fnd_file.LOG,
                  '---------------------------------------------------------------------------------------------------- ');
               fnd_file.put_line (
                  fnd_file.LOG,
                  '100. Success  for Formula  - ' || x1.formula_no);
               fnd_file.put_line (
                  fnd_file.LOG,
                  '---------------------------------------------------------------------------------------------------- ');
               fnd_file.put_line (fnd_file.LOG, '10a - I am here  ');

               DECLARE
                  l_formula_id_new       NUMBER := -1;
                  l_exists               NUMBER := 0;
                  l_return_status_new    VARCHAR2 (1) := 'E';
                  x_recipe_no_new        VARCHAR2 (4000);
                  x_recipe_version_new   VARCHAR2 (4000);
               BEGIN
                  BEGIN
                     SELECT 1
                       INTO l_exists
                       FROM gmd_recipe_generation
                      WHERE organization_id = 152 AND ROWNUM = 1;
                  EXCEPTION
                     WHEN OTHERS
                     THEN
                        l_exists := 0;
                  END;

                  IF l_exists > 0
                  THEN
                     fnd_file.put_line (
                        fnd_file.LOG,
                           'Autometic Receipt generation set found '
                        || x1.formula_no);

                     BEGIN
                        SELECT formula_id
                          INTO l_formula_id_new
                          FROM fm_form_mst
                         WHERE     formula_no = x1.formula_no
                               AND owner_organization_id = 152;
                     EXCEPTION
                        WHEN OTHERS
                        THEN
                           l_formula_id_new := -1;
                     END;

                     IF l_formula_id_new > 0
                     THEN
                        fnd_file.put_line (
                           fnd_file.LOG,
                              'Newly Created Formula ID for '
                           || x1.formula_no
                           || ' is '
                           || l_formula_id_new);

                        BEGIN
                           SELECT COUNT (recipe_id)
                             INTO l_recipe_id_count
                             FROM gmd_recipes
                            WHERE     formula_id = l_formula_id_new
                                  AND owner_organization_id = 152;
                        EXCEPTION
                           WHEN OTHERS
                           THEN
                              l_recipe_id_count := 0;
                        END;

                        IF l_recipe_id_count = 0
                        THEN
                           gmd_recipe_generate.recipe_generate (
                              152,
                              l_formula_id_new,
                              l_return_status_new,
                              x_recipe_no_new,
                              x_recipe_version_new,
                              FALSE);
                        ELSE
                           fnd_file.put_line (
                              fnd_file.LOG,
                                 'Recipes Exists for the given Formula'
                              || x1.formula_no
                              || ' is '
                              || l_formula_id_new);
                        END IF;
                     ELSE
                        fnd_file.put_line (
                           fnd_file.LOG,
                              'Newly Created Formula ID not found for '
                           || x1.formula_no
                           || ' is '
                           || l_formula_id_new);
                        l_return_status_new := 'E';
                     END IF;
                  ELSE
                     fnd_file.put_line (
                        fnd_file.LOG,
                           'Autometic Receipt generation set not found '
                        || x1.formula_no);
                     l_return_status_new := 'S';
                  END IF;

                  IF l_return_status NOT IN ('S', 'Q')
                  THEN
                     fnd_file.put_line (
                        fnd_file.LOG,
                           'A recipe not created through the use of the configuration rules '
                        || x1.formula_no);

                     UPDATE xxdbl.xxdbl_cer_formula_upd_stg
                        SET error_msg =
                               'A recipe not created through the use of the configuration rules.'
                      WHERE     formula_no = x1.formula_no
                            AND NVL (batch_number, -1) =
                                   NVL (p_batch_number,
                                        NVL (batch_number, -1));
                  ELSE
                     UPDATE xxdbl.xxdbl_cer_formula_upd_stg
                        SET verify_flag = 'Y', error_msg = NULL
                      WHERE     formula_no = x1.formula_no
                            AND NVL (batch_number, -1) =
                                   NVL (p_batch_number,
                                        NVL (batch_number, -1));

                     fnd_file.put_line (fnd_file.LOG, '10b - I am here  ');
                     xxdbl_recp_rout_thread_assign (x1.formula_no,
                                                    x_routing_upd_msg);

                     DECLARE
                        l_recipe_no            VARCHAR2 (4000) := x1.formula_no;
                        l_recipe_version_new   VARCHAR2 (4000)
                           := NVL (x_recipe_version_new, 1);
                     --'ET01160-20716';
                     BEGIN
                        fnd_global.apps_initialize (l_user_id, 22882, 552);

                        DELETE gmd_recipe_step_materials
                         WHERE (recipe_id, formulaline_id, routingstep_id) IN
                                  (SELECT grstm.recipe_id,
                                          grstm.formulaline_id,
                                          grstm.routingstep_id
                                     FROM gmd_recipes gr,
                                          gmd_recipe_step_materials grstm
                                    WHERE     gr.recipe_id = grstm.recipe_id
                                          AND gr.owner_organization_id = 152
                                          AND gr.recipe_no =
                                                 NVL (l_recipe_no,
                                                      gr.recipe_no));

                        INSERT INTO gmd_recipe_step_materials
                           SELECT rcp.recipe_id,
                                  fmd.formulaline_id,
                                  frd.routingstep_id,
                                  NULL,
                                  SYSDATE,
                                  fnd_global.user_id,
                                  fnd_global.user_id,
                                  SYSDATE,
                                  fnd_global.login_id,
                                  NULL,
                                  NULL,
                                  NULL,
                                  NULL,
                                  NULL,
                                  NULL,
                                  NULL,
                                  NULL,
                                  NULL,
                                  NULL,
                                  NULL,
                                  NULL,
                                  NULL,
                                  NULL,
                                  NULL,
                                  NULL,
                                  NULL,
                                  NULL,
                                  NULL,
                                  NULL,
                                  NULL,
                                  NULL,
                                  NULL,
                                  NULL,
                                  NULL,
                                  NULL,
                                  NULL,
                                  NULL,
                                  NULL,
                                  NULL,
                                  NULL,
                                  NULL,
                                  NULL,
                                  NULL
                             FROM gmd_recipes rcp,
                                  fm_form_mst mst,
                                  fm_rout_hdr rt,
                                  fm_matl_dtl fmd,
                                  fm_rout_dtl frd
                            WHERE     rcp.formula_id = mst.formula_id
                                  AND mst.formula_id = fmd.formula_id
                                  AND fmd.line_type = -1
                                  AND fmd.line_no = 1
                                  AND rcp.owner_organization_id = 152
                                  AND rcp.routing_id = rt.routing_id
                                  AND rt.owner_organization_id = 152
                                  AND rt.routing_id = frd.routing_id
                                  AND frd.routingstep_no = '10'
                                  AND mst.formula_class = 'ST'
                                  AND mst.owner_organization_id = 152
                                  AND rcp.recipe_no =
                                         NVL (l_recipe_no, rcp.recipe_no)
                                  AND rcp.recipe_id NOT IN
                                         (SELECT recipe_id
                                            FROM gmd_recipe_step_materials)
                           UNION ALL
                           SELECT rcp.recipe_id,
                                  fmd.formulaline_id,
                                  frd.routingstep_id,
                                  NULL,
                                  SYSDATE,
                                  fnd_global.user_id,
                                  fnd_global.user_id,
                                  SYSDATE,
                                  fnd_global.login_id,
                                  NULL,
                                  NULL,
                                  NULL,
                                  NULL,
                                  NULL,
                                  NULL,
                                  NULL,
                                  NULL,
                                  NULL,
                                  NULL,
                                  NULL,
                                  NULL,
                                  NULL,
                                  NULL,
                                  NULL,
                                  NULL,
                                  NULL,
                                  NULL,
                                  NULL,
                                  NULL,
                                  NULL,
                                  NULL,
                                  NULL,
                                  NULL,
                                  NULL,
                                  NULL,
                                  NULL,
                                  NULL,
                                  NULL,
                                  NULL,
                                  NULL,
                                  NULL,
                                  NULL,
                                  NULL
                             FROM gmd_recipes rcp,
                                  fm_form_mst mst,
                                  fm_rout_hdr rt,
                                  fm_matl_dtl fmd,
                                  fm_rout_dtl frd
                            WHERE     rcp.formula_id = mst.formula_id
                                  AND mst.formula_id = fmd.formula_id
                                  AND fmd.line_type = -1
                                  AND fmd.line_no = 1
                                  AND rcp.owner_organization_id = 152
                                  AND rcp.routing_id = rt.routing_id
                                  AND rt.owner_organization_id = 152
                                  AND rt.routing_id = frd.routing_id
                                  AND frd.routingstep_no = '20'
                                  AND mst.formula_class IN ('FD', 'YD')
                                  AND mst.owner_organization_id = 152
                                  AND rcp.recipe_no =
                                         NVL (l_recipe_no, rcp.recipe_no)
                                  AND rcp.recipe_id NOT IN
                                         (SELECT recipe_id
                                            FROM gmd_recipe_step_materials);
                     END;

                     IF x_routing_upd_msg IS NOT NULL
                     THEN
                        fnd_file.put_line (
                           fnd_file.LOG,
                              'Receipe Updation for Routing is failed:   '
                           || x_routing_upd_msg);
                        DBMS_OUTPUT.put_line (
                              'Receipe Updation for Routing is failed:   '
                           || x_routing_upd_msg);
                     END IF;

                     FOR x IN c2 (x1.formula_no)
                     LOOP
                        fnd_file.put_line (fnd_file.LOG, '11a - I am here  ');

                        UPDATE fm_form_mst
                           SET attribute1 = x.attribute3,
                               attribute_category = 'Net Weight'
                         WHERE     formula_no = x.formula_no
                               AND formula_vers = x.formula_vers;

                        fnd_file.put_line (fnd_file.LOG, '11b - I am here  ');
                     END LOOP;

                     FOR y IN c3 (x1.formula_no)
                     LOOP
                        fnd_file.put_line (fnd_file.LOG, '12a - I am here  ');

                        UPDATE fm_matl_dtl
                           SET by_product_type =
                                  DECODE (y.by_product_type,
                                          'Sample', 'S',
                                          'Rework', 'R',
                                          'Waste', 'W',
                                          'Yield', 'Y')
                         WHERE     formula_id =
                                      (SELECT formula_id
                                         FROM fm_form_mst
                                        WHERE     formula_no = y.formula_no
                                              AND formula_vers =
                                                     y.formula_vers)
                               AND line_no = y.line_no
                               AND line_type = 2;

                        fnd_file.put_line (fnd_file.LOG, '12b - I am here  ');
                     END LOOP;

                     fnd_file.put_line (
                        fnd_file.LOG,
                        '12c - I am here  x1.formula_no:' || x1.formula_no);

                     FOR z IN c4 (x1.formula_no)
                     LOOP
                        fnd_file.put_line (
                           fnd_file.LOG,
                              'z.formula_no:'
                           || z.formula_no
                           || '    z.formula_vers:'
                           || z.formula_vers
                           || '  z.line_no:'
                           || z.line_no
                           || '   z.dtl_attribute2:'
                           || z.dtl_attribute2);

                        UPDATE fm_matl_dtl
                           SET attribute1 =
                                  (SELECT b.attribute1
                                     FROM fm_form_mst a, fm_matl_dtl b
                                    WHERE     a.formula_id = b.formula_id
                                          AND a.formula_no = z.dtl_attribute2
                                          AND a.formula_vers = z.formula_vers
                                          AND b.line_no = z.line_no
                                          AND b.line_type = -1)
                         WHERE     formula_id =
                                      (SELECT formula_id
                                         FROM fm_form_mst
                                        WHERE     formula_no = z.formula_no
                                              AND formula_vers =
                                                     z.formula_vers)
                               AND line_no = z.line_no
                               AND line_type = -1;

                        fnd_file.put_line (
                           fnd_file.LOG,
                              'ITEM_NO:'
                           || z.item_no
                           || '      Count:'
                           || SQL%ROWCOUNT);
                        COMMIT;
                     END LOOP;

                     FOR rec
                        IN (SELECT line_no,
                                   formula_no,
                                   formula_vers,
                                   scale_rounding_variance
                              FROM xxdbl.xxdbl_cer_formula_upd_stg
                             WHERE     line_type = 'INGREDIENT'
                                   AND scale_rounding_variance IS NOT NULL
                                   AND NVL (batch_number, -1) =
                                          NVL (p_batch_number,
                                               NVL (batch_number, -1)))
                     LOOP
                        UPDATE fm_matl_dtl
                           SET scale_rounding_variance =
                                  rec.scale_rounding_variance
                         WHERE     formula_id =
                                      (SELECT formula_id
                                         FROM fm_form_mst ffm
                                        WHERE     ffm.formula_no =
                                                     rec.formula_no
                                              AND ffm.formula_vers =
                                                     rec.formula_vers)
                               AND line_no = rec.line_no;

                        COMMIT;
                     END LOOP;
                  END IF;
               END;
            ELSE
               fnd_file.put_line (
                  fnd_file.LOG,
                  '---------------------------------------------------------------------------------------------------- ');
               fnd_file.put_line (
                  fnd_file.LOG,
                  '100. Error  for Formula  - ' || x1.formula_no);
               fnd_file.put_line (
                  fnd_file.LOG,
                  '---------------------------------------------------------------------------------------------------- ');

               FOR j IN 1 .. l_msg_count
               LOOP
                  apps.fnd_msg_pub.get (p_msg_index       => j,
                                        p_encoded         => 'F',
                                        p_data            => l_msg_data,
                                        p_msg_index_out   => l_out_index);
                  fnd_file.put_line (
                     fnd_file.LOG,
                     '(' || j || ')' || ' -  Message Text ' || l_msg_data);
                  DBMS_OUTPUT.put_line ('Message data - ' || l_msg_data);
               END LOOP;

               fnd_file.put_line (fnd_file.LOG, '14a - I am here  ');

               UPDATE xxdbl.xxdbl_cer_formula_upd_stg
                  SET error_msg = l_msg_data
                WHERE     formula_no = x1.formula_no
                      AND NVL (batch_number, -1) =
                             NVL (p_batch_number, NVL (batch_number, -1));


               fnd_file.put_line (fnd_file.LOG, '15 - I am here  ');
            END IF;

            COMMIT;
         EXCEPTION
            WHEN OTHERS
            THEN
               fnd_file.put_line (fnd_file.LOG, '16 - I am here  ');
               fnd_file.put_line (fnd_file.LOG,
                                  'Error for Formula  - ' || x1.formula_no);
         END;
      END LOOP;

      fnd_file.put_line (fnd_file.LOG, '17 - I am here  ');
      COMMIT;
   END formula_upload_prc;

   PROCEDURE xxdbl_formula_insert (
      p_record_type                 IN VARCHAR2 DEFAULT NULL,
      p_formula_no                  IN VARCHAR2 DEFAULT NULL,
      p_formula_vers                IN NUMBER DEFAULT NULL,
      p_formula_type                IN VARCHAR2 DEFAULT NULL,
      p_formula_desc1               IN VARCHAR2 DEFAULT NULL,
      p_formula_desc2               IN VARCHAR2 DEFAULT NULL,
      p_formula_class               IN VARCHAR2 DEFAULT NULL,
      p_fmcontrol_class             IN VARCHAR2 DEFAULT NULL,
      p_inactive_ind                IN NUMBER DEFAULT NULL,
      p_owner_organization_code     IN VARCHAR2 DEFAULT NULL,
      p_total_input_qty             IN NUMBER DEFAULT NULL,
      p_total_output_qty            IN NUMBER DEFAULT NULL,
      p_yield_uom                   IN VARCHAR2 DEFAULT NULL,
      p_formula_status              IN VARCHAR2 DEFAULT NULL,
      p_owner_code                  IN VARCHAR2 DEFAULT NULL,
      p_formula_id                  IN NUMBER DEFAULT NULL,
      p_formulaline_id              IN NUMBER DEFAULT NULL,
      p_line_type                   IN VARCHAR2 DEFAULT NULL,
      p_line_no                     IN NUMBER DEFAULT NULL,
      p_item_no                     IN VARCHAR2 DEFAULT NULL,
      p_inventory_item_id           IN NUMBER DEFAULT NULL,
      p_revision                    IN VARCHAR2 DEFAULT NULL,
      p_qty                         IN NUMBER DEFAULT NULL,
      p_detail_uom                  IN VARCHAR2 DEFAULT NULL,
      p_master_formula_id           IN NUMBER DEFAULT NULL,
      p_release_type                IN NUMBER DEFAULT NULL,
      p_scrap_factor                IN VARCHAR2 DEFAULT NULL,
      p_scale_type_hdr              IN VARCHAR2 DEFAULT NULL,
      p_scale_type_dtl              IN NUMBER DEFAULT NULL,
      p_cost_alloc                  IN NUMBER DEFAULT NULL,
      p_phantom_type                IN NUMBER DEFAULT NULL,
      p_rework_type                 IN NUMBER DEFAULT NULL,
      p_buffer_ind                  IN NUMBER DEFAULT NULL,
      p_by_product_type             IN VARCHAR2 DEFAULT NULL,
      p_ingredient_end_date         IN DATE DEFAULT NULL,
      p_attribute1                  IN VARCHAR2 DEFAULT NULL,
      p_attribute2                  IN VARCHAR2 DEFAULT NULL,
      p_attribute3                  IN VARCHAR2 DEFAULT NULL,
      p_attribute4                  IN VARCHAR2 DEFAULT NULL,
      p_attribute5                  IN VARCHAR2 DEFAULT NULL,
      p_attribute6                  IN VARCHAR2 DEFAULT NULL,
      p_attribute7                  IN VARCHAR2 DEFAULT NULL,
      p_attribute8                  IN VARCHAR2 DEFAULT NULL,
      p_attribute9                  IN VARCHAR2 DEFAULT NULL,
      p_attribute10                 IN VARCHAR2 DEFAULT NULL,
      p_attribute11                 IN VARCHAR2 DEFAULT NULL,
      p_attribute12                 IN VARCHAR2 DEFAULT NULL,
      p_attribute13                 IN VARCHAR2 DEFAULT NULL,
      p_attribute14                 IN VARCHAR2 DEFAULT NULL,
      p_attribute15                 IN VARCHAR2 DEFAULT NULL,
      p_attribute16                 IN VARCHAR2 DEFAULT NULL,
      p_attribute17                 IN VARCHAR2 DEFAULT NULL,
      p_attribute18                 IN VARCHAR2 DEFAULT NULL,
      p_attribute19                 IN VARCHAR2 DEFAULT NULL,
      p_attribute20                 IN VARCHAR2 DEFAULT NULL,
      p_attribute21                 IN VARCHAR2 DEFAULT NULL,
      p_attribute22                 IN VARCHAR2 DEFAULT NULL,
      p_attribute23                 IN VARCHAR2 DEFAULT NULL,
      p_attribute24                 IN VARCHAR2 DEFAULT NULL,
      p_attribute25                 IN VARCHAR2 DEFAULT NULL,
      p_attribute26                 IN VARCHAR2 DEFAULT NULL,
      p_attribute27                 IN VARCHAR2 DEFAULT NULL,
      p_attribute28                 IN VARCHAR2 DEFAULT NULL,
      p_attribute29                 IN VARCHAR2 DEFAULT NULL,
      p_attribute30                 IN VARCHAR2 DEFAULT NULL,
      p_dtl_attribute1              IN VARCHAR2 DEFAULT NULL,
      p_dtl_attribute2              IN VARCHAR2 DEFAULT NULL,
      p_dtl_attribute3              IN VARCHAR2 DEFAULT NULL,
      p_dtl_attribute4              IN VARCHAR2 DEFAULT NULL,
      p_dtl_attribute5              IN VARCHAR2 DEFAULT NULL,
      p_dtl_attribute6              IN VARCHAR2 DEFAULT NULL,
      p_dtl_attribute7              IN VARCHAR2 DEFAULT NULL,
      p_dtl_attribute8              IN VARCHAR2 DEFAULT NULL,
      p_dtl_attribute9              IN VARCHAR2 DEFAULT NULL,
      p_dtl_attribute10             IN VARCHAR2 DEFAULT NULL,
      p_dtl_attribute11             IN VARCHAR2 DEFAULT NULL,
      p_dtl_attribute12             IN VARCHAR2 DEFAULT NULL,
      p_dtl_attribute13             IN VARCHAR2 DEFAULT NULL,
      p_dtl_attribute14             IN VARCHAR2 DEFAULT NULL,
      p_dtl_attribute15             IN VARCHAR2 DEFAULT NULL,
      p_dtl_attribute16             IN VARCHAR2 DEFAULT NULL,
      p_dtl_attribute17             IN VARCHAR2 DEFAULT NULL,
      p_dtl_attribute18             IN VARCHAR2 DEFAULT NULL,
      p_dtl_attribute19             IN VARCHAR2 DEFAULT NULL,
      p_dtl_attribute20             IN VARCHAR2 DEFAULT NULL,
      p_dtl_attribute21             IN VARCHAR2 DEFAULT NULL,
      p_dtl_attribute22             IN VARCHAR2 DEFAULT NULL,
      p_dtl_attribute23             IN VARCHAR2 DEFAULT NULL,
      p_dtl_attribute24             IN VARCHAR2 DEFAULT NULL,
      p_dtl_attribute25             IN VARCHAR2 DEFAULT NULL,
      p_dtl_attribute26             IN VARCHAR2 DEFAULT NULL,
      p_dtl_attribute27             IN VARCHAR2 DEFAULT NULL,
      p_dtl_attribute28             IN VARCHAR2 DEFAULT NULL,
      p_dtl_attribute29             IN VARCHAR2 DEFAULT NULL,
      p_dtl_attribute30             IN VARCHAR2 DEFAULT NULL,
      p_attribute_category          IN VARCHAR2 DEFAULT NULL,
      p_dtl_attribute_category      IN VARCHAR2 DEFAULT NULL,
      p_tpformula_id                IN NUMBER DEFAULT NULL,
      p_iaformula_id                IN NUMBER DEFAULT NULL,
      p_scale_multiple              IN VARCHAR2 DEFAULT NULL,
      p_contribute_yield_ind        IN VARCHAR2 DEFAULT NULL,
      p_scale_uom                   IN VARCHAR2 DEFAULT NULL,
      p_contribute_step_qty_ind     IN VARCHAR2 DEFAULT NULL,
      p_scale_rounding_variance     IN NUMBER DEFAULT NULL,
      p_rounding_direction          IN VARCHAR2 DEFAULT NULL,
      p_text_code_hdr               IN NUMBER DEFAULT NULL,
      p_text_code_dtl               IN NUMBER DEFAULT NULL,
      --p_user_id                     IN NUMBER DEFAULT NULL,
      p_creation_date               IN DATE DEFAULT NULL,
      p_created_by                  IN NUMBER DEFAULT NULL,
      p_last_updated_by             IN NUMBER DEFAULT NULL,
      p_last_update_date            IN DATE DEFAULT NULL,
      p_last_update_login           IN NUMBER DEFAULT NULL,
      p_user_name                   IN VARCHAR2 DEFAULT NULL,
      p_delete_mark                 IN NUMBER DEFAULT NULL,
      p_auto_product_calc           IN VARCHAR2 DEFAULT NULL,
      p_prod_percent                IN NUMBER DEFAULT NULL,
      p_prod_or_ingr_scale_type     IN VARCHAR2 DEFAULT NULL,
      p_yield_or_consumption_type   IN VARCHAR2 DEFAULT NULL,
      p_verify_flag                 IN VARCHAR2 DEFAULT NULL,
      p_error_msg                   IN VARCHAR2 DEFAULT NULL,
      p_routing_no                  IN VARCHAR2 DEFAULT NULL,
      p_material_assignment_step    IN VARCHAR2 DEFAULT NULL,
      p_operation_no                IN NUMBER DEFAULT NULL,
      p_at                          IN VARCHAR2 DEFAULT NULL,
      p_batch_number                IN NUMBER DEFAULT NULL)
   AS
      l_count            NUMBER;
      t_primary_uom      VARCHAR2 (250);
      l_char             VARCHAR2 (250);
      l_message          VARCHAR2 (250);
      e_validation       EXCEPTION;
      l_error            BOOLEAN := FALSE;
      l_routing_no_str   VARCHAR2 (4000) := NULL;
      l_item_no_str      VARCHAR2 (4000) := NULL;
   BEGIN
      --validating Formula_Code + version + organization_code
      IF p_formula_no IS NULL
      THEN
         l_error := TRUE;
         l_message := 'formula number cannot be null';
         RAISE e_validation;
      ELSE
         IF p_owner_organization_code IS NULL
         THEN
            l_error := TRUE;
            l_message := 'owner organization code cannot be null';
            RAISE e_validation;
         ELSE
            IF p_formula_vers IS NULL
            THEN
               l_error := TRUE;
               l_message := 'formula version cannot be null';
               RAISE e_validation;
            ELSE
               IF p_formula_desc1 IS NULL
               THEN
                  l_error := TRUE;
                  l_message :=
                     'formula description1 and formula description2 cannot be null';
                  RAISE e_validation;
               ELSE
                  SELECT COUNT (1)
                    INTO l_count
                    FROM fm_form_mst a, mtl_parameters b
                   WHERE     a.owner_organization_id = b.organization_id
                         AND a.formula_no = p_formula_no
                         AND b.organization_code = p_owner_organization_code;

                  IF l_count != 0
                  THEN
                     l_message :=
                        'formula is alreday available  ' || p_formula_no;
                     l_error := TRUE;
                     RAISE e_validation;
                  END IF;
               END IF;
            END IF;
         END IF;
      END IF;

      --Validating formula_class
      IF p_formula_class IS NULL
      THEN
         l_message := 'formula class can not be Null';
         l_error := TRUE;
         RAISE e_validation;
      ELSE
         SELECT COUNT (1)
           INTO l_count
           FROM fm_form_mst a
          WHERE a.formula_class = p_formula_class;

         IF l_count = 0
         THEN
            l_message :=
               'formula class ' || p_formula_class || 'is not available  ';
            l_error := TRUE;
            RAISE e_validation;
         END IF;
      END IF;

      -- validating item_no
      IF p_item_no IS NULL
      THEN
         l_message := 'item no can not be Null';
         l_error := TRUE;
         RAISE e_validation;
      ELSE
         SELECT COUNT (1)
           INTO l_count
           FROM mtl_system_items_b a
          WHERE a.segment1 = p_item_no;

         IF l_count = 0
         THEN
            l_message := 'item no ' || p_item_no || 'is not available  ';
            l_error := TRUE;
            RAISE e_validation;
         END IF;
      END IF;

      -- validating owner_code
      IF p_owner_code IS NULL
      THEN
         l_message := 'owner code can not be Null';
         l_error := TRUE;
         RAISE e_validation;
      ELSE
         SELECT COUNT (1)
           INTO l_count
           FROM fnd_user a
          WHERE a.user_name = p_owner_code;

         IF l_count = 0
         THEN
            l_message := 'owner code ' || p_owner_code || 'is not available  ';
            l_error := TRUE;
            RAISE e_validation;
         END IF;
      END IF;

      -- Validating UOM
      IF p_detail_uom IS NOT NULL
      THEN
         SELECT COUNT (1)
           INTO l_count
           FROM mtl_units_of_measure_vl
          WHERE uom_code = p_detail_uom;

         IF l_count = 0
         THEN
            l_message := 'UOM unit not found for Value  ' || p_detail_uom;
            l_error := TRUE;
            RAISE e_validation;
         END IF;
      ELSE
         l_message := 'UOM cannot be null';
         l_error := TRUE;
         RAISE e_validation;
      END IF;

      -- Validating Routing Field is Blank or Already exists in the base system
      IF p_routing_no IS NOT NULL
      THEN
         SELECT COUNT (1)
           INTO l_count
           FROM fm_rout_hdr
          WHERE routing_no = p_routing_no AND routing_status = 700;

         IF l_count = 0
         THEN
            l_message :=
               'Routing Not Defined or not Approved ' || p_routing_no;
            l_error := TRUE;
            RAISE e_validation;
         END IF;
      ELSE
         l_message := 'Routing No cannot be Null';
         l_error := TRUE;
         RAISE e_validation;
      END IF;

      -- Validating Formula No
      IF p_formula_no IS NOT NULL
      THEN
         SELECT COUNT (1)
           INTO l_count
           FROM fm_form_mst
          WHERE formula_no = p_formula_no AND formula_status = 700;

         IF l_count > 0
         THEN
            l_message := 'Formula No is Already Approved ' || p_formula_no;
            l_error := TRUE;
            RAISE e_validation;
         END IF;
      ELSE
         l_message := 'Formula No cannot be Null';
         l_error := TRUE;
         RAISE e_validation;
      END IF;

      -- Validating UOM
      IF p_yield_uom IS NOT NULL AND p_line_type = 'PRODUCT'
      THEN
         SELECT primary_uom_code
           INTO t_primary_uom
           FROM mtl_system_items
          WHERE segment1 = p_item_no AND organization_id = 150;

         IF t_primary_uom != p_yield_uom
         THEN
            l_message := 'Yield_UOM is not matching with Uom ' || p_yield_uom;
            l_error := TRUE;
            RAISE e_validation;
         END IF;
      ELSE
         IF p_yield_uom IS NULL AND p_line_type = 'PRODUCT'
         THEN
            l_message := 'Yeild_Uom cannot be Null';
            l_error := TRUE;
            RAISE e_validation;
         END IF;
      END IF;

      IF     p_routing_no IS NOT NULL
         AND p_line_type = 'PRODUCT'
         AND p_item_no IS NOT NULL
         AND p_routing_no NOT LIKE 'FD%'
         AND p_routing_no NOT LIKE 'YD%'
         AND p_routing_no NOT LIKE 'ART%'
      THEN
         SELECT SUBSTR (p_routing_no,
                        1,
                        DECODE (INSTR (p_routing_no,
                                       '-',
                                       1,
                                       1),
                                0, 1000,
                                (  INSTR (p_routing_no,
                                          '-',
                                          1,
                                          1)
                                 - 1)))
           INTO l_routing_no_str
           FROM DUAL;

         SELECT SUBSTR (p_item_no,
                        1,
                        DECODE (INSTR (p_item_no,
                                       '-',
                                       1,
                                       1),
                                0, 1000,
                                (  INSTR (p_item_no,
                                          '-',
                                          1,
                                          1)
                                 - 1)))
           INTO l_item_no_str
           FROM DUAL;

         IF l_routing_no_str != l_item_no_str
         THEN
            l_message :=
                  'Item Code and Routing Code is not matching '
               || 'Routing Code:    '
               || p_routing_no
               || '  Item Code'
               || p_item_no;
            l_error := TRUE;
            RAISE e_validation;
         END IF;
      END IF;

      IF l_error = FALSE
      THEN
         INSERT
           INTO xxdbl.xxdbl_cer_formula_upd_stg (record_type,
                                                 formula_no,
                                                 formula_vers,
                                                 formula_type,
                                                 formula_desc1,
                                                 formula_desc2,
                                                 formula_class,
                                                 fmcontrol_class,
                                                 inactive_ind,
                                                 owner_organization_code,
                                                 total_input_qty,
                                                 total_output_qty,
                                                 yield_uom,
                                                 formula_status,
                                                 owner_code,
                                                 formula_id,
                                                 formulaline_id,
                                                 line_type,
                                                 line_no,
                                                 item_no,
                                                 inventory_item_id,
                                                 revision,
                                                 qty,
                                                 detail_uom,
                                                 master_formula_id,
                                                 release_type,
                                                 scrap_factor,
                                                 scale_type_hdr,
                                                 scale_type_dtl,
                                                 cost_alloc,
                                                 phantom_type,
                                                 rework_type,
                                                 buffer_ind,
                                                 by_product_type,
                                                 ingredient_end_date,
                                                 attribute1,
                                                 attribute2,
                                                 attribute3,
                                                 attribute4,
                                                 attribute5,
                                                 attribute6,
                                                 attribute7,
                                                 attribute8,
                                                 attribute9,
                                                 attribute10,
                                                 attribute11,
                                                 attribute12,
                                                 attribute13,
                                                 attribute14,
                                                 attribute15,
                                                 attribute16,
                                                 attribute17,
                                                 attribute18,
                                                 attribute19,
                                                 attribute20,
                                                 attribute21,
                                                 attribute22,
                                                 attribute23,
                                                 attribute24,
                                                 attribute25,
                                                 attribute26,
                                                 attribute27,
                                                 attribute28,
                                                 attribute29,
                                                 attribute30,
                                                 dtl_attribute1,
                                                 dtl_attribute2,
                                                 dtl_attribute3,
                                                 dtl_attribute4,
                                                 dtl_attribute5,
                                                 dtl_attribute6,
                                                 dtl_attribute7,
                                                 dtl_attribute8,
                                                 dtl_attribute9,
                                                 dtl_attribute10,
                                                 dtl_attribute11,
                                                 dtl_attribute12,
                                                 dtl_attribute13,
                                                 dtl_attribute14,
                                                 dtl_attribute15,
                                                 dtl_attribute16,
                                                 dtl_attribute17,
                                                 dtl_attribute18,
                                                 dtl_attribute19,
                                                 dtl_attribute20,
                                                 dtl_attribute21,
                                                 dtl_attribute22,
                                                 dtl_attribute23,
                                                 dtl_attribute24,
                                                 dtl_attribute25,
                                                 dtl_attribute26,
                                                 dtl_attribute27,
                                                 dtl_attribute28,
                                                 dtl_attribute29,
                                                 dtl_attribute30,
                                                 attribute_category,
                                                 dtl_attribute_category,
                                                 tpformula_id,
                                                 iaformula_id,
                                                 scale_multiple,
                                                 contribute_yield_ind,
                                                 scale_uom,
                                                 contribute_step_qty_ind,
                                                 scale_rounding_variance,
                                                 rounding_direction,
                                                 text_code_hdr,
                                                 text_code_dtl,
                                                 user_id,
                                                 creation_date,
                                                 created_by,
                                                 last_updated_by,
                                                 last_update_date,
                                                 last_update_login,
                                                 user_name,
                                                 delete_mark,
                                                 auto_product_calc,
                                                 prod_percent,
                                                 prod_or_ingr_scale_type,
                                                 yield_or_consumption_type,
                                                 verify_flag,
                                                 error_msg,
                                                 routing_no,
                                                 material_assignment_step,
                                                 operation_no,
                                                 AT,
                                                 batch_number)
         VALUES (p_record_type,
                 p_formula_no,
                 p_formula_vers,
                 p_formula_type,
                 p_formula_desc1,
                 p_formula_desc2,
                 p_formula_class,
                 p_fmcontrol_class,
                 p_inactive_ind,
                 p_owner_organization_code,
                 p_total_input_qty,
                 p_total_output_qty,
                 p_yield_uom,
                 p_formula_status,
                 p_owner_code,
                 p_formula_id,
                 p_formulaline_id,
                 p_line_type,
                 p_line_no,
                 p_item_no,
                 p_inventory_item_id,
                 p_revision,
                 p_qty,
                 p_detail_uom,
                 p_master_formula_id,
                 p_release_type,
                 p_scrap_factor,
                 p_scale_type_hdr,
                 p_scale_type_dtl,
                 p_cost_alloc,
                 p_phantom_type,
                 p_rework_type,
                 p_buffer_ind,
                 p_by_product_type,
                 p_ingredient_end_date,
                 p_attribute1,
                 p_attribute2,
                 p_attribute3,
                 p_attribute4,
                 p_attribute5,
                 p_attribute6,
                 p_attribute7,
                 p_attribute8,
                 p_attribute9,
                 p_attribute10,
                 p_attribute11,
                 p_attribute12,
                 p_attribute13,
                 p_attribute14,
                 p_attribute15,
                 p_attribute16,
                 p_attribute17,
                 p_attribute18,
                 p_attribute19,
                 p_attribute20,
                 p_attribute21,
                 p_attribute22,
                 p_attribute23,
                 p_attribute24,
                 p_attribute25,
                 p_attribute26,
                 p_attribute27,
                 p_attribute28,
                 p_attribute29,
                 p_attribute30,
                 p_dtl_attribute1,
                 p_dtl_attribute2,
                 p_dtl_attribute3,
                 p_dtl_attribute4,
                 p_dtl_attribute5,
                 p_dtl_attribute6,
                 p_dtl_attribute7,
                 p_dtl_attribute8,
                 p_dtl_attribute9,
                 p_dtl_attribute10,
                 p_dtl_attribute11,
                 p_dtl_attribute12,
                 p_dtl_attribute13,
                 p_dtl_attribute14,
                 p_dtl_attribute15,
                 p_dtl_attribute16,
                 p_dtl_attribute17,
                 p_dtl_attribute18,
                 p_dtl_attribute19,
                 p_dtl_attribute20,
                 p_dtl_attribute21,
                 p_dtl_attribute22,
                 p_dtl_attribute23,
                 p_dtl_attribute24,
                 p_dtl_attribute25,
                 p_dtl_attribute26,
                 p_dtl_attribute27,
                 p_dtl_attribute28,
                 p_dtl_attribute29,
                 p_dtl_attribute30,
                 p_attribute_category,
                 p_dtl_attribute_category,
                 p_tpformula_id,
                 p_iaformula_id,
                 p_scale_multiple,
                 p_contribute_yield_ind,
                 p_scale_uom,
                 p_contribute_step_qty_ind,
                 p_scale_rounding_variance,
                 p_rounding_direction,
                 p_text_code_hdr,
                 p_text_code_dtl,
                 p_user_id,
                 p_creation_date,
                 p_created_by,
                 p_last_updated_by,
                 p_last_update_date,
                 p_last_update_login,
                 p_user_name,
                 p_delete_mark,
                 p_auto_product_calc,
                 p_prod_percent,
                 p_prod_or_ingr_scale_type,
                 p_yield_or_consumption_type,
                 p_verify_flag,
                 p_error_msg,
                 p_routing_no,
                 p_material_assignment_step,
                 p_operation_no,
                 p_at,
                 p_batch_number);
      END IF;
   EXCEPTION
      WHEN e_validation
      THEN
         raise_application_error (-20103, l_message);
      WHEN OTHERS
      THEN
         l_message := SUBSTRB ('Error in inserting in ' || SQLERRM, 1, 200);
         raise_application_error (-20004, l_message, TRUE);
   END;
END xxdbl_cer_item_upld_pkg;
/