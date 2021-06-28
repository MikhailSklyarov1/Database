USE cellular_salon;
SET SQL_SAFE_UPDATES = 0;


#1 --- Запросы, которые вы указали в функциональных требованиях  (15 шт. +)   
# Транзакционные
#1 Изменение цены    (Всего:1)                                                      
UPDATE product 
SET price = 26000
WHERE id_product = 7;


#2 Изменить должность указанного работника      (Всего:2)                               
UPDATE position 
SET name = 'кассир'
WHERE id_position = 1;


#3 Удалить заказ                    (Всего:3)                                         
DELETE FROM product_to_order
WHERE id_order = 4;

DELETE FROM delivery
WHERE id_delivery = 4;

DELETE FROM service_to_order
WHERE id_order = 4;

DELETE FROM `order`
WHERE id_order = 4;


#4 Оформить заказ               (Всего:4)                                                    
INSERT INTO `order`
		(payment_method, date_time, id_client, id_employee)
VALUES  ('наличные', '2020-09-06 12:48:00', 3, 5);

INSERT INTO product_to_order
		(id_order, id_product, amount)
VALUES  (8, 15, 1);


#5 Изменить обязанности определенной должности      (Всего:5) 
UPDATE position 
SET duties = 'работает с кассой'
WHERE `name` = 'кассир';


# Оперативные
#6 Добавить товар в заказ               (Всего:6) 
INSERT INTO product_to_order
		(id_order, id_product, amount)
VALUES  (7, 2, 2);


#7 Показать товары в заказе      (Всего:7) 
SELECT
	 b.id_order,
     e.`name`,
     e.price,
     e.color,
	 b.amount
FROM product_to_order b
JOIN product e
	ON e.id_product = b.id_product
ORDER BY b.id_order, e.id_product;


#8 Удалить товар из заказа          (Всего:8)
DELETE FROM product_to_order
WHERE id_product = 3 AND id_order = 6;

#9 Показать cуществующие цвета товаров       (Всего:9)
SELECT DISTINCT
    a.color
FROM product a;


#10 Показать адреса и даты доставки      (Всего:10)
SELECT
	a.id_delivery,
    a.address,
    a.date
FROM delivery a;

#11 Показать карты клиентов      (Всего:11)
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


# Аналитические
#12 Показать товар с самым высоким рейтингом       (Всего:12)
SELECT vendor_code, `name`, rating AS max_rating
FROM   product
WHERE  rating = (SELECT MAX(rating) FROM product);


#13 Показать количество товаров на складе        (Всего:13)
SELECT 
	  pr.vendor_code,
	  pr.`name`,
      pr.price,
      pr.guarantee,
      pr.rating,
      pr.color,
	  p_w.quantity
FROM  product pr
JOIN  product_to_warehouse p_w
	ON 	  p_w.id_product = pr.id_product
JOIN  warehouse w
	ON 	  w.id_warehouse = p_w.id_warehouse;


#14 Рассчитать стоимость товаров в заказе     (Всего:14)
SELECT 
	ord.id_order,
    cl.`full_name` AS client_name,
    p_o.id_product,
    p_o.amount,
    ord.payment_method,
    ord.`date_time`,
    SUM(pr.price * p_o.amount) AS product_overall_price
FROM `order` ord
JOIN product_to_order p_o
	ON p_o.id_order = ord.id_order
JOIN product pr
	ON p_o.id_product = pr.id_product
JOIN `client` cl
	ON ord.id_client = cl.id_client
GROUP BY ord.id_order;
SELECT
	ord.id_order
FROM `order` ord;


#15 Рассчитать стоимость услуг в заказе       (Всего:15)
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


#16 Показать кол-во оформленных заказов за текущий месяц        (Всего:16)
SELECT 
	YEAR(curdate()) AS cur_year, 
    MONTH(curdate()) AS cur_month, 
    COUNT(*) AS order_num
FROM   `order`
WHERE  MONTH(date_time) = MONTH(current_date()) 
	   AND YEAR(date_time) = YEAR(current_date());


#17 Показать средний чек заказа за месяц                       (Всего:17)
SELECT 
	YEAR(date_time) AS year, 
	MONTH(date_time) AS month,
    ROUND(AVG(overall_price), 0) AS avg_order_price
