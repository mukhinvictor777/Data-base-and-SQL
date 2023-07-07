-- Ранжирование 
-- Вывести список всех сотрудников и указать место в рейтинге по зарплатам

SELECT 
	DENSE_RANK() OVER(ORDER BY salary DESC) AS rank_salary, 
	CONCAT(firstname, ' ', lastname) AS 'Фамилия и Имя',
	post, 
	salary
FROM staff;

-- Вывести список всех сотрудников и указать место в рейтинге по зарплатам, но по каждой должности
SELECT 
	DENSE_RANK() OVER(PARTITION BY post ORDER BY salary DESC) AS rank_salary, 
	CONCAT(firstname, ' ', lastname) AS 'Фамилия и Имя',
	post, 
	salary
FROM staff;

-- Найти самых высокооплачиваемых сотрудников по каждой должности
SELECT rank_salary, 
	staff,
	post, 
	salary
FROM 	
(SELECT 
	DENSE_RANK() OVER(PARTITION BY post ORDER BY salary DESC) AS rank_salary, 
	CONCAT(firstname, ' ', lastname) AS staff,
	post, 
	salary
FROM staff) AS list
WHERE rank_salary=1
ORDER BY salary DESC;

-- Сравнение со смещением 

-- Вывести список всех сотрудников, отсортировав по зарплатам в порядке убывания и 
-- указать на сколько процентов ЗП меньше, чем у сотрудника со следующей (по значению) зарплатой
SELECT 
	id,
	CONCAT(firstname, ' ', lastname) AS staff,
	post, 
	salary,
	LEAD(salary, 1, 0) OVER(ORDER BY salary DESC) AS last_salary, 
	ROUND((salary-LEAD(salary, 1, 0) OVER(ORDER BY salary DESC))*100/salary) AS diff_percent
FROM staff;

--  Агрегация

-- Вывести всех сотрудников, сгруппировав по должностям и рассчитать:
-- общую сумму зарплат для каждой должности
-- процентное соотношение каждой зарплаты от общей суммы по должности
-- среднюю зарплату по каждой должности 
-- процентное соотношение каждой зарплаты к средней зарплате по должности

SELECT 
	id,
	CONCAT(firstname, ' ', lastname) AS staff,
	post, 
	salary,
	SUM(salary) OVER w AS sum_salary,
	ROUND(salary*100/SUM(salary) OVER w) AS percent_sum, 
	AVG(salary) OVER w AS avg_salary,
	ROUND(salary*100/AVG(salary) OVER w) AS percent_avg
FROM staff
WINDOW w AS (PARTITION BY post);

-- примеры использования оконных функций
SELECT 
	id, firstname, lastname, salary,
	ROW_NUMBER() OVER(ORDER BY salary DESC) AS 'ROW_NUMBER', 
	RANK() OVER(ORDER BY salary DESC) AS 'RANK',
 	DENSE_RANK() OVER(ORDER BY salary DESC) AS 'DENSE_RANK',
 	NTILE(3) OVER(ORDER BY salary DESC) AS 'NTILE'
FROM staff;

/*  Получить с помощью оконных функции:
- средний балл ученика 
- наименьшую оценку ученика
- наибольшую оценку ученика
- сумму всех оценок ученика
- количество всех оценок ученика*/
SELECT 
	name, quartal, subject, grade, 
	AVG(grade) OVER(PARTITION BY name) AS avg_grade,
	MIN(grade) OVER(PARTITION BY name) AS min_grade,
	MAX(grade) OVER(PARTITION BY name) AS max_grade,
	SUM(grade) OVER(PARTITION BY name) AS sum_grade,
	COUNT(grade) OVER(PARTITION BY name) AS count_grade
FROM academic_record; 

-- с использованием псевдонима
SELECT 
	name, quartal, subject, grade, 
	AVG(grade) OVER w AS avg_grade,
	MIN(grade) OVER w AS min_grade,
	MAX(grade) OVER w AS max_grade,
	SUM(grade) OVER w AS sum_grade,
	COUNT(grade) OVER w AS count_grade
FROM academic_record
WINDOW w AS (PARTITION BY name); 

SELECT 
	name, quartal, subject, grade,
	LAG(grade) OVER w AS prev_grade,
	LAG(grade, 1, 0) OVER w AS prev_grade, -- смещение на 1 и вместо NULL будет 0
	LEAD(grade) OVER w AS last_grade,
	LEAD(grade, 1, 0) OVER w AS last_grade -- смещение на 1 и вместо NULL будет 0
FROM academic_record
WHERE name = 'Петя' AND subject = 'физика'
WINDOW w AS (ORDER BY  quartal); 