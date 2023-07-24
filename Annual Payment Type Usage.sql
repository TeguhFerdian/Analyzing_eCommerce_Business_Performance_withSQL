--=====Membuat Table jumlah pengguna tipe pembayaran secara all time====

SELECT payment_type, COUNT(1) 
FROM order_payments
GROUP BY 1
ORDER BY 2 DESC;


--=====Menampilkan detail informasi jumlah pengguna tipe pembayaran=====
SELECT
  payment_type,
  SUM(CASE WHEN year = 2016 THEN total ELSE 0 END) AS "2016",
  SUM(CASE WHEN year = 2017 THEN total ELSE 0 END) AS "2017",
  SUM(CASE WHEN year = 2018 THEN total ELSE 0 END) AS "2018",
  SUM(total) AS sum_payment_type_usage
FROM (
  SELECT 
  	date_part('year', od.order_purchase_timestamp) as year,
  	op.payment_type,
  	COUNT(op.payment_type) AS total
  FROM orders AS od
  JOIN order_payments AS op 
  	ON od.order_id = op.order_id
  GROUP BY 1, 2
  ) AS sub
GROUP BY 1
ORDER BY 2 DESC;