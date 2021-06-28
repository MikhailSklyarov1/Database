/*firmdeliveryid_groupname*/
USE cellular_salon;
SET SQL_SAFE_UPDATES = 0;
SHOW VARIABLES LIKE "secure_file_priv";
show variables like "local_infile";
set global local_infile = 1;

# Склады
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/warehouse.csv'
INTO TABLE warehouse
FIELDS TERMINATED BY ','
IGNORE 1 ROWS
(address);

# Должности
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/position.csv'
INTO TABLE position
FIELDS TERMINATED BY ','
IGNORE 1 ROWS
(`name`, duties);

# Сотрудники
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/employee.csv'
INTO TABLE employee
FIELDS TERMINATED BY ','
IGNORE 1 ROWS
(full_name, experience, salary, age, id_position);

# Карты салона
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/salon_card.csv'
INTO TABLE salon_card
FIELDS TERMINATED BY ','
IGNORE 1 ROWS
(card_number, card_type, discount);

# Клиенты 
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/client.csv'
INTO TABLE `client`
FIELDS TERMINATED BY ','
IGNORE 1 ROWS
(full_name, age, gender, phone_number, email);

# Связи клиентов и карт
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/salon_card_to_client.csv'
INTO TABLE salon_card_to_client
FIELDS TERMINATED BY ','
IGNORE 1 ROWS
(id_salon_card, id_client);

# Заказы
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/order.csv'
INTO TABLE `order`
FIELDS TERMINATED BY ','
IGNORE 1 ROWS
(payment_method, date_time, id_employee, id_client);

# Доставки
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/delivery.csv'
INTO TABLE delivery
FIELDS TERMINATED BY ','
IGNORE 1 ROWS
(id_delivery, price, address, `date`);

# Типы услуг
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/type.csv'
INTO TABLE `type`
FIELDS TERMINATED BY ','
IGNORE 1 ROWS
(`name`, appointment);

# Группы товаров
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/group.csv'
INTO TABLE `group`
FIELDS TERMINATED BY ','
IGNORE 1 ROWS
(`name`, appointment, dimensions);

# Фирмы
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/firm.csv'
INTO TABLE firm
FIELDS TERMINATED BY ','
IGNORE 1 ROWS
(`name`, country, logo);

# Товары
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/product.csv'
INTO TABLE product
FIELDS TERMINATED BY ','
IGNORE 1 ROWS
(vendor_code, `name`, price, guarantee, rating, color, id_firm, id_group);

# Услуги
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/servise.csv'
INTO TABLE servise
FIELDS TERMINATED BY ','
IGNORE 1 ROWS
(`name`, price, guarantee, id_tipe);

# Связи услуг и заказов
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/service_to_order.csv' 
INTO TABLE service_to_order
FIELDS TERMINATED BY ','
IGNORE 1 ROWS
(id_order, id_service, amount);

# Связи товаров и складов
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/product_to_warehouse.csv' 
INTO TABLE product_to_warehouse
FIELDS TERMINATED BY ','
IGNORE 1 ROWS
(id_warehouse, id_product, quantity);

# Связи товаров и заказов
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/product_to_order.csv' 
INTO TABLE product_to_order
FIELDS TERMINATED BY ','
IGNORE 1 ROWS
(id_order, id_product, amount);