FROM (
	SELECT 
		ord.id_order, 
        ord.date_time, 
        SUM(pr.price) AS overall_price
	FROM `order` ord
	JOIN product_to_order p_o
		ON ord.id_order = p_o.id_order
	JOIN product pr
		ON p_o.id_product = pr.id_product
	GROUP BY ord.id_order) AS tmp_table
GROUP BY YEAR(date_time), MONTH(date_time);


# Плановые
#18 Найти товары, которых меньше определенного количества на складах           (Всего:18)
#Найти склад, где экземляров каждого товара меньше необходимого минимума
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

CREATE INDEX index_quantity ON product_to_warehouse(quantity);
DROP INDEX index_quantity ON product_to_warehouse;

#2 --- UPDATE в разных таблицах, с WHERE, можно, например, изменить заранее созданные некорректные данные (5 шт.)
#1 Повысить з/п Сидорову                     (Всего:19)
UPDATE employee
SET salary = salary + 2000
WHERE full_name = 'Сидоров Иван Васильевич';


#2 Добавить бонусов на счет клиентов в честь юбилея магазина         (Всего:20)
UPDATE salon_card 
SET discount = discount + 50
LIMIT 1000;


#3 Исправить отчество сотрудника Худяковой                  (Всего:21)
UPDATE employee
SET full_name = 'Худякова Елена Константиновна'
WHERE id_employee = 6;


#4 Увеличить цену для наиболее качественных товаров            (Всего:22)
UPDATE product
SET price = price + 50 
WHERE rating >= 8.0
LIMIT 100;


#5 Увеличить цену на черные телефоны                        (Всего:23)
UPDATE product
SET price = price + 100 
WHERE `name` = "телефон" AND color = "черный";


#6 Перенести все сегодняшние доставки на след.день                 (Всего:24)
UPDATE delivery 
SET `date` = DATE_ADD(date, INTERVAL 1 DAY)
WHERE `date` = curdate();


#3 --- DELETE в разных таблицах, с WHERE, можно, например, удалить заранее созданные некорректные данные (5 шт.)
#1 Удалить определенный склад                (Всего:25)
DELETE FROM warehouse 
WHERE address = "Сталина 5";


#2 Убрать должность электрика                   (Всего:26)
DELETE FROM position 
WHERE `name` = "электрик";


#3 Убрать тип услуги                            (Всего:27)
DELETE FROM `type`
WHERE `name` = "реставрация";


#4 Отменить доставку, если она дешевле 60 рублей                (Всего:28)
DELETE FROM delivery
WHERE price < 60;

#5 Убрать определенную группу товаров                      (Всего:29)
DELETE FROM `group`
WHERE `name` = "батарейка";


#4 --- SELECT, DISTINCT, WHERE, AND/OR/NOT, IN, BETWEEN, различная работа с датами и числами, преобразование данных, IS NULL, AS для таблиц и столбцов и др. в различных вариациях (20 шт. +)
#1 Показать клиентов определенного возраста                     (Всего:30)
SELECT 
	full_name, phone_number, email
FROM client
WHERE age BETWEEN 20 AND 30;

#2 Показать работников, зарплаты которых в диапазрне           (Всего:31)
SELECT `full_name`, experience, salary, age
FROM employee
WHERE salary BETWEEN 20000 AND 30000;

#3 Вывести совершеннолетних клиентов женского пола                (Всего:32)
SELECT 
	full_name, phone_number, email
FROM client
WHERE gender = 'W' AND age >= 18;

#4 Вывести товары из Китая                                 (Всего:33)
SELECT `name` AS firm_name, country 
FROM firm 
WHERE country = "China";

#5 Вывести работников с опытом больше года                             (Всего:34)
SELECT full_name AS employee_name, experience, salary, age 
FROM employee 
WHERE experience > 1;

#6 Вывести заказы, которые оплачены наличными                               (Всего:35)
SELECT DISTINCT payment_method, date_time
FROM `order`
WHERE payment_method = "наличные";

#7 Вывести заказы, которые были оформлены в определенные годы                   (Всего:36)
SELECT payment_method, date_time
FROM `order`
WHERE year(date_time) IN (2020, 2021)
ORDER BY date_time DESC;

#8 Показать гарантии товаров                                                       (Всего:37)
SELECT DISTINCT `name` AS name_product, guarantee
FROM product
ORDER BY guarantee;

