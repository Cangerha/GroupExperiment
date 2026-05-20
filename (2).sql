-- Active: 1775733622997@@127.0.0.1@3306@experiment

-- 为客户表添加总消费额字段
ALTER TABLE customers
ADD COLUMN c_total_spent DECIMAL(10, 2) DEFAULT 0.00 COMMENT '总消费额';

-- 根据生成的订单更新客户总消费额
UPDATE customers
SET
    c_total_spent = (
        SELECT SUM(o_sum)
        FROM orders
        WHERE
            orders.c_id = customers.c_id
    )
WHERE
    c_id IN (
        SELECT c_id
        FROM orders
    );

-- 触发器：当订单表中插入新订单时，更新客户表中相应客户的总消费金额
CREATE TRIGGER tri_update_total_spent
AFTER INSERT ON orders
FOR EACH ROW
BEGIN
UPDATE customers
SET
    c_total_spent = c_total_spent + NEW.o_sum
WHERE
    c_id = NEW.c_id;
END

-- 测试触发器
-- 查看总消费额
SELECT c_total_spent FROM customers WHERE c_id = 10000001;

-- 发生交易
INSERT INTO
    orders (o_sum, c_id, s_id) VALUE (46.00, 10000001, 10000019);

INSERT INTO
    order_details (o_id, f_id, od_quantity) VALUE (
        (
            SELECT MAX(o_id)
            FROM orders
        ),
        1,
        1
    );

-- 查看总消费额
SELECT c_total_spent FROM customers WHERE c_id = 10000001;