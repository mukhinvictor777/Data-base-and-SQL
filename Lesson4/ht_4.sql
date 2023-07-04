-- Подсчитать общее количество лайков, которые получили пользователи младше 12 лет.
SELECT
	p.user_id,
    p.birthday,
	(YEAR(CURRENT_DATE)-YEAR(p.birthday))-(RIGHT(CURRENT_DATE,5)<RIGHT(p.birthday,5)) AS 'Возраст'
FROM profiles p;

SELECT
	p.user_id,
    p.birthday,
	(YEAR(CURRENT_DATE)-YEAR(p.birthday))-(RIGHT(CURRENT_DATE,5)<RIGHT(p.birthday,5)) AS 'Возраст'
FROM profiles p
WHERE (YEAR(CURRENT_DATE)-YEAR(p.birthday))-(RIGHT(CURRENT_DATE,5)<RIGHT(p.birthday,5)) < 12;

-- Подсчитать общее количество лайков, которые получили пользователи младше 12 лет.
SELECT 
	COUNT(l.media_id) AS 'Общее количество лайков'
FROM likes l
WHERE l.user_id IN (
	SELECT p.user_id 
	FROM profiles p
	WHERE (YEAR(CURRENT_DATE)-YEAR(p.birthday))-(RIGHT(CURRENT_DATE,5)<RIGHT(p.birthday,5)) < 12
    );
    
-- Ответ: 14 лайков.

-- Определить кто больше поставил лайков (всего): мужчины или женщины.

SELECT CASE (gender)
	WHEN 'm' THEN 'Мужчины'
	WHEN 'f' THEN 'Женщины'
    END AS 'Пол', COUNT(l.media_id) as 'Количество лайков'
FROM profiles p 
JOIN likes l 
	WHERE l.user_id = p.user_id
GROUP BY gender;

SELECT CASE (gender)
	WHEN 'm' THEN 'Мужчины'
	WHEN 'f' THEN 'Женщины'
    END AS 'Пол', COUNT(l.media_id) as 'Количество лайков'
FROM profiles p 
JOIN likes l 
	WHERE l.user_id = p.user_id
GROUP BY gender
LIMIT 1;

-- Вывести всех пользователей, которые не отправляли сообщения.
SELECT 
	id,
	CONCAT(u.firstname, ' ', u.lastname) AS 'Пользователь'
FROM users u
WHERE NOT EXISTS (
	SELECT m.from_user_id
	FROM messages m
	WHERE u.id = m.from_user_id
);

-- (по желанию)* Пусть задан некоторый пользователь. Из всех друзей этого пользователя найдите человека, который больше всех написал ему сообщений.
-- Пусть задан пользователь с id = '1'. Найдем всех друзей пользователя с id = '1'.
SELECT fr.initiator_user_id 
FROM friend_requests fr
	WHERE (fr.target_user_id = 1) AND status ='approved'
UNION
SELECT fr.target_user_id 
FROM friend_requests fr
	WHERE (fr.initiator_user_id = 1) AND status ='approved';
-- у нашего пользователя 1 всего три друга с id 4, 3 и 10

SELECT 
	m.from_user_id AS 'id отправителя', 
	(SELECT CONCAT(firstname,' ', lastname) 
		FROM users u
		WHERE u.id = m.from_user_id) AS 'Фамилия и имя отправителя', 
    COUNT(*) AS `Отправлено сообщений`
FROM messages m
WHERE m.to_user_id = 1 AND m.from_user_id IN 
(
	SELECT fr.initiator_user_id 
    FROM friend_requests fr
		WHERE (fr.target_user_id = 1) -- AND status ='approved'
    UNION
    SELECT fr.target_user_id 
	FROM friend_requests fr
		WHERE (fr.initiator_user_id = 1) -- AND status ='approved' 
)
GROUP BY m.from_user_id
ORDER BY `Отправлено сообщений` DESC 
LIMIT 1;