#9 Показать обязанности кассиров                                             (Всего:38)
SELECT DISTINCT `name` AS name_position, duties
FROM position
ORDER BY duties;

#10 Вывести наименования услуг, которые дороже определенной суммы                  (Всего:39)
SELECT `name` AS name_service, price, guarantee
FROM servise
WHERE price > 50;

#11 Вывести адреса почт клиентов                                                  (Всего:40)
SELECT DISTINCT full_name, email
FROM `client`;

#12 Вывести информацию о платных доставках в марте месяце                        (Всего:41)
SELECT id_delivery, `date`, address
FROM delivery 
WHERE MONTH(date) = 3 AND NOT price = 0;

#13 Вывести информацию о доставках по определенному адресу                    (Всего:42)
SELECT id_delivery, `date`
FROM delivery
WHERE address = 'Победы 2';

#14 Показать товары с высоким рейтингом                                            (Всего:43)
SELECT vendor_code, `name` AS name_product, price, guarantee, rating, color
FROM product
WHERE rating BETWEEN 8 AND 10;

#15 Показать, сколько приблизительно зарабатывает каждый сотрудник в неделю          (Всего:44)
SELECT full_name, CONVERT(salary,float)/4 AS week_salary
FROM employee;

#16 Показать в виде строки, в какой месяц был оформлен заказ                        (Всего:45)
SELECT id_order, MONTHNAME(date_time) AS `month`
FROM `order`;

#17 Показать номер календарной недели, когда был оформлен заказ                    (Всего:46)
SELECT id_order, WEEKOFYEAR(date_time) AS week_num, YEAR(date_time)
FROM `order`
ORDER BY date_time, week_num;

#18 Вывести ссылки на логитип фирм                                               (Всего:47)
SELECT DISTINCT `name` AS name_firm, logo
FROM firm;

#19 Вывести возраст клиентов мужского пола                                    (Всего:48)
SELECT full_name, gender, age
FROM `client`
WHERE gender = 'M';

#20 Показать адреса складов                                                 (Всего:49)
SELECT DISTINCT address
FROM warehouse;


#5 --- LIKE и другая работа со строками (5-7 шт.+)
#1 Показать ФИО и номер клиента, у когорого номер X-905-XXX-XX-XX        (Всего:50)
SELECT full_name AS client_name, phone_number
FROM `client`
WHERE phone_number LIKE '_927%';

#2 Вывести инф-ю о доставках по ул.Лавочкина                            (Всего:51)
SELECT id_delivery, `date`, address
FROM delivery
WHERE address LIKE 'Победы%';

#3 Вывести информацию о работниках, в ФИО которых есть буквосочетание "ова", но ФИО не начинается на "Кар"   (Всего:52)
SELECT full_name AS employee_name, age, salary
FROM employee
WHERE (full_name NOT LIKE 'Сид%' AND full_name LIKE CONCAT('%', 'ова ', '%'));

#4 Получить информацию о сотрудниках в строке                                                             (Всего:53)
SELECT
	CONCAT_WS(' ', 'Сотрудник',  emp.full_name, 'с зарплатой', emp.salary, 'имеет должность', pos.`name`) AS employee_info
FROM employee emp
JOIN position pos
	ON emp.id_position = pos.id_position;
    
#5 Показать бонусы на счету клиента в строке                                                          (Всего:54)
SELECT 
	CONCAT('Клиент "', cl.full_name, '" ','имеет на счету карты ',  s.`card_type`, ' ', s.discount, ' бонусов') AS discount_info
FROM `client` cl
JOIN salon_card_to_client s_c
  ON cl.id_client = s_c.id_client
JOIN salon_card s
  ON s_c.id_salon_card = s.id_salon_card;

    
#6 --- SELECT INTO или INSERT SELECT, что поддерживается СУБД (2-3 шт.)                           (Всего:55)
#1 Скопировать содержимое таблицы клиентов
INSERT INTO new_client
SELECT *
FROM `client`
WHERE age >= 18; 

#2 Скопировать информацию из таблиц order и client                                                (Всего:56)
INSERT INTO all_info_order 
SELECT ord.id_order, ord.date_time, ord.payment_method, cl.full_name AS client_name, cl.phone_number AS client_phone
FROM `order` ord
JOIN `client` cl 
	ON ord.id_client = cl.id_client;

