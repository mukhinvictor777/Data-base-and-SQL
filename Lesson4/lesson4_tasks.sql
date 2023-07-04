SELECT 
	id,
	CONCAT(firstname, ' ', lastname) AS 'Пользователь', 
	(SELECT hometown FROM profiles WHERE user_id = users.id) AS 'Город',
	(SELECT filename FROM media WHERE id = 
	    (SELECT photo_id FROM profiles WHERE user_id = users.id)) AS 'Аватарка'
FROM users;

SELECT filename FROM media 
WHERE 
user_id = (SELECT id FROM users WHERE email = 'arlo50@example.org')
AND media_type_id IN (
      SELECT id FROM media_types WHERE name_type LIKE 'photo' );
      
SELECT initiator_user_id AS id FROM friend_requests 
WHERE target_user_id = 1 AND status='approved' -- ID друзей, заявку которых я подтвердил
UNION
SELECT target_user_id FROM friend_requests 
WHERE initiator_user_id = 1 AND status='approved'
ORDER BY id;

SELECT * FROM users, messages;
SELECT * FROM users
JOIN messages;

SELECT * FROM users u
JOIN messages m 
WHERE u.id=m.from_user_id;

SELECT * FROM users u
JOIN messages m ON u.id=m.from_user_id;

SELECT u.*, m.*  FROM users u
LEFT JOIN messages m ON u.id=m.from_user_id;

-- RIGHT  JOIN
SELECT u.*, m.*  FROM users u
RIGHT JOIN messages m ON u.id=m.from_user_id;

SELECT u.*, m.*  FROM users u
LEFT JOIN messages m ON u.id=m.from_user_id
UNION 
SELECT u.*, m.*  FROM users u
RIGHT JOIN messages m ON u.id=m.from_user_id;

SELECT 
	u.id,
	CONCAT(u.firstname, ' ', u.lastname) AS 'Пользователь', 
	p.hometown AS 'Город',
	m.filename AS 'Аватарка'
FROM users u
JOIN profiles p ON  u.id=p.user_id 
LEFT JOIN media m ON p.photo_id=m.id;

-- Список медиафайлов пользователей с количеством лайков
-- (используя JOIN)
SELECT 
	m.id,
	m.filename AS 'медиа',
	CONCAT(u.firstname, ' ', u.lastname) AS 'владелец медиа',	
	COUNT(l.id) AS 'кол-во лайков'
FROM media m
LEFT JOIN likes l ON l.media_id = m.id
JOIN users u ON u.id = m.user_id
GROUP BY m.id
ORDER BY -1*COUNT(l.id);

SELECT 
	m.id,
	m.filename AS 'медиа',
	mt.name_type AS 'тип медиа'
FROM media m
LEFT JOIN media_types mt ON mt.id = m.media_type_id
ORDER BY m.id;