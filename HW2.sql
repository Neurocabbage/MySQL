/*Задача 1
Создать БД vk, исполнив скрипт _vk_db_creation.sql (в материалах к уроку)
*/ 

DROP DATABASE IF EXISTS vk;
CREATE DATABASE vk;
USE vk;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
	id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
    firstname VARCHAR(50),
    lastname VARCHAR(50) COMMENT 'Фамиль', -- COMMENT на случай, если имя неочевидное
    email VARCHAR(120) UNIQUE,
 	password_hash VARCHAR(100), -- 123456 => vzx;clvgkajrpo9udfxvsldkrn24l5456345t
	phone BIGINT UNSIGNED UNIQUE, 
	
    INDEX users_firstname_lastname_idx(firstname, lastname)
) COMMENT 'юзеры';

DROP TABLE IF EXISTS `profiles`;
CREATE TABLE `profiles` (
	user_id BIGINT UNSIGNED NOT NULL UNIQUE,
    gender CHAR(1),
    birthday DATE,
	photo_id BIGINT UNSIGNED NULL,
    created_at DATETIME DEFAULT NOW(),
    hometown VARCHAR(100)
	
    -- , FOREIGN KEY (photo_id) REFERENCES media(id) -- пока рано, т.к. таблицы media еще нет
);

ALTER TABLE `profiles` ADD CONSTRAINT fk_user_id
    FOREIGN KEY (user_id) REFERENCES users(id)
    ON UPDATE CASCADE -- (значение по умолчанию)
    ON DELETE RESTRICT; -- (значение по умолчанию)

