/* Formatted on 4/12/2021 12:02:16 PM (QP5 v5.354) */
SELECT DISTINCT
       --mlh.*
       --mll1.*
       --mll2.*
       --ph.*
       --pl.*
       --bsh.*
       --bsl.*
       --mph.*
       --mpl.*
       --cih.*
       --cil.*
  FROM xxdbl_master_lc_headers       mlh,
       xxdbl_master_lc_line1         mll1,
       xxdbl_master_lc_line2         mll2,
       xxdbl_proforma_headers        ph,
       xxdbl_proforma_lines          pl,
       xxdbl_bill_stat_headers       bsh,
       xxdbl_bill_stat_lines         bsl,
       xxdbl.xxdbl_manual_pi_header  mph,
       xxdbl.xxdbl_manual_pi_line    mpl,
       xxdbl_comm_inv_headers        cih,
       xxdbl_comm_inv_lines          cil
 WHERE     1 = 1
       AND ( :p_org_id IS NULL OR (mlh.org_id = :p_org_id))
       AND mlh.master_lc_header_id = mll1.master_lc_header_id(+)
       AND mlh.master_lc_header_id = mll2.master_lc_header_id(+)
       --AND mlh.internal_doc_number='lc-66046-000002'
       --AND mlh.master_lc_number in ('dpcdak810222')
       AND ( :p_pi_number IS NULL OR (mll1.pi_number = :p_pi_number))
       AND mll1.pi_number = ph.proforma_number(+)
       AND ph.proforma_header_id = pl.proforma_header_id(+)
       AND ( :p_bs_number IS NULL OR (bsh.bill_stat_number = :p_bs_number))
       AND pl.bill_stat_number = bsh.bill_stat_number(+)
       AND bsh.bill_stat_header_id = bsl.bill_stat_header_id(+)
       --AND bsh.bill_stat_status NOT IN ('CONFIRMED','CANCELLED')
       --AND bsh.bill_stat_number IN ( 'BS-66046-000002')
       AND (   :p_mpi_number IS NULL
            OR (NVL (mlh.mpi_number, ph.manual_pi_no) = :p_mpi_number))
       AND NVL (mlh.mpi_number, ph.manual_pi_no) = mph.manual_pi_number(+)
       AND mph.manual_pi_id = mpl.manual_pi_id(+)
       AND ( :p_lc_number IS NULL OR (mlh.master_lc_number = :p_lc_number))
       AND ( :p_customer_no IS NULL OR (mlh.customer_number = :p_customer_no))
       AND mlh.master_lc_number  = cih.attribute1(+)
       AND cih.comm_inv_header_id = cil.comm_inv_header_id(+);