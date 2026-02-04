CREATE OR REPLACE TABLE `rakamin-kf-analytics-486209.kimia_farma.kf_analisa` AS
SELECT
  t.transaction_id,
  t.date,
  t.branch_id,
  c.branch_name,
  c.kota,
  c.provinsi,
  c.rating AS rating_cabang,
  t.customer_name,
  t.product_id,
  p.product_name,
  p.product_category,
  t.price AS actual_price,
  t.discount_percentage,

  -- Gross profit percentage berdasarkan harga produk
  CASE
    WHEN t.price <= 50000 THEN 0.10
    WHEN t.price > 50000 AND t.price <= 100000 THEN 0.15
    WHEN t.price > 100000 AND t.price <= 300000 THEN 0.20
    WHEN t.price > 300000 AND t.price <= 500000 THEN 0.25
    ELSE 0.30
  END AS persentase_gross_laba,

  -- Nett sales after discount
  t.price * (1 - t.discount_percentage) AS nett_sales,

  -- Nett profit
  (t.price * (1 - t.discount_percentage)) *
  CASE
    WHEN t.price <= 50000 THEN 0.10
    WHEN t.price > 50000 AND t.price <= 100000 THEN 0.15
    WHEN t.price > 100000 AND t.price <= 300000 THEN 0.20
    WHEN t.price > 300000 AND t.price <= 500000 THEN 0.25
    ELSE 0.30
  END AS nett_profit,

  -- Rating transaksi
  t.rating AS rating_transaksi

FROM `rakamin-kf-analytics-486209.kimia_farma.kf_final_transaction` t
LEFT JOIN `rakamin-kf-analytics-486209.kimia_farma.kf_kantor_cabang` c
  ON t.branch_id = c.branch_id
LEFT JOIN `rakamin-kf-analytics-486209.kimia_farma.kf_product` p
  ON t.product_id = p.product_id;