DROP TABLE IF EXISTS messages;
CREATE TABLE messages (
	id SERIAL, -- SERIAL = BIGINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE
	from_user_id BIGINT UNSIGNED NOT NULL,
    to_user_id BIGINT UNSIGNED NOT NULL,
    body TEXT,
    created_at DATETIME DEFAULT NOW(), -- можно будет даже не упоминать это поле при вставке

    FOREIGN KEY (from_user_id) REFERENCES users(id),
    FOREIGN KEY (to_user_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS friend_requests;
CREATE TABLE friend_requests (
	-- id SERIAL, -- изменили на составной ключ (initiator_user_id, target_user_id)
	initiator_user_id BIGINT UNSIGNED NOT NULL,
    target_user_id BIGINT UNSIGNED NOT NULL,
    `status` ENUM('requested', 'approved', 'declined', 'unfriended'), # DEFAULT 'requested',
    -- `status` TINYINT(1) UNSIGNED, -- в этом случае в коде хранили бы цифирный enum (0, 1, 2, 3...)
	requested_at DATETIME DEFAULT NOW(),
	updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP, -- можно будет даже не упоминать это поле при обновлении
	
    PRIMARY KEY (initiator_user_id, target_user_id),
    FOREIGN KEY (initiator_user_id) REFERENCES users(id),
    FOREIGN KEY (target_user_id) REFERENCES users(id)-- ,
    -- CHECK (initiator_user_id <> target_user_id)
);
-- чтобы пользователь сам себе не отправил запрос в друзья
-- ALTER TABLE friend_requests 
-- ADD CHECK(initiator_user_id <> target_user_id);

DROP TABLE IF EXISTS communities;
CREATE TABLE communities(
	id SERIAL,
	name VARCHAR(150),
	admin_user_id BIGINT UNSIGNED NOT NULL,
	
	INDEX communities_name_idx(name), -- индексу можно давать свое имя (communities_name_idx)
	FOREIGN KEY (admin_user_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS users_communities;
CREATE TABLE users_communities(
	user_id BIGINT UNSIGNED NOT NULL,
	community_id BIGINT UNSIGNED NOT NULL,
  
	PRIMARY KEY (user_id, community_id), -- чтобы не было 2 записей о пользователе и сообществе
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (community_id) REFERENCES communities(id)
);

DROP TABLE IF EXISTS media_types;
CREATE TABLE media_types(
	id SERIAL,
    name VARCHAR(255), -- записей мало, поэтому в индексе нет необходимости
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS media;
CREATE TABLE media(
	id SERIAL,
    media_type_id BIGINT UNSIGNED NOT NULL,
    user_id BIGINT UNSIGNED NOT NULL,
  	body text,
    filename VARCHAR(255),
    -- file BLOB,    	
    size INT,
	metadata JSON,
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (media_type_id) REFERENCES media_types(id)
);

DROP TABLE IF EXISTS likes;
CREATE TABLE likes(
	id SERIAL,
    user_id BIGINT UNSIGNED NOT NULL,
    media_id BIGINT UNSIGNED NOT NULL,
    created_at DATETIME DEFAULT NOW()

    -- PRIMARY KEY (user_id, media_id) – можно было и так вместо id в качестве PK
  	-- слишком увлекаться индексами тоже опасно, рациональнее их добавлять по мере необходимости (напр., провисают по времени какие-то запросы)  

/* намеренно забыли, чтобы позднее увидеть их отсутствие в ER-диаграмме
    , FOREIGN KEY (user_id) REFERENCES users(id)
    , FOREIGN KEY (media_id) REFERENCES media(id)
*/
);

ALTER TABLE vk.likes 
ADD CONSTRAINT likes_fk 
FOREIGN KEY (media_id) REFERENCES vk.media(id);

ALTER TABLE vk.likes 
ADD CONSTRAINT likes_fk_1 
FOREIGN KEY (user_id) REFERENCES vk.users(id);

ALTER TABLE vk.profiles 
ADD CONSTRAINT profiles_fk_1 
FOREIGN KEY (photo_id) REFERENCES media(id);

/*Задача 2
Написать скрипт, добавляющий в созданную БД vk 2-3 новые таблицы (с перечнем полей, указанием индексов и внешних ключей) 
(CREATE TABLE)
*/ 
-- таблица плейлистов
DROP TABLE IF EXISTS playlists;
CREATE TABLE playlists (
	id SERIAL,
	title varchar(200),
    user_id BIGINT UNSIGNED NOT NULL,

    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- таблица звукозаписей
DROP TABLE IF EXISTS sound_records;
CREATE TABLE sound_records (
	id SERIAL,
	playlist_id BIGINT unsigned,
	media_id BIGINT unsigned NOT NULL,

	FOREIGN KEY (playlist_id) REFERENCES playlists(id),
    FOREIGN KEY (media_id) REFERENCES media(id)
);

-- таблица друзей
DROP TABLE IF EXISTS friends;
CREATE TABLE friends (
	id SERIAL,
	user_id BIGINT UNSIGNED NOT NULL,
    request_id BIGINT UNSIGNED,
    relations_status varchar(200),
    
	FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (request_id) REFERENCES friend_requests(initiator_user_id)
);

/*
3. Заполнить 2 таблицы БД vk данными (по 10 записей в каждой таблице) (INSERT)
*/
INSERT INTO `users` VALUES 
(21,'Elissa','Corkery','leslie.osinski@example.net','cd3eaa8f21091e81f74fa3c68ee1f1f4030b4e49',1),
(25,'Frank','Cartwright','cschuppe@example.com','4af8dd5c460627149103ce95f05c3f8355029ee6',582055),
(26,'Yolanda','Wisoky','jlynch@example.net','c567a420a51d339c665cbf5cabe2a73924c3fd30',195340),
(27,'Harvey','Quigley','jana.osinski@example.com','1a647d683c5a7cdc1cb19760c51e74bb10579850',239),
(28,'Barton','Wehner','bennie71@example.org','7a95bd84a34df943ada8957d5f43500a92b812d7',270868),
(29,'Sim','Jacobi','freilly@example.com','298466ffe5ee2d4d2115ac6fcbe1986ee0b29c75',814),
(30,'Caterina','Torp','rossie.crooks@example.com','ba568795489aa1e01b8875f237df814d6c4215b1',0),
(31,'Nadia','Hills','sjast@example.net','7c37aabe1609b782e448702cdcbeebf1dc3544da',973),
(32,'Alda','Fritsch','runolfsdottir.lydia@example.com','5fdf735d72cd527c9108904b9fbb9ed76c4998da',102),
(36,'Lucie','Brakus','vcronin@example.org','2f8e65134d1dd7a2f491d3aff88573d03be3c77e',209);

INSERT INTO `communities` VALUES 
(1,'cupiditate',21),
(2,'laudantium',25),
(3,'nostrum',26),
(4,'accusantium',27),
(5,'veniam',28),
(6,'sequi',29),
(7,'voluptatum',30),
(8,'et',31),
(9,'consectetur',32),
(10,'fugiat',36);

