--====Membuat Table Informasi pendapan====

CREATE TABLE total_revenue AS
  SELECT
  	date_part('year', od.order_purchase_timestamp) AS year,
  	SUM(oi.price + oi.freight_value) AS revenue
  FROM order_items AS oi
  JOIN orders AS od
  	ON oi.order_id = od.order_id
  WHERE od.order_status like 'delivered'
  GROUP BY 1
  ORDER BY 1;
  
  SELECT* FROM total_revenue
  
 --=====Membuat Table Informasi jumlah Cancel====
 
 CREATE TABLE cancel_order AS
  SELECT
  	date_part('year', order_purchase_timestamp) AS year,
  	COUNT(order_status) AS canceled
  FROM orders
  WHERE order_status like 'canceled'
  GROUP BY 1
  ORDER BY 1;
  
  SELECT* FROM cancel_order
  
  
  --====Membuat Table kategori product total tertinggi setiap tahun====
  
  CREATE TABLE top_product_category AS
  SELECT 
  	year,
  	top_category,
  	product_revenue
  FROM (
  	SELECT
  		date_part('year', shipping_limit_date) AS year,
  		pd.product_category_name AS top_category,
  		SUM(oi.price + oi.freight_value) AS product_revenue,
  		RANK() OVER (PARTITION BY date_part('year', shipping_limit_date)
  				 ORDER BY SUM(oi.price + oi.freight_value) DESC) AS ranking
  	FROM orders AS od 
  	JOIN order_items AS oi
  		ON od.order_id = oi.order_id
  	JOIN product AS pd
  		ON oi.product_id = pd.product_id
  	WHERE od.order_status like 'delivered'
  	GROUP BY 1, 2
  	ORDER BY 1
  	) AS sub
  WHERE ranking = 1;
  
   SELECT* FROM top_product_category
   
   
--======Membuat table kategori peroduct yang yang sering dicencel di setiap tahun=====

CREATE TABLE most_cancel_category AS
  SELECT 
  	year,
  	most_canceled,
  	total_canceled
  FROM (
  	SELECT
  		date_part('year', shipping_limit_date) AS year,
  		pd.product_category_name AS most_canceled,
  		COUNT(od.order_id) AS total_canceled,
  		RANK() OVER (PARTITION BY date_part('year', shipping_limit_date)
  				 ORDER BY COUNT(od.order_id) DESC) AS ranking
  	FROM orders AS od 
  	JOIN order_items AS oi
  		ON od.order_id = oi.order_id
  	JOIN product AS pd
  		ON oi.product_id = pd.product_id
  	WHERE od.order_status like 'canceled'
  	GROUP BY 1, 2
  	ORDER BY 1
  	) AS sub
  WHERE ranking = 1;
  
    SELECT* FROM most_cancel_category
	
--===Menghapus anomali data tahun===

DELETE FROM top_product_category WHERE year = 2020;
DELETE FROM most_cancel_category WHERE year = 2020;

--===Menampilkan table yang di butuhkan===

SELECT 
  tr.year,
  tr.revenue AS total_revenue,
  tpc.top_category AS top_product,
  tpc.product_revenue AS total_revenue_top_product,
  co.canceled total_canceled,
  mcc.most_canceled top_cancel_product,
  mcc.total_canceled total_top_cancel_product
FROM total_revenue AS tr
JOIN top_product_category AS tpc
  ON tr.year = tpc.year
JOIN cancel_order AS co
  ON tpc.year = co.year
JOIN most_cancel_category AS mcc
  ON co.year = mcc.year
GROUP BY 1, 2, 3, 4, 5, 6, 7;