use lesson_4;

DROP FUNCTION IF EXISTS friendship_direction;
DELIMITER //
CREATE FUNCTION friendship_direction(check_user_id BIGINT)
RETURNS FLOAT READS SQL DATA
begin
	DECLARE requests_to_user INT; -- заявок к пользователю
	DECLARE requests_from_user INT; -- заявок от пользователя

	set requests_to_user = (
		SELECT count(*)
        from friend_requests
        where target_user_id = check_user_id
    );
	
	SET requests_from_user = (
	SELECT COUNT(*) 
	FROM friend_requests
	WHERE initiator_user_id = check_user_id 
	); 
	/*
	SELECT COUNT(*)
	INTO  requests_from_user
	FROM friend_requests
	WHERE initiator_user_id = check_user_id; 
	*/
	RETURN requests_to_user / requests_from_user;
END//
DELIMITER ;

-- вызов функции
SELECT friendship_direction(1);
SELECT truncate(friendship_direction(1), 2)*100 AS `user popularity`;

-- ЦИКЛЫ
ALTER TABLE `profiles`
ADD COLUMN time_update DATETIME ON UPDATE NOW();

DROP PROCEDURE IF EXISTS sp_data_analysis;
DELIMITER //
CREATE PROCEDURE sp_data_analysis(start_date DATE)
BEGIN
	DECLARE id_max_users INT;
	DECLARE count_find INT;
	
	SET id_max_users = (SELECT MAX(user_id) FROM profiles);
	WHILE (id_max_users > 0) DO
		BEGIN
			SET count_find = (SELECT COUNT(*) FROM profiles WHERE user_id = id_max_users AND birthday > start_date); 
			IF (count_find>0 )	THEN 
				UPDATE profiles
					SET birthday=NOW()
				WHERE user_id=id_max_users; 
			END IF;
	    	SET id_max_users = id_max_users - 1;
    	END;
  	END WHILE;
END//

DELIMITER ;

-- вызов процедуры
CALL sp_data_analysis('2020-01-01');


-- ТРИГГЕРЫ 
-- триггер для корректировки возраста пользователя при вставке новых строк
DROP TRIGGER if exists check_user_age_before_insert;
DELIMITER //
CREATE TRIGGER check_user_age_before_insert BEFORE INSERT ON profiles
FOR EACH ROW
BEGIN
    IF NEW.birthday > CURRENT_DATE() THEN
        SET NEW.birthday = CURRENT_DATE();
    END IF;
END//
DELIMITER ;

-- триггер для проверки возраста пользователя перед обновлением
DELIMITER //
CREATE TRIGGER check_user_age_before_update BEFORE UPDATE ON profiles
FOR EACH ROW
BEGIN
    IF NEW.birthday > NOW() THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Обновление отменено. Дата рождения не может быть больше текущей даты!';
    END IF;
END//
DELIMITER ;

SELECT u.id, u.firstname, u. lastname, p.birthday FROM users u
INNER JOIN profiles p ON u.id=p.user_id
ORDER BY u.id DESC;

