/* Formatted on 6/28/2020 11:37:06 AM (QP5 v5.287) */
CREATE TABLE apps.cust_webadi_item_upload
(
   segment1                        VARCHAR2 (240 BYTE),
   segment2                        VARCHAR2 (240 BYTE),
   segment3                        VARCHAR2 (240 BYTE),
   segment4                        VARCHAR2 (240 BYTE),
   segment5                        VARCHAR2 (240 BYTE),
   segment6                        VARCHAR2 (240 BYTE),
   segment7                        VARCHAR2 (240 BYTE),
   segment8                        VARCHAR2 (240 BYTE),
   organization_id                 NUMBER (35),
   description                     VARCHAR2 (240 BYTE),
   inventory_item_status_code      VARCHAR2 (240 BYTE),
   template_id                     VARCHAR2 (240 BYTE),
   primary_uom_code                VARCHAR2 (240 BYTE),
   tracking_quantity_ind           VARCHAR2 (240 BYTE),
   ont_pricing_qty_source          VARCHAR2 (240 BYTE),
   secondary_uom_code              VARCHAR2 (240 BYTE),
   secondary_default_ind           VARCHAR2 (240 BYTE),
   attribute_category              VARCHAR2 (240 BYTE),
   attribute1                      VARCHAR2 (240 BYTE),
   attribute2                      VARCHAR2 (240 BYTE),
   attribute3                      VARCHAR2 (240 BYTE),
   attribute4                      VARCHAR2 (240 BYTE),
   attribute5                      VARCHAR2 (240 BYTE),
   attribute6                      VARCHAR2 (240 BYTE),
   attribute7                      VARCHAR2 (240 BYTE),
   attribute8                      VARCHAR2 (240 BYTE),
   attribute9                      VARCHAR2 (240 BYTE),
   attribute10                     VARCHAR2 (240 BYTE),
   attribute11                     VARCHAR2 (240 BYTE),
   attribute12                     VARCHAR2 (240 BYTE),
   attribute13                     VARCHAR2 (240 BYTE),
   attribute14                     VARCHAR2 (240 BYTE),
   attribute15                     VARCHAR2 (240 BYTE),
   last_update_date                DATE,
   last_updated_by                 NUMBER (35),
   last_update_login               NUMBER (35),
   created_by                      NUMBER (35),
   creation_date                   DATE,
   process_flag                    NUMBER (35),
   transaction_type                VARCHAR2 (240 BYTE),
   set_process_id                  NUMBER (35),
   summary_flag                    VARCHAR2 (240 BYTE),
   enabled_flag                    VARCHAR2 (240 BYTE),
   purchasing_item_flag            VARCHAR2 (240 BYTE),
   shippable_item_flag             VARCHAR2 (240 BYTE),
   customer_order_flag             VARCHAR2 (240 BYTE),
   internal_order_flag             VARCHAR2 (240 BYTE),
   service_item_flag               VARCHAR2 (240 BYTE),
   inventory_item_flag             VARCHAR2 (240 BYTE),
   inventory_asset_flag            VARCHAR2 (240 BYTE),
   purchasing_enabled_flag         VARCHAR2 (240 BYTE),
   customer_order_enabled_flag     VARCHAR2 (240 BYTE),
   internal_order_enabled_flag     VARCHAR2 (240 BYTE),
   so_transactions_flag            VARCHAR2 (240 BYTE),
   mtl_transactions_enabled_flag   VARCHAR2 (240 BYTE),
   stock_enabled_flag              VARCHAR2 (240 BYTE),
   bom_enabled_flag                VARCHAR2 (240 BYTE),
   build_in_wip_flag               VARCHAR2 (240 BYTE),
   returnable_flag                 VARCHAR2 (240 BYTE),
   default_shipping_org            VARCHAR2 (240 BYTE),
   taxable_flag                    VARCHAR2 (240 BYTE),
   allow_item_desc_update_flag     VARCHAR2 (240 BYTE),
   inspection_required_flag        VARCHAR2 (240 BYTE),
   receipt_required_flag           VARCHAR2 (240 BYTE),
   interface_status                VARCHAR2 (240 BYTE),
   FLAG                VARCHAR2 (3 BYTE)
);

DROP TABLE APPS.CUST_WEBADI_ITEM_UPLOAD;