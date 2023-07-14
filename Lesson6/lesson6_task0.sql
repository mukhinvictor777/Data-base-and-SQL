USE lesson_4;

-- ТРАНЗАКЦИИ 

START TRANSACTION;

INSERT INTO users (firstname, lastname, email)
VALUES ('Дмитрий', 'Дмитриев', 'dima2@mail.ru');
	
SET @last_user_id = last_insert_id();
	
INSERT INTO profiles (user_id, hometown, birthday, photo_id)
VALUES (@last_user_id, 'Moscow', '1999-10-10', NULL);

COMMIT;
-- ROLLBACK;

-- ПРОЦЕДУРЫ

-- создание процедуры для добавления нового пользователя с профилем c определение COMMIT или ROLLBACK 
DROP PROCEDURE IF EXISTS sp_user_add;
DELIMITER //
CREATE PROCEDURE sp_user_add(
firstname varchar(100), lastname varchar(100), email varchar(100), 
phone varchar(100), hometown varchar(50), photo_id INT, birthday DATE,
OUT  tran_result varchar(100))
BEGIN
	
	DECLARE `_rollback` BIT DEFAULT b'0';
	DECLARE code varchar(100);
	DECLARE error_string varchar(100); 

	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
	BEGIN
 		SET `_rollback` = b'1';
 		GET stacked DIAGNOSTICS CONDITION 1
			code = RETURNED_SQLSTATE, error_string = MESSAGE_TEXT;
	END;

	START TRANSACTION;
	 INSERT INTO users (firstname, lastname, email)
	 VALUES (firstname, lastname, email);
	-- SET @last_user_id = last_insert_id();
	 INSERT INTO profiles (user_id, hometown, birthday, photo_id)
	 VALUES (last_insert_id(), hometown, birthday, photo_id);
	
	IF `_rollback` THEN
		SET tran_result = CONCAT('УПС. Ошибка: ', code, ' Текст ошибки: ', error_string);
		ROLLBACK;
	ELSE
		SET tran_result = 'OK';
		COMMIT;
	END IF;
END//
DELIMITER ;

-- вызов процедуры
CALL sp_user_add('New', 'User', 'new_user1@mail.com', 9110001122, 'Moscow', '1', '1998-01-01', @tran_result); 
SELECT @tran_result;