#3 Скопировать информацию о товаре и фирме                                                 (Всего:57)
INSERT INTO all_info_firm_product
SELECT 
	pr.vendor_code, 
    pr.`name` AS name_product,
    pr.price,
    f.`name` AS name_firm,
    f.country
FROM product pr
JOIN firm f
	ON f.id_firm = pr.id_firm;


#7 --- JOIN: INNER, OUTER (LEFT, RIGHT, FULL), CROSS, NATURAL (20 шт.+)            
#1 Вывести информацию об услугах                                                      (Всего:58)
SELECT
	s.`name` AS servise_name,
    t.`name` AS type_name,
    t.appointment,
    s.price,
    s.guarantee
FROM servise s
JOIN `type` t
	ON s.id_tipe = t.id_type;

#2 Вывести данные о товаре, его количестве и заказе                              (Всего:59)
SELECT
	o.date_time,
	o.id_order,
    o.payment_method,
    s.`name`,
    s.price,
    s_to_o.amount
FROM service_to_order s_to_o
JOIN servise s
	ON s.id_servise = s_to_o.id_service
JOIN `order` o
	ON o.id_order = s_to_o.id_order
ORDER BY date_time;

#3 Вывести информацию о товарах и их фирмах                                    (Всего:60)
SELECT
	p.vendor_code,
    p.`name` AS product_name,
    p.price,
    p.color,
    p.rating,
    f.`name` AS firm_name,
    f.country
FROM product p
JOIN firm f
	ON f.id_firm = p.id_firm
ORDER BY p.vendor_code;

#4 Вывести информацию о товаре и его группе                                    (Всего:61)
SELECT 
	p.vendor_code,
    p.name AS product_name,
    g.name AS product_type,
    p.color,
    g.dimensions,
    g.appointment,
    p.price,
    p.rating
FROM product p
JOIN `group` g
	ON g.id_group = p.id_group
ORDER BY p.vendor_code;

#5 Вывести информацию о заказе с доставкой                            (Всего:62)
SELECT
	date(o.date_time) as order_date,
    time(o.date_time) as order_time,
    o.payment_method,
    d.date as delivery_date,
    d.address,
    d.price
FROM `order` o
LEFT JOIN delivery d
	ON o.id_order = d.id_delivery
ORDER BY order_date, order_time;

#6 Показать информацию о товаре и скаде                               (Всего:63)
SELECT
	w.address,
	p.vendor_code,
    p.name,
	pr_to_w.quantity
FROM product_to_warehouse pr_to_w
JOIN product p
	ON p.id_product = pr_to_w.id_product
JOIN warehouse w
	ON w.id_warehouse = pr_to_w.id_warehouse
ORDER BY w.id_warehouse, vendor_code;

#7 Показать, какой работник обслуживал заказ                          (Всего:64)
SELECT
	o.date_time,
	o.id_order,
    e.full_name,
    p.name AS position
FROM `order` o
JOIN employee e
	ON o.id_employee = e.id_employee
JOIN position p
	ON p.id_position = e.id_position
ORDER BY date_time;

#8 Показать информацию о картах клиентов                     (Всего:65)
SELECT
	cl.full_name,
    sc.card_number,
    sc.card_type,
    sc.discount
FROM salon_card_to_client sc_to_cl
RIGHT JOIN client cl
	ON sc_to_cl.id_client = cl.id_client
JOIN salon_card sc
	ON sc_to_cl.id_salon_card = sc.id_salon_card
ORDER BY sc.card_number, full_name;

#9 Показать инф-цию о работниках и их должности/обязанностях      (Всего:66)
SELECT
	e.full_name,
    p.name,
    p.duties,
    e.experience,
	e.salary
FROM employee e
JOIN position p
	ON e.id_position = p.id_position;
    
#10 Показать, какой клиент, где и когда получит доставку      (Всего:67)
SELECT
	d.date,
    d.address,
    d.price,
	c.full_name
FROM client c
JOIN `order` o
	ON c.id_client = o.id_client
JOIN delivery d
	ON d.id_delivery = o.id_order
ORDER BY d.date, d.address;

#11 Показать полную инф-цию о продукте                  (Всего:68)
SELECT
	p.vendor_code,
    p.name AS product,
    f.name AS firm,
    f.country,
    p.rating,
    p.price,
    p.color,
    g.dimensions,
    w.address,
    pr_to_w.quantity
