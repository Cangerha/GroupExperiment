-- Active: 1775733622997@@127.0.0.1@3306@experiment

-- 存储过程：执行时通过输入某商店id，为该商店生成3-5份测试菜品
CREATE PROCEDURE CreateTestFoods (IN shop_id INT)
BEGIN
    DECLARE num INT;
    DECLARE i INT;

    -- 检查商户是否存在
    IF NOT EXISTS (SELECT s_id FROM shops WHERE s_id = shop_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '商户不存在';
    END IF;

    SET num=(ROUND(RAND()*2+3));
    SET i=0;
    WHILE i<num DO
        INSERT INTO foods (f_name,f_price,s_id) VALUES ('测试菜品',ROUND(RAND() * (50 - 10) + 10),shop_id);
        SET i=i+1;
    END WHILE;

    -- 查看结果
    SELECT * FROM foods WHERE s_id=shop_id;
END

-- 测试
-- 对存在的商户进行测试
CALL CreateTestFoods ('10000001');

-- 对不存在的商户进行测试
CALL CreateTestFoods ('11110000');