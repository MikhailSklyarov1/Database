
#1 Вывести китайские фирмы
DROP PROCEDURE IF EXISTS get_chinese_products;
DELIMITER $$
CREATE PROCEDURE get_chinese_products(IN country_firm VARCHAR(100))
BEGIN
SELECT `name` AS firm_name, country 
FROM firm 
WHERE country = country_firm;
END$$
DELIMITER ;
CALL get_chinese_products("China");


#2 Расчитать затраты на услуги заданного клиента с учетом количества и скидки
DROP PROCEDURE IF EXISTS get_total_costs_of_services;
DELIMITER $$
CREATE PROCEDURE get_total_costs_of_services(IN full_name_client VARCHAR(100))
BEGIN

SELECT  cl.full_name,
		ser.`name`,
        ord.date_time,
        ROUND(sum(ser.price * s_o.amount) - (ser.price * s_o.amount * c.discount)/100, 0) AS `total_sum`
FROM servise ser
JOIN service_to_order s_o
	ON s_o.id_service = ser.id_servise
JOIN `order` ord
	ON ord.id_order = s_o.id_order
JOIN `client` cl
	ON cl.id_client = ord.id_client
JOIN salon_card_to_client s_c
	ON cl.id_client = s_c.id_client
JOIN salon_card c
	ON c.id_salon_card = s_c.id_salon_card
WHERE cl.full_name = full_name_client
ORDER BY ser.id_servise;

END$$
DELIMITER ;
CALL get_total_costs_of_services("Александров Олег Витальевич");



#3 Вывести кол-во заказов за определенный месяц
DROP PROCEDURE IF EXISTS get_bookings_num;
DELIMITER $$
CREATE PROCEDURE get_order_num(IN `year` YEAR, IN `month` INT)
BEGIN
	SELECT 
	`year`, `month`,
    COUNT(*) AS order_num,
    CASE
    WHEN COUNT(*) = 0 THEN 'Не было оформлено ни одного заказа'
    WHEN COUNT(*) > 10 AND COUNT(*) <= 50 THEN 'Было оформлено мало заказов'
    WHEN COUNT(*) > 50 AND COUNT(*) <= 100 THEN 'Было оформлено среднее кол-во заказов'
    ELSE 'Было оформлено много заказов'
	END AS extra_info
FROM   `order`
WHERE  MONTH(date_time) = `month` 
	   AND YEAR(date_time) = `year`;   
END$$
DELIMITER ;
CALL get_order_num(2021, 6);


####################################################################################################################################
# Функции

#1 Найти самый дорогой товар в каждого цвета
DROP FUNCTION IF EXISTS most_expensive_prices_by_color;
DELIMITER $$
CREATE FUNCTION most_expensive_prices_by_color(color VARCHAR(100))
RETURNS INT
DETERMINISTIC	
READS SQL DATA	
BEGIN

DECLARE most_exp_price INT;
SELECT price
FROM product first_pr
WHERE first_pr.color = color
		AND first_pr.price>ALL(
                      SELECT second_pr.price
                      FROM product second_pr
                      WHERE second_pr.color = first_pr.color
                        AND second_pr.vendor_code<>first_pr.vendor_code 
                        AND second_pr.price IS NOT NULL 
                    ) 
INTO most_exp_price;
                    
RETURN (most_exp_price);
END $$
DELIMITER ;	

SELECT DISTINCT color, most_expensive_prices_by_color(color) AS biggest_price
FROM product;



#2 Показать, кому из клиентов предназначена доставка
DROP FUNCTION IF EXISTS get_delivery_addressee;
DELIMITER $$
CREATE FUNCTION get_delivery_addressee(date_time DATETIME, addr VARCHAR(150))
RETURNS VARCHAR(100)
DETERMINISTIC
READS SQL DATA		
BEGIN

DECLARE client_name VARCHAR(100);

SELECT c.full_name
FROM delivery d
JOIN `order` o
	ON d.id_delivery = o.id_order
JOIN `client` c
	ON o.id_client = c.id_client
WHERE d.`date` = date_time AND d.address = addr
INTO client_name;

RETURN (client_name);
END $$
DELIMITER ;	

SELECT DATE(date), address, get_delivery_addressee(date, address) AS client_name
FROM delivery
LIMIT 100; 




#3 Показать кол-во оформленных заказов за текущий месяц
DROP FUNCTION IF EXISTS get_num_completed_orders_current_month;
DELIMITER $$
CREATE FUNCTION get_num_completed_orders_current_month()
RETURNS INT
DETERMINISTIC
READS SQL DATA		
BEGIN
DECLARE order_num INT;
SELECT 
    COUNT(id_order) 
    INTO order_num
