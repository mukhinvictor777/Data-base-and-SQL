use lesson_4;
/*
Создайте таблицу users_old, аналогичную таблице users.
Создайте процедуру, с помощью которой можно переместить любого (одного) пользователя из таблицы users в таблицу users_old.
(использование транзакции с выбором commit или rollback – обязательно).
*/
drop table if exists users_old;
create table users_old (
	id serial primary key,
    firstname varchar(50),
    lastname varchar(50) comment 'Фамилия',
    email varchar(120) unique
);

drop procedure if exists move_user;
DELIMITER //
create procedure move_user(user_id bigint)
begin
	insert into users_old (firstname, lastname, email)
    select firstname, lastname, email  from users
		where id = user_id;
	delete from users
		where id = user_id;
	commit;
end//
DELIMITER ;

call move_user(11);
select * from users_old;
select * from users;

/*
Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от текущего времени суток. 
С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро",
с 12:00 до 18:00 функция должна возвращать фразу "Добрый день",
с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи".
*/

drop function if exists hello;
DELIMITER //
create function hello()
returns varchar(30)
deterministic
begin
	declare messege varchar(30);
	select case
		when current_time() >= '6:00:00' and current_time() < '12:00:00' then 'Доброе утро'
		when current_time() >= '12:00:00' and current_time() < '18:00:00' then 'Добрый день'
        when current_time() >= '18:00:00' and current_time() < '0:00:00' then 'Добрый вечер'
        else 'Доброй ночи'
	end into messege;
	return messege;
end//
DELIMITER ;

select hello() as 'приветсвие';

/*
Создайте таблицу logs типа Archive.
Пусть при каждом создании записи в таблицах users, communities и messages в таблицу logs
помещается время и дата создания записи, название таблицы, идентификатор первичного ключа.
*/

drop table if exists logs;
create table leson4_logs (
	date_time datetime default now(),
    name_of_table varchar(30) NOT NULL,
    key_id int unsigned not null
)  engine = ARCHIVE;

create trigger add_log_after_insert_on_users after insert on users
for each row
	insert into leson4_logs set 
		name_of_table = 'users',
        key_id = new.id;

create trigger add_log_after_insert_on_communities after insert on communities
for each row
	insert into leson4_logs set 
		name_of_table = 'communities',
        key_id = new.id;
    
create trigger add_log_after_insert_on_messages after insert on messages
for each row
	insert into leson4_logs set 
		name_of_table = 'messages',
        key_id = new.id;


insert into users (firstname, lastname, email)
VALUES
('Виктор', 'Мухин', 'victor@mail.ru');

select * from leson4_logs;