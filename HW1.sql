/* Задача 1
Создайте таблицу с мобильными телефонами, используя графический интерфейс. 
Необходимые поля таблицы: product_name (название товара), manufacturer (производитель), product_count (количество),
 price (цена). Заполните БД произвольными данными
*/
-- создание таблиц
CREATE SCHEMA `my1db`;

CREATE TABLE `my1db`.`cellphones` (
  `id_cell_phone` INT NOT NULL AUTO_INCREMENT,
  `product_name` VARCHAR(45) NOT NULL,
  ` manufacturer` VARCHAR(45) NULL,
  `product_count` INT NULL,
  `price` FLOAT NULL,
  PRIMARY KEY (`id_cell_phone`));
-- наполнение нужными данными
INSERT INTO `my1db`.`cellphones` (`id_cell_phone`, `product_name`, ` manufacturer`, `product_count`, `price`) 
VALUES ('1', 'Galaxy S2', 'Samsung', '200', '6000');
INSERT INTO `my1db`.`cellphones` (`id_cell_phone`, `product_name`, ` manufacturer`, `product_count`, `price`) 
VALUES ('2', 'iphone 11', 'Apple', '1', '50000');
INSERT INTO `my1db`.`cellphones` (`id_cell_phone`, `product_name`, ` manufacturer`, `product_count`, `price`) 
VALUES ('3', 'Redmi Note 8 2', 'Xiaomi', '300', '9000');
INSERT INTO `my1db`.`cellphones` (`id_cell_phone`, `product_name`, ` manufacturer`, `product_count`, `price`) 
VALUES ('4', 'BQ 6645L ELEMENT', 'BQ', '2', '7000');
INSERT INTO `my1db`.`cellphones` (`id_cell_phone`, `product_name`, ` manufacturer`, `product_count`, `price`) 
VALUES ('5', 'nova Y90', 'HUAWEI', '5', '11000');
INSERT INTO `my1db`.`cellphones` (`id_cell_phone`, `product_name`, ` manufacturer`, `product_count`, `price`) 
VALUES ('6', 'Galaxy A14', 'Samsung', '1', '16000');

/* Задача 2
Напишите SELECT-запрос, который выводит название товара, производителя и цену для товаров, 
количество которых превышает 2
*/
-- выборки данных
USE my1db;

SELECT product_name, manufacturer, price
FROM cellphones
WHERE product_count > 2;

/* Задача 3
Выведите SELECT-запросом весь ассортимент товаров марки “Samsung”
*/

SELECT *
FROM cellphones
WHERE manufacturer = 'Samsung';
