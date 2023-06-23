drop database if exists ht2;

create database ht2;

use ht2;

drop table if exists sales;

create table sales (
	id INT auto_increment not null primary key unique,
	order_date DATE not null,
	count_product INT not null
);

INSERT INTO sales (order_date, count_product)
VALUES 
('2022-01-01', 156),
('2022-01-01', 180),
('2022-01-01', 21),
('2022-01-01', 124),
('2022-01-01', 341);

drop table if exists orders;

create table orders (
	id INT auto_increment not null primary key unique,
	employee_id VARCHAR(8) not null,
	amount DECIMAL(7,2) not null,
    order_status VARCHAR(40) not null
);

INSERT INTO orders (employee_id, amount, order_status)
VALUES 
('e03', 15.00, 'open'),
('e01', 25.50, 'open'),
('e05', 100.70, 'closed'),
('e02', 22.18, 'open'),
('e04', 9.50, 'cancelled');