FROM product p
JOIN `group` g
	ON g.id_group = p.id_group
JOIN firm f
	ON f.id_firm = p.id_firm
JOIN product_to_warehouse pr_to_w
	ON p.id_product = pr_to_w.id_product
JOIN warehouse w
	ON w.id_warehouse = pr_to_w.id_warehouse
ORDER BY p.vendor_code;

#12 Узнать среднюю цену на товары каждого бренда            (Всего:69)
SELECT 
	f.`name`,
    ROUND(AVG(price), 1) AS avg_price
FROM firm f
JOIN product pr
	ON f.id_firm = pr.id_firm
GROUP BY f.`name`
ORDER BY f.`name`;

#13 Показать, товары каких фирм могут быть каких цветов(через декартово произведение)   (Всего:70)
SELECT DISTINCT f.`name`, pr.color
FROM product pr
CROSS JOIN firm f
	ON pr.id_firm = f.id_firm
ORDER BY `name`;

#14 Показать все возможные цвета зарядок и телефонов                  (Всего:71)
SELECT DISTINCT gr.`name`, pr.color
FROM product pr
JOIN `group` gr
	ON gr.id_group = pr.id_group
WHERE gr.`name` = 'телефоны' OR gr.`name` = 'зарядные устройства'
ORDER BY `name`;

CREATE INDEX index_g ON `group`(`name`);
DROP INDEX index_g ON `group`;

#15 Показать, вещи каких брендов и сколько есть в заказе                 (Всего:72)
SELECT 
	del.id_delivery, 
    del.address,
    pr.`name`,
    count(*) AS products_num,
    p_o.amount,
    f.`name`
FROM delivery del
JOIN `order` ord
	ON del.id_delivery = ord.id_order
JOIN product_to_order p_o
	ON ord.id_order = p_o.id_order
JOIN product pr
	ON pr.id_product = p_o.id_product
JOIN firm f
    ON pr.id_firm = f.id_firm
GROUP BY id_delivery, del.address, pr.`name`;

#16 Показать, кому из клиентов предназначена доставка               (Всего:73)
SELECT 
	del.id_delivery,
	del.address, 
	del.`date`, 
	cl.full_name
FROM delivery del
JOIN `order` ord
	ON del.id_delivery = ord.id_order
JOIN client cl
	ON cl.id_client = ord.id_client;
    
#17 Показать, какого цвета есть вещи всех фирм                    (Всего:74)
SELECT f.`name`, 
	   pr.color
FROM firm f
JOIN product pr
	ON pr.id_firm = f.id_firm
ORDER BY f.`name`;

#18 Показать, кто офорлял заказ                           (Всего:75)
SELECT ord.id_order, 
	   ord.payment_method, 
	   emp.full_name, 
       pos.`name` AS position
FROM `order` ord
JOIN employee emp
	ON ord.id_employee = emp.id_employee
JOIN position pos
	ON pos.id_position = emp.id_position
ORDER BY ord.id_order;

#19 Показать типы карт клиентов                            (Всего:76)
SELECT cl.full_name, 
	   s.`card_type`
FROM `client` cl
JOIN salon_card_to_client s_c
	ON cl.id_client = s_c.id_client
JOIN salon_card s
	ON s.id_salon_card = s_c.id_salon_card
ORDER BY cl.full_name;

#20 Показать зарплату всех сотрудников и их обязанности          (Всего:77)
SELECT emp.full_name,
	   emp.salary, 
	   pos.duties
FROM employee emp
JOIN position pos
	ON emp.id_position=pos.id_position
ORDER BY emp.salary;


#8 --- GROUP BY (некоторые с HAVING), с LIMIT, ORDER BY (ASC|DESC) вместе с COUNT, MAX, MIN, SUM, AVG в различных вариациях, можно по отдельности (20 шт.+)
#1 Показать средний возраст клиентах (для каждого опла отдельно)                   (Всего:78)
SELECT 
	gender, round(avg(age), 1)
FROM client
GROUP BY gender;

#2 Показать, расходы компании на з/п работникам за месяц                         (Всего:79)
SELECT 
	sum(salary) total_salary
FROM employee;

#3 Показать, сколько работников компании работают на определенной должности          (Всего:80)
SELECT pos.`name`, COUNT(full_name) AS num_of_empl
FROM employee emp
JOIN position pos
	ON emp.id_position = pos.id_position
