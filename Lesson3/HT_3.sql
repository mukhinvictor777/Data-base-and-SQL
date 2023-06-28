/*
Работаем с таблицей staff (скрипт создания в материалах к уроку)
1. Отсортируйте данные по полю заработная плата (salary) в порядке: убывания; возрастания
2. Выведите 5 максимальных заработных плат (salary)
3. Посчитайте суммарную зарплату (salary) по каждой специальности (роst)
4. Найдите кол-во сотрудников с специальностью (post) «Рабочий» в возрасте от 24 до 49 лет включительно.
5. Найдите количество специальностей
6. Выведите специальности, у которых средний возраст сотрудников меньше 30 лет
*/

SELECT * FROM staff ORDER BY salary;
SELECT * FROM staff ORDER BY salary DESC;

SELECT salary FROM staff ORDER BY salary DESC LIMIT 5;

SELECT post, SUM(salary) FROM staff
GROUP BY post;

SELECT COUNT(id) FROM staff
WHERE
	post = 'рабочий' AND 
    age BETWEEN 24 AND 49;
    
SELECT COUNT(DISTINCT post) as 'Колмчество специальностей' FROM staff;
    
SELECT post FROM staff 
GROUP BY post
HAVING AVG(age) < 30;

