SELECT id, firstname, lastname, post, seniority, salary, age  FROM staff;
SELECT * FROM staff ORDER BY age;
SELECT * FROM staff ORDER BY firstname;
SELECT firstname, lastname, age FROM staff ORDER BY firstname DESC;
SELECT firstname, age FROM staff ORDER BY firstname DESC, age DESC;

SELECT DISTINCT firstname FROM staff;

SELECT * FROM staff ORDER BY id LIMIT 2;
SELECT * FROM staff ORDER BY id LIMIT 4, 3;
SELECT * FROM staff ORDER BY id DESC LIMIT 2, 3;

SELECT COUNT(*) FROM staff WHERE post = 'Рабочий';
SELECT AVG(age) FROM staff WHERE salary > 30000;
SELECT MAX(salary), MIN(salary) FROM staff;

SELECT date_activity,AVG(count_pages) FROM activity_staff
GROUP BY date_activity;

SELECT 
	CASE 
			WHEN age < 20 THEN 'Младше 20 лет'
			WHEN age between 20 AND 40 THEN 'от 20 до 40 лет'
			WHEN age > 40 THEN 'Старше 40 лет'
			ELSE 'Не определено'
	END AS name_age, 
	SUM(salary)
FROM staff 
GROUP BY name_age;

SELECT date_activity, COUNT(count_pages) AS cnt_staff FROM activity_staff 
GROUP BY date_activity
HAVING cnt_staff>3;

SELECT post FROM staff 
GROUP BY post
HAVING AVG(salary) > 30000;