GROUP BY pos.`name`
ORDER BY num_of_empl;

#4 Показать, сколько денег нужно заплатить всем сотрудникам компании                (Всего:81)
SELECT SUM(salary) AS salary_costs
FROM employee;

#5 Показать средний возраст клиентов                                              (Всего:82)
SELECT ROUND(AVG(age), 2) AS avg_client_age
FROM client;

#6 Показать средний рейтинг товаров                                            (Всего:83)
SELECT ROUND(AVG(rating), 2) AS avg_client_age
FROM product;

#7 Показать, сколько складов принадлежит компании                            (Всего:84)
SELECT count(address) AS num
FROM warehouse
ORDER BY num;

#8 Найти белый товар с самым низким рейтингом                                (Всего:85)
SELECT `name`, min(rating)
FROM product
GROUP BY color
HAVING color = "белый";

#9 Показать товары с рейтингом выше 8.0                                    (Всего:86)
SELECT `name`, 
		price
FROM product
GROUP BY rating
HAVING rating > 8.0;


#10 Показать среднюю стоимость услуг                                  (Всего:87)
SELECT ROUND(AVG(price), 2) AS avg_service_price
FROM servise;

#11 Показать максимальное количество заказов в день за последний месяц           (Всего:88)
SELECT date(date_time) AS date_time, count(*) AS order_num
FROM `order`
GROUP BY date(`date_time`)
HAVING 
	MONTH(`date_time`) = MONTH(curtime()) AND
	YEAR(`date_time`) = YEAR(curtime())
ORDER BY date_time DESC;


#12 Показать кол-во товаров в заказе                                           (Всего:89)
SELECT id_order, sum(amount) AS product_num
FROM product_to_order
GROUP BY id_order
ORDER BY id_order DESC;

#13 Показать, сколько заказов оформил каждый сотрудник                     (Всего:90)
SELECT id_employee, count(*) AS order_num
FROM `order`
GROUP BY id_employee
ORDER BY id_order DESC;

#14 Показать, сколько заказов оплатил каждый клиент                      (Всего:91)
SELECT `client`.full_name, count(*) AS order_num
FROM `order`
JOIN `client` ON `order`.id_client = `client`.id_client
GROUP BY `order`.id_client
ORDER BY id_order DESC;

#15 Вычислить среднюю з/п сотрудников с определенным стажем          (Всего:92)
SELECT experience, ROUND(AVG(salary), 1) AS avg_salary
FROM employee
GROUP BY experience;

#16 Вычислить средний возраст мужчин и женщин             (Всего:93)
SELECT gender, ROUND(AVG(age), 1) AS avg_age
FROM `client`
GROUP BY gender;

#17 Вычислить среднюю скидку на каждый тип карты             (Всего:94)
SELECT card_type, ROUND(AVG(discount), 1) AS avg_discount
FROM salon_card
GROUP BY card_type;

#9 Показать услуги, которые дешевле определенной суммы         (Всего:95)
SELECT `name`, 
		price
FROM servise
GROUP BY price
HAVING price < 70;



#9 --- UNION, EXCEPT, INTERSECT, что поддерживается СУБД (3-5 шт.)
#1 Показать информацию по товарам и их фирмам                                  (Всего:96)
(SELECT 
	pr.vendor_code,
    pr.`name`,
    pr.price, 
    pr.color, 
    f.`name` AS name_firm
FROM product pr
LEFT JOIN firm f
	ON pr.id_firm = f.id_firm)
    UNION
(SELECT 
	pr.vendor_code, 
    pr.`name`,
    pr.price, 
    pr.color,  
    f.`name` AS name_firm
FROM product pr
RIGHT JOIN firm f
	ON pr.id_firm = f.id_firm);
    


#10 --- Вложенные SELECT с ALL, ANY, EXISTS (3-5 шт.)
#1 Найти самый дорогой товар каждого цвета                           (Всего:97)
SELECT color, price
FROM product pr_1
WHERE pr_1.price>ALL(
                      SELECT pr_2.price
                      FROM product pr_2
                      WHERE pr_2.color = pr_1.color
                        AND pr_2.vendor_code<>pr_1.vendor_code -- чтобы исключить сравнение с самим собой
                        AND pr_2.price IS NOT NULL -- исключить NULL значения
                    );


