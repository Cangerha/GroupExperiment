-- Active: 1775733622997@@127.0.0.1@3306@experiment

-- 创建商户日营收表
CREATE TABLE shop_day_revenue (
    sdr_id INT PRIMARY KEY AUTO_INCREMENT COMMENT '日营收记录ID',
    sdr_date DATE COMMENT '日期',
    s_id INT COMMENT '商家ID',
    sdr_revenue DECIMAL(10, 2) DEFAULT 0.00 COMMENT '当日营收'
) COMMENT '商家日营收表';

-- 根据前有数据同步日营收表
INSERT INTO
    shop_day_revenue (sdr_date, s_id, sdr_revenue)
SELECT DATE(o_time) AS sdr_date, s_id, SUM(o_sum) AS sdr_revenue
FROM orders
GROUP BY
    DATE(o_time),
    s_id;

-- 触发器：产生订单时，更新商户当日营收
CREATE TRIGGER tri_update_day_revenue
AFTER INSERT ON orders
FOR EACH ROW
BEGIN
IF EXISTS (SELECT sdr_id FROM shop_day_revenue WHERE sdr_date=DATE(NEW.o_time) AND s_id=NEW.s_id)
THEN 
UPDATE shop_day_revenue SET sdr_revenue=sdr_revenue+NEW.o_sum WHERE sdr_date = DATE(NEW.o_time) AND s_id = NEW.s_id;
ELSE
INSERT INTO shop_day_revenue (sdr_date,s_id,sdr_revenue) VALUE (DATE(NEW.o_time),NEW.s_id,NEW.o_sum);
END IF;
END

--触发器：当某日商户营业额超过10000元时，阻止加入新的外卖订单
CREATE TRIGGER tri_transaction_limitation
BEFORE INSERT ON orders
FOR EACH ROW
BEGIN
IF (SELECT sdr_revenue FROM shop_day_revenue WHERE sdr_date=DATE(NEW.o_time) AND s_id=NEW.s_id)>10000
THEN
SIGNAL SQLSTATE '45000'
SET
    MESSAGE_TEXT = '该商户当日交易额超过已10000,该笔交易订单被阻止';
END IF;
END

-- 测试触发器
INSERT INTO
    orders (o_sum, c_id, s_id)
VALUES (10001.00, 10000001, 10000001);

SELECT *
FROM shop_day_revenue
WHERE
    sdr_id = (
        SELECT MAX(sdr_id)
        FROM shop_day_revenue
    );

INSERT INTO
    orders (o_sum, c_id, s_id)
VALUES (1.00, 10000001, 10000001);