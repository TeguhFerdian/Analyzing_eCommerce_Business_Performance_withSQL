-- 1) Membuat database melalui klik kanan Databases > Create > Database.. dengan nama ecommerce_miniproject


-- 2) Membuat tabel menggunakan statement CREATE TABLE dengan mengikuti penamaan kolom di csv dan memastikan tipe datanya sesuai.

CREATE TABLE public.customers (
	customer_id varchar,
	customer_unique_id varchar,
	customer_zip_code_prefix varchar,
	customer_city varchar,
	customer_state varchar
);

CREATE TABLE public.sellers (
	seller_id varchar,
	seller_zip_code_prefix varchar,
	seller_city varchar,
	seller_state varchar
);

CREATE TABLE public.geolocation (
	geolocation_zip_code_prefix varchar,
	geolocation_lat decimal,
	geolocation_lng decimal,
	geolocation_city varchar,
	geolocation_state varchar
);

CREATE TABLE public.product(
	num INT,
	product_id VARCHAR,
	product_category_name VARCHAR,
	product_name_lenght FLOAT,
	product_description_lenght FLOAT,
	product_photos_qty FLOAT,
	product_weight_g FLOAT,
	product_length_cm FLOAT,
	product_height_cm FLOAT,
	product_width_cm FLOAT
);

CREATE TABLE public.orders (
	order_id varchar,
	customer_id varchar,
	order_status varchar,
	order_purchase_timestamp timestamp,
	order_approved_at timestamp,
	order_delivered_carrier_date timestamp,
	order_delivered_customer_date timestamp,
	order_estimated_delivery_date timestamp
);

CREATE TABLE public.order_items(
	order_id varchar,
	order_item_id int,
	product_id varchar,
	seller_id varchar,
	shipping_limit_date timestamp,
	price decimal,
	freight_value decimal
);

CREATE TABLE public.order_payments(
	order_id varchar,
	payment_sequential int,
	payment_type varchar,
	payment_installments int,
	payment_value decimal
);

CREATE TABLE public.order_reviews (
	review_id varchar,
	order_id varchar,
	review_score int,
	review_comment_title varchar,
	review_comment_message varchar,
	review_creation_date timestamp,
	review_answer_timestamp timestamp
);

--=====Import Data CSV=====

COPY customers
(
	customer_id,
	customer_unique_id,
	customer_zip_code_prefix,
	customer_city,
	customer_state
)
FROM 'C:\Users\Public\Documents\Mini Project\Analyzing eCommerce Business Performance with SQL\Dataset\customers_dataset.csv'
DELIMITER ','
CSV HEADER;



COPY geolocation
(
	geolocation_zip_code_prefix,
	geolocation_lat,
	geolocation_lng,
	geolocation_city,
	geolocation_state
)
FROM 'C:\Users\Public\Documents\Mini Project\Analyzing eCommerce Business Performance with SQL\Dataset\geolocation_dataset.csv'
DELIMITER ','
CSV HEADER;


COPY order_items
(
	order_id,
	order_item_id,
	product_id,
	seller_id,
	shipping_limit_date,
	price,
	freight_value
)
FROM 'C:\Users\Public\Documents\Mini Project\Analyzing eCommerce Business Performance with SQL\Dataset\order_items_dataset.csv'
DELIMITER ','
CSV HEADER;


COPY order_payments
(
	order_id,
	payment_sequential,
	payment_type,
	payment_installments,
	payment_value
)
FROM 'C:\Users\Public\Documents\Mini Project\Analyzing eCommerce Business Performance with SQL\Dataset\order_payments_dataset.csv'
DELIMITER ','
CSV HEADER;


COPY order_reviews
(
	review_id,
	order_id,
	review_score,
	review_comment_title,
	review_comment_message,
	review_creation_date,
	review_answer_timestamp
)
FROM 'C:\Users\Public\Documents\Mini Project\Analyzing eCommerce Business Performance with SQL\Dataset\order_reviews_dataset.csv'
DELIMITER ','
CSV HEADER;


COPY orders
(
	order_id,
	customer_id,
	order_status,
	order_purchase_timestamp,
	order_approved_at,
	order_delivered_carrier_date,
	order_delivered_customer_date,
	order_estimated_delivery_date
)
FROM 'C:\Users\Public\Documents\Mini Project\Analyzing eCommerce Business Performance with SQL\Dataset\orders_dataset.csv'
DELIMITER ','
CSV HEADER;


COPY product
(
	num,
	product_id,
	product_category_name,
	product_name_lenght,
	product_description_lenght,
	product_photos_qty,
	product_weight_g,
	product_length_cm,
	product_height_cm,
	product_width_cm
)
FROM 'C:\Users\Public\Documents\Mini Project\Analyzing eCommerce Business Performance with SQL\Dataset\product_dataset.csv'
DELIMITER ','
CSV HEADER;


COPY sellers
(
	seller_id,
	seller_zip_code_prefix,
	seller_city,
	seller_state
)
FROM 'C:\Users\Public\Documents\Mini Project\Analyzing eCommerce Business Performance with SQL\Dataset\sellers_dataset.csv'
DELIMITER ','
CSV HEADER;



--=====PRIMARY KEY=====
ALTER TABLE customers ADD CONSTRAINT customers_pkey PRIMARY KEY(customer_id);
ALTER TABLE sellers ADD CONSTRAINT sellers_dataset_pkey PRIMARY KEY(seller_id);
ALTER TABLE product ADD CONSTRAINT product_pkey PRIMARY KEY(product_id);
ALTER TABLE orders ADD CONSTRAINT orders_pkey PRIMARY KEY(order_id);

--=====FOREIGN KEY======
ALTER TABLE orders ADD FOREIGN KEY (customer_id) REFERENCES customers;
ALTER TABLE order_payments ADD FOREIGN KEY (order_id) REFERENCES orders;
ALTER TABLE order_reviews ADD FOREIGN KEY (order_id) REFERENCES orders;
ALTER TABLE order_items ADD FOREIGN KEY (order_id) REFERENCES orders;
ALTER TABLE order_items ADD FOREIGN KEY (product_id) REFERENCES product;
ALTER TABLE order_items ADD FOREIGN KEY (seller_id) REFERENCES sellers;




