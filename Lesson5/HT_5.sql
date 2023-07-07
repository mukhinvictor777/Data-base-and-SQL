use lesson_4;

-- 1. Создайте представление, в которое попадет информация о пользователях (имя, фамилия, город и пол), которые не старше 20 лет.

CREATE OR REPLACE VIEW  years_old AS 
SELECT 
	CONCAT(firstname, ' ', lastname) AS 'Имя и Фамилия',
    p.hometown as 'Город',
    p.gender as 'Пол'
FROM users u
JOIN profiles p ON u.id = p.user_id
WHERE TIMESTAMPDIFF(YEAR, birthday, NOW()) < 20
GROUP BY u.id;

SELECT * FROM years_old;

/*
Найдите кол-во, отправленных сообщений каждым пользователем и выведите ранжированный список пользователь, 
указав имя и фамилию пользователя, количество отправленных сообщений и место в рейтинге 
(первое место у пользователя с максимальным количеством сообщений) . (используйте DENSE_RANK)
*/

SELECT
	CONCAT(firstname, ' ', lastname) AS 'Имя и Фамилия',
    COUNT(from_user_id) AS 'Количество отправленных сообщений',
    DENSE_RANK() OVER (ORDER BY COUNT(from_user_id) DESC) AS 'Место в рейтинге'
FROM users u
JOIN messages m ON u.id = m.from_user_id
GROUP BY u.id;

/*
Выберите все сообщения, отсортируйте сообщения по возрастанию даты отправления (created_at)
и найдите разницу дат отправления между соседними сообщениями, получившегося списка. (используйте LEAD или LAG)
*/

SELECT
	body as 'Сообщение',
    created_at as 'дата и время создания',
    TIMEDIFF(created_at, LAG(created_at) OVER()) AS prev_message,
	TIMEDIFF(created_at, LEAD(created_at) OVER()) AS next_message
FROM messages
ORDER BY created_at ASC;