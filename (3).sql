-- Active: 1775733622997@@127.0.0.1@3306@experiment

--触发器：当某日商户营业额超过10000元时，阻止加入新的外卖订单
CREATE TRIGGER tri_transaction_limitation
BEFORE INSERT ON orders
FOR EACH ROW
BEGIN
IF (SELECT SUM(o_sum) FROM orders WHERE DATE(o_time)=CURDATE() AND s_id=NEW.s_id)>10000
THEN
SIGNAL SQLSTATE '45000'
SET
    MESSAGE_TEXT = '该商户当日交易额超过已10000,该笔交易订单被阻止';
END IF;
END

-- 测试触发器
-- 加入一笔交易额为10001.00的订单
INSERT INTO
    orders (o_sum, c_id, s_id)
VALUES (10001.00, 10000001, 10000001);

-- 查看该商户当日交易额
SELECT SUM(o_sum), CURDATE(), s_id
FROM orders
WHERE
    DATE(o_time) = CURDATE()
    AND s_id = 10000001;

-- 尝试添加订单
INSERT INTO
    orders (o_sum, c_id, s_id)
VALUES (1.00, 10000001, 10000001);

-- 删除该测试订单
DELETE FROM orders
WHERE
    o_id = (
        SELECT MAX(o_id)
        FROM (
                SELECT o_id
                FROM orders
            ) _
    );

-- 复原客户消费额
UPDATE customers
SET
    c_total_spent = c_total_spent -10001
WHERE
    c_id = 10000001;