FROM   `order`

WHERE  MONTH(date_time) = MONTH(current_date()) 
	   AND YEAR(date_time) = YEAR(current_date())
       GROUP BY YEAR(curdate()), MONTH(curdate());

RETURN (order_num);
END $$
DELIMITER ;	

SELECT DISTINCT YEAR(curdate()) AS cur_year, 
        MONTH(curdate()) AS cur_month, 
        get_num_completed_orders_current_month() AS num_orders
FROM `order`;



############################################################################################################################
# Модификация 


#Процедура, котрой на вход подается имя клиента . вывести через out параметры:
#1) количество заказов у данного пользователя числом 
#2) текстовое представление этого числа через case when (если от 0 до 5 то слабый покупатель, если 5-10, то...)

DROP PROCEDURE IF EXISTS get_clients_order;
DELIMITER $$
CREATE PROCEDURE get_clients_order(IN client_name VARCHAR(100), OUT num_orders INT, OUT characteristic VARCHAR(100))
BEGIN
	SELECT
    CASE
    WHEN COUNT(*) = 0 THEN 'Покупатель не оформлял заказы' 
    WHEN COUNT(*) > 0 AND COUNT(*) <= 5 THEN 'Покупатель оформлял мало заказов'
    WHEN COUNT(*) > 5 AND COUNT(*) <= 10 THEN 'Покупатель оформлял среднее количество заказов'
    ELSE 'Покупатель оформлял много заказов'
	END INTO characteristic
FROM   `order` ord
JOIN `client` cl
	ON cl.id_client = ord.id_client
WHERE  cl.full_name = client_name;   

	SELECT
    COUNT(*) INTO num_orders

FROM   `order` ord
JOIN `client` cl
	ON cl.id_client = ord.id_client
WHERE  cl.full_name = client_name;  
END$$
DELIMITER ;

CALL get_clients_order("Александров Олег Витальевич", @num_orders, @characteristic);
SELECT @num_orders, @characteristic;



CALL get_clients_order("Maurene MacCourt", @num_orders, @characteristic);
SELECT @num_orders, @characteristic;




############################################################################################################################
# Представления

#1 Найти склад, где экземляров каждого товара меньше необходимого минимума
DROP VIEW IF EXISTS products_min;
CREATE VIEW products_min
AS
SELECT 
	pr.vendor_code, 
	pr.`name`,
	pr.color,
    p_w.quantity,
	16 AS min_needed_amount, 
	w.address 
FROM product pr
JOIN product_to_warehouse p_w
	ON  p_w.id_product = pr.id_product
JOIN warehouse w
	ON  w.id_warehouse = p_w.id_warehouse
WHERE p_w.quantity < 16
ORDER BY vendor_code;

SELECT
	vendor_code, 
	`name`, 
    quantity,
	16 AS min_needed_amount, 
	address 
FROM products_min
WHERE color = "белый";



#2 Рассчитать стоимость услуг в заказе
DROP VIEW IF EXISTS sum_coast_service;
CREATE VIEW sum_coast_service
AS       
SELECT 
	ord.id_order,
    cl.`full_name` AS client_name,
    p_o.id_service,
    p_o.amount,
    ord.payment_method,
    ord.`date_time`,
    SUM(serv.price) * p_o.amount AS servise_overall_price
FROM `order` ord
JOIN service_to_order p_o
	ON p_o.id_order = ord.id_order
JOIN servise serv
	ON serv.id_servise = p_o.id_service
JOIN `client` cl
	ON ord.id_client = cl.id_client
GROUP BY ord.id_order;
SELECT
	ord.id_order
FROM `order` ord;


SELECT
	id_order, 
    amount,
	client_name, 
    `date_time`
FROM sum_coast_service
WHERE amount > 1;


#3 Показать карты клиентов
DROP VIEW IF EXISTS client_card;
CREATE VIEW client_card
AS       
SELECT 
	  cl.full_name,
      card.card_number,
      card.card_type,
      card.discount
FROM  `client` cl
JOIN  salon_card_to_client client_card
	ON 	  client_card.id_client = cl.id_client
JOIN  salon_card card
	ON 	  card.id_salon_card = client_card.id_salon_card;
    
    
SELECT
	full_name,
    discount,
	card_type 
FROM client_card
WHERE discount < 50;
