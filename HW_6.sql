/*
1. Написать функцию, которая удаляет всю информацию об указанном пользователе из БД vk. 
Пользователь задается по id. Удалить нужно все сообщения, лайки, медиа записи, профиль 
и запись из таблицы users. Функция должна возвращать номер пользователя.
*/

USE vk;
DROP FUNCTION IF EXISTS delete_user;
DELIMITER //

CREATE FUNCTION delete_user (user_to_delete int)
RETURNS INT DETERMINISTIC
BEGIN	
	DELETE FROM profiles
    WHERE user_id = user_to_delete;

	DELETE FROM media
    WHERE user_id = user_to_delete;

	DELETE FROM messages
    WHERE from_user_id = user_to_delete;
    
    DELETE FROM likes
    WHERE user_id = user_to_delete;
    
	DELETE FROM friend_requests
	WHERE  user_to_delete = initiator_user_id OR user_to_delete = target_user_id;
    
    DELETE FROM users_communities
	WHERE user_to_delete = user_id;
    
	DELETE FROM users
	WHERE id = user_to_delete;
	  
    RETURN user_to_delete;
END//
DELIMITER ;

SELECT delete_user(17);

/*
2. Предыдущую задачу решить с помощью процедуры и обернуть используемые команды в транзакцию внутри процедуры.
*/

DROP PROCEDURE IF EXISTS deleting_user;
DELIMITER //
CREATE PROCEDURE deleting_user (user_to_delete int)
BEGIN
  START TRANSACTION;
	DELETE FROM profiles
    WHERE user_id = user_to_delete;

	DELETE FROM media
    WHERE user_id = user_to_delete;

	DELETE FROM messages
    WHERE from_user_id = user_to_delete;
    
    DELETE FROM likes
    WHERE user_id = user_to_delete;
    
	DELETE FROM friend_requests
	WHERE  user_to_delete = initiator_user_id OR user_to_delete = target_user_id;
    
    DELETE FROM users_communities
	WHERE user_to_delete = user_id;
    
	DELETE FROM users
	WHERE id = user_to_delete;
	  
COMMIT;
END //
DELIMITER ;

CALL deleting_user(18);