-- Active: 1775733622997@@127.0.0.1@3306@experiment

-- 为customers表插入20行数据
CREATE PROCEDURE InsertCustomers()
BEGIN
    DECLARE i INT;
    SET i = 1;
    WHILE i <= 20 DO
        INSERT INTO customers (c_id,c_name,c_phone,c_address) 
        VALUES (
            CONCAT('100000',LPAD(i, 2, '0')),
            CONCAT('用户',LPAD(i, 2, '0')),
            CONCAT('136000011', LPAD(i, 2, '0')), 
            CONCAT('海礼1', LPAD(i, 2, '0'))
        );
        SET i = i + 1;
    END WHILE;
END

CALL InsertCustomers ();

-- 为shops表插入20行数据
CREATE PROCEDURE InsertShops()
BEGIN
    DECLARE i INT;
    SET i = 1;
    WHILE i <= 20 DO
        INSERT INTO shops (s_id,s_name,s_phone,s_address)
        VALUES (
            CONCAT('100000',LPAD(i, 2, '0')),
            CONCAT('商家',LPAD(i, 2, '0')),
            CONCAT('158000010', LPAD(i, 2, '0')), 
            CONCAT('海大路', LPAD(i, 2, '0'),'号')
        );
        SET i = i + 1;
    END WHILE;
END

CALL InsertShops ();

-- 为foods表插入20行数据
CREATE PROCEDURE InsertFoods()
BEGIN
    DECLARE i INT;
    SET i = 1;
    WHILE i <= 20 DO
        INSERT INTO foods (f_id,f_name,f_price,s_id)
        VALUES (
            LPAD(i, 2, '0'),
            CONCAT('菜品',LPAD(i, 2, '0')),
            ROUND(RAND() * (50 - 10) + 10), 
            CONCAT('100000',LPAD(ROUND(RAND() * 19 + 1), 2, '0'))
        );
        SET i = i + 1;
    END WHILE;
END

CALL InsertFoods ();

-- 为orders表插入20行的id，客户id，与商户id
CREATE PROCEDURE InsertOrders()
BEGIN
    DECLARE i INT;
    SET i = 1;
    WHILE i <= 20 DO
        INSERT INTO orders (o_id,c_id,s_id)
        VALUES (
            LPAD(i, 2, '0'),
            CONCAT('100000',LPAD(ROUND(RAND() * 19 + 1), 2, '0')),
            CONCAT('100000',LPAD(ROUND(RAND() * 19 + 1), 2, '0'))
        );
        SET i = i + 1;
    END WHILE;
END

CALL InsertOrders ();

-- 为order_details表插入20行数据
CREATE PROCEDURE InsertOrderDetails()
BEGIN
    DECLARE i INT;
    DECLARE food_id INT;
    DECLARE quantity INT;

    SET i = 1;
    SET food_id=0;
    SET quantity=0;

    WHILE i <= 20 DO
        SET food_id=ROUND(RAND() * 19 + 1);
        SET quantity=ROUND(RAND() * 2 + 1);
        INSERT INTO order_details (od_id,o_id,f_id,od_quantity,od_subtotal)
        VALUES (
            i,
            i,
            food_id,
            quantity,
            quantity*(SELECT f_price FROM foods WHERE f_id=food_id)
        );
        SET i = i + 1;
    END WHILE;
END

CALL InsertOrderDetails ();

-- 根据生成的订单更新客户总消费额
UPDATE customers
SET
    c_total_spent = (
        SELECT SUM(o_sum)
        FROM orders
        WHERE
            orders.c_id = customers.c_id
    );

-- 根据生成的订单明细计算订单总金额
UPDATE orders
SET
    o_sum = (
        SELECT SUM(od_subtotal)
        FROM order_details
        WHERE
            order_details.o_id = orders.o_id
    );