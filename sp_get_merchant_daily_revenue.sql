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
