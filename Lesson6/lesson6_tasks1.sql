use lesson_4;

/* создание процедуры, которая решает следующую задачу
Выбрать для одного пользователя 5 пользователей в случайной комбинации, которые удовлетворяют хотя бы одному критерию:
1)	из одного города
2)	состоят в одной группе
3)	друзья друзей
*/

-- обновим данные в базе, чтобы появились пользователи из одного города
UPDATE profiles
SET hometown = 'Adriannaport'
WHERE birthday < '1990-01-01';

-- создание процедуры
DROP PROCEDURE IF EXISTS sp_friendship_offers;
DELIMITER //
CREATE PROCEDURE sp_friendship_offers(for_user_id BIGINT)
BEGIN
-- друзья
WITH friends AS (
	SELECT initiator_user_id AS id
    FROM friend_requests
    WHERE status = 'approved' AND target_user_id = for_user_id 
    UNION
    SELECT target_user_id 
    FROM friend_requests
    WHERE status = 'approved' AND initiator_user_id = for_user_id 
)
-- общий город
	SELECT p2.user_id
	FROM profiles p1
	JOIN profiles p2 ON p1.hometown = p2.hometown 
	WHERE p1.user_id = for_user_id AND p2.user_id <> for_user_id
    UNION 
-- состоят в одной группе
	SELECT uc2.user_id 
	FROM users_communities uc1
	JOIN users_communities uc2 ON uc1.community_id = uc2.community_id 
	WHERE uc1.user_id = for_user_id AND uc2.user_id <> for_user_id
-- друзья друзей
    UNION
	SELECT fr.initiator_user_id
    	FROM friends f
        JOIN friend_requests fr ON fr.target_user_id = f.id
	WHERE fr.initiator_user_id != for_user_id  AND fr.status = 'approved'
    UNION
    	SELECT fr.target_user_id
    	FROM  friends f
        JOIN  friend_requests fr ON fr.initiator_user_id = f.id 
	WHERE fr.target_user_id != for_user_id  AND status = 'approved'
	ORDER BY rand()
	LIMIT 5;
	
END//

DELIMITER ;

CALL sp_friendship_offers(1);