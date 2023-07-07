USE lesson_4;

DROP TABLE IF EXISTS tbl_friends;
CREATE TEMPORARY TABLE tbl_friends
SELECT initiator_user_id AS user_id, target_user_id AS friend_id FROM lesson_4.friend_requests 
WHERE  status='approved' -- ID друзей, заявку которых подтвердили
UNION
SELECT target_user_id, initiator_user_id FROM  lesson_4.friend_requests  
WHERE  status='approved'; -- ID друзей, подтвердивших заявку

SELECT friend_id, user_id FROM tbl_friends
WHERE user_id=1;

-- ОБЩЕЕ ТАБЛИЧНОЕ ВЫРАЖЕНИЕ
WITH friends AS  
(SELECT initiator_user_id AS user_id, target_user_id AS friend_id FROM lesson_4.friend_requests 
WHERE  status='approved' -- ID друзей, заявку которых подтвердили
UNION
SELECT target_user_id, initiator_user_id FROM  lesson_4.friend_requests  
WHERE  status='approved') -- ID друзей, подтвердивших заявку

SELECT friend_id FROM friends
WHERE user_id=1;

-- С помощью СТЕ реализуйте таблицу квадратов чисел от 1 до 10
WITH RECURSIVE cte AS
(
	SELECT 1 AS a, 1 as result
	UNION ALL
	SELECT a + 1, pow(a+1,2) as result FROM cte
	WHERE a < 10
)
SELECT a, result FROM cte;

CREATE OR REPLACE VIEW v_friends AS  
(
SELECT initiator_user_id AS user_id, target_user_id AS friend_id FROM lesson_4.friend_requests 
WHERE  status='approved' -- ID друзей, заявку которых подтвердили
UNION
SELECT target_user_id, initiator_user_id FROM  lesson_4.friend_requests  
WHERE  status='approved'
); -- ID друзей, подтвердивших заявку

SELECT * FROM v_friends;


CREATE OR REPLACE VIEW user_1_m AS  
(
	SELECT 
		body as 'Сообщения' FROM messages
		WHERE from_user_id = '1'
	UNION
	SELECT 
		body as 'Сообщения' FROM messages
		WHERE to_user_id = '1'
);

SELECT * from user_1_m;

WITH friends AS  
(SELECT initiator_user_id AS user_id, target_user_id AS friend_id FROM lesson_4.friend_requests 
WHERE  status='approved' -- ID друзей, заявку которых подтвердили
UNION
SELECT target_user_id, initiator_user_id FROM  lesson_4.friend_requests  
WHERE  status='approved') -- ID друзей, подтвердивших заявку

SELECT user_id, friend_id FROM friends
WHERE user_id=1;

CREATE OR REPLACE VIEW v_friends AS  
(SELECT initiator_user_id AS user_id, target_user_id AS friend_id FROM lesson_4.friend_requests 
WHERE  status='approved' -- ID друзей, заявку которых подтвердили
UNION
SELECT target_user_id, initiator_user_id FROM  lesson_4.friend_requests  
WHERE  status='approved'); -- ID друзей, подтвердивших заявку

SELECT user_id, friend_id FROM v_friends
WHERE user_id=1;

CREATE OR REPLACE VIEW v_friends_friends AS
WITH friends AS (
	SELECT initiator_user_id AS id
    FROM lesson_4.friend_requests
    WHERE status = 'approved' AND target_user_id = 1 
    UNION
    SELECT target_user_id AS id
    FROM lesson_4.friend_requests
    WHERE status = 'approved' AND initiator_user_id = 1 
)
SELECT fr.initiator_user_id AS friend_id
FROM friends f
JOIN lesson_4.friend_requests fr ON fr.target_user_id = f.id
WHERE fr.initiator_user_id != 1  AND fr.status = 'approved'
UNION
SELECT fr.target_user_id
FROM  friends f
JOIN  lesson_4.friend_requests fr ON fr.initiator_user_id = f.id 
WHERE fr.target_user_id != 1  AND status = 'approved';

SELECT user_id, friend_id FROM v_friends_friends;

SELECT fr.initiator_user_id AS friend_id
FROM v_friends f
JOIN lesson_4.friend_requests fr ON fr.target_user_id = f.friend_id
WHERE fr.initiator_user_id != 1 AND f.user_id=1  AND fr.status = 'approved'
UNION
SELECT fr.target_user_id
FROM  v_friends f
JOIN  lesson_4.friend_requests fr ON fr.initiator_user_id = f.friend_id 
WHERE fr.target_user_id != 1  AND f.user_id=1 AND  status = 'approved';