#11 --- GROUP_CONCAT и другие разнообразные функции SQL (2-3 шт.)
#1 Вывести фамилии всех кассиров                                        (Всего:98)
SELECT GROUP_CONCAT(emp.full_name)    AS `cashiers_name`       
FROM employee emp
JOIN position pos
	ON emp.id_position = pos.id_position
WHERE pos.`name` = 'кассир';

CREATE INDEX index_pos ON `position`(`name`);
DROP INDEX index_pos ON `position`;

#12 --- Сложные запросы, входящие в большинство групп выше, т.е. SELECT ... JOIN ... JOIN ... WHERE ... GROUP BY ... ORDER BY ... LIMIT ...; (5-7 шт. +), можно написать больше вместо простых.
#1 Найти склад, где экземляров каждого товара меньше необходимого минимума                 (Всего:99)
SELECT 
	pr.id_product,
	pr.vendor_code, 
	pr.color,
    p_w.quantity,
	10 AS min_needed_amount, 
	war.address 
FROM product pr
JOIN product_to_warehouse p_w
	ON  pr.id_product = p_w.id_product
JOIN warehouse war
	ON war.id_warehouse = p_w.id_warehouse
WHERE p_w.quantity < 10
ORDER BY id_product;

#2 Найти склад, где количество каждого товаров минимальное         (Всего:100)
SELECT 
	pr.id_product,
	pr.vendor_code, 
	pr.color,
	MIN(p_w.quantity) AS available_amount, 
	war.address 
FROM product pr
JOIN product_to_warehouse p_w
	ON  pr.id_product = p_w.id_product
JOIN warehouse war
	ON war.id_warehouse = p_w.id_warehouse
GROUP BY id_product;



#####################################################################################################################################
# Модификации

#1 Для заданного клиента в заданный заказ с датой и временем вывести все продукты,
# которые входят в этот заказ со всеми данными и количеством. Вывести, какой сотрудник оформил
SELECT pr.vendor_code,
	   pr.`name` AS name_product, 
	   pr.price,
       pr.guarantee,
       pr.rating,
       pr.color,
       f.`name` AS name_firm,
       g.`name` AS name_group,
       p_o.amount,
       emp.full_name AS name_employee
FROM product pr
JOIN product_to_order p_o
	ON p_o.id_product = pr.id_product
JOIN `order` ord
	ON ord.id_order = p_o.id_order
JOIN `client` cl
	ON ord.id_client = cl.id_client
JOIN employee emp
	ON ord.id_employee = emp.id_employee
JOIN firm f
	ON pr.id_firm = f.id_firm
JOIN `group` g
	ON pr.id_group = g.id_group
WHERE date(ord.date_time) = '2020-12-16' AND time(ord.date_time) = '16:20:00' 
AND cl.full_name = "Александров Олег Витальевич" AND ord.id_order = 5;


# Для заданного клиента за заданный период времени посчитать суммарные затраты на услуги
# с учетом количества и скидки
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
/*WHERE year(ord.date_time) = 2020 AND month(ord.date_time) = 12 AND cl.full_name = "Александров Олег Витальевич"*/
WHERE (date_time BETWEEN "2019-11-05 " AND "2021-06-24 ") AND cl.full_name = "Александров Олег Витальевич"
ORDER BY ser.id_servise;

CREATE INDEX index_cl ON `client`(full_name);
DROP INDEX index_cl ON `client`;

# Сводка по заданному складу с определенным адресом. Вывести все продукты, которые на нем находятся
# по убыванию количества. Топ 5
SELECT  war.address,
		pr.vendor_code,
        p_w.quantity,
        pr.`name`,
        pr.price,
        pr.rating,
        pr.color,
        f.`name`,
        f.country,
        g.`name`,
        g.appointment

FROM warehouse war
JOIN product_to_warehouse p_w
	ON p_w.id_warehouse = war.id_warehouse
JOIN product pr
	ON p_w.id_product = pr.id_product
JOIN firm f
	ON f.id_firm = pr.id_firm
JOIN `group` g
	ON g.id_group = pr.id_group
WHERE war.address = 'ленина 55'
ORDER BY p_w.quantity DESC
LIMIT 5;

CREATE INDEX index_war ON warehouse(address);
DROP INDEX index_war ON warehouse;

