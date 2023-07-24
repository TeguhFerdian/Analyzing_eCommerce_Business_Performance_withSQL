-- menampilkan rata-rata jumlah customer aktif bulanan(Mnthly active user) untuk setiap tahun

-- =====Customer aktif bulanan=======
SELECT year, FLOOR(AVG(customer_total)) as avg_MAU
FROM(
		SELECT 
				date_part('year', od.order_purchase_timestamp) AS year,
				date_part('month', od.order_purchase_timestamp)AS month,
				COUNT(DISTINCT cd.customer_unique_id) AS customer_total
		FROM orders AS od
		JOIN customers AS cd
				ON cd.customer_id = od.customer_id
		GROUP BY 1, 2 
		)AS sub
GROUP BY 1 
ORDER BY 1 ;

--=====Jumlah Customer Baru=====

SELECT year, COUNT(customer_unique_id) AS total_new_customer
FROM(
	SELECT 
			Min(date_part('year',od.order_purchase_timestamp)) AS year,
			cd.customer_unique_id
FROM orders AS od
JOIN customers AS cd
	ON cd.customer_id = od.customer_id
GROUP BY 2 
	) AS sub 
GROUP BY 1 
ORDER BY 1; 

--====Jumlah yang customer Repeat setiap tahun=====

SELECT year, count(customer_unique_id) AS total_customer_repeat
FROM (
  SELECT
  	date_part('year', od.order_purchase_timestamp) AS year,
  	cd.customer_unique_id,
  	COUNT(od.order_id) AS total_order
  FROM orders AS od
  JOIN customers AS cd
  	ON cd.customer_id = od.customer_id
  GROUP BY 1, 2
  HAVING count(2) > 1
  ) AS sub
GROUP BY 1
ORDER BY 1
;

--======Jumlah order yang di lakukan customer=======

SELECT year, ROUND(AVG(freq), 3) AS avg_freq
FROM (
  SELECT
  	date_part('year', od.order_purchase_timestamp) AS year,
  	cd.customer_unique_id,
  	COUNT(order_id) AS freq
  FROM orders AS od
  JOIN customers AS cd
  	ON cd.customer_id = od.customer_id
  GROUP BY 1, 2
  ) AS sub
GROUP BY 1
ORDER BY 1
;


--=====Gabung kita metrik=====


WITH cte_mau AS (
  SELECT year, FLOOR(AVG(customer_total)) AS avg_mau
  FROM (
  	SELECT 
  		date_part('year', od.order_purchase_timestamp) AS year,
  		date_part('month', od.order_purchase_timestamp) AS month,
  		COUNT(DISTINCT cd.customer_unique_id) AS customer_total
  	FROM orders AS od
  	JOIN customers AS cd
  		ON cd.customer_id = od.customer_id
  	GROUP BY 1, 2
  	) AS sub
  GROUP BY 1
),

cte_new_cust AS (
  SELECT year, COUNT(customer_unique_id) AS total_new_customer
  FROM (
  	SELECT
  		Min(date_part('year', od.order_purchase_timestamp)) AS year,
  		cd.customer_unique_id
  	FROM orders AS od
  	JOIN customers AS cd
  		ON cd.customer_id = od.customer_id
  	GROUP BY 2
  	) AS sub
  GROUP BY 1
),

cte_repeat_order AS (
  SELECT year, count(customer_unique_id) AS total_customer_repeat
  FROM (
  	SELECT
  		date_part('year', od.order_purchase_timestamp) AS year,
  		cd.customer_unique_id,
  		COUNT(od.order_id) AS total_order
  	FROM orders AS od
  	JOIN customers AS cd
  		ON cd.customer_id = od.customer_id
  	GROUP BY 1, 2
  	HAVING count(2) > 1
  	) AS sub
  GROUP BY 1
),

cte_frequency AS (
  SELECT year, ROUND(AVG(freq), 3) AS avg_frequency
  FROM (
  	SELECT
  		date_part('year', od.order_purchase_timestamp) AS year,
  		cd.customer_unique_id,
  		COUNT(order_id) AS freq
  	FROM orders AS od
  	JOIN customers AS cd
  		ON cd.customer_id = od.customer_id
  	GROUP BY 1, 2
  	) AS sub
  GROUP BY 1
)

SELECT
  mau.year AS year,
  avg_mau,
  total_new_customer,
  total_customer_repeat,
  avg_frequency
FROM
  cte_mau AS mau
  JOIN cte_new_cust AS nc
  	ON mau.year = nc.year
  JOIN cte_repeat_order AS ro
  	ON nc.year = ro.year
  JOIN cte_frequency AS f
  	ON ro.year = f.year
GROUP BY 1, 2, 3, 4, 5
ORDER BY 1;