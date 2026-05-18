ELIMITER //

CREATE PROCEDURE GetShopDailySales(
    IN shop_id VARCHAR(20),           -- IN：商户ID
    OUT total_trade DECIMAL(10, 2)    -- OUT：当日营业额
)
BEGIN
    -- 查询指定商户当天的所有订单总金额
    SELECT IFNULL(SUM(o_sum), 0.00) INTO total_trade
    FROM orders
    WHERE s_id = shop_id 
      AND DATE(o_time) = CURDATE();
    
    -- 显示信息EXTRA
    SELECT 
        shop_id AS '商户ID',
        CURDATE() AS '查询日期',
        total_trade AS '当日营业额';
END //

DELIMITER ;






-- 测试数据
-- 商户 10000001 的订单
INSERT INTO orders (o_id, c_id, s_id, o_sum, o_time)
VALUES 
    (21, '10000001', '10000001', 150.00, NOW()),
    (22, '10000002', '10000001', 200.00, NOW()),
    (23, '10000003', '10000001', 180.00, NOW());




-- 查询商户 10000001 的当日营业额
SET @total_trade = 0;
CALL GetShopDailySales('10000001', @total_trade);
SELECT @total_trade;  