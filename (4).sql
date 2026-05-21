-- Active: 1775733622997@@127.0.0.1@3306@experiment

-- 4.1 创建订单维护表 order_maint_log
-- 记录orders表所有属性的新旧值，新增mod_datetime自动记录修改时间
CREATE TABLE order_maint_log (
    log_id INT PRIMARY KEY AUTO_INCREMENT COMMENT '日志唯一标识',
    -- 订单ID新旧值
    old_o_id INT COMMENT '原订单ID',
    new_o_id INT COMMENT '新订单ID',
    -- 下单时间新旧值
    old_o_time DATETIME COMMENT '原下单时间',
    new_o_time DATETIME COMMENT '新下单时间',
    -- 订单总金额新旧值
    old_o_sum DECIMAL(10, 2) COMMENT '原订单总金额',
    new_o_sum DECIMAL(10, 2) COMMENT '新订单总金额',
    -- 客户ID新旧值
    old_c_id INT COMMENT '原客户ID',
    new_c_id INT COMMENT '新客户ID',
    -- 商家ID新旧值
    old_s_id INT COMMENT '原商家ID',
    new_s_id INT COMMENT '新商家ID',
    -- 修改时间（自动填充当前时间）
    mod_datetime DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '记录修改时间'
) COMMENT '订单信息变更维护日志表';

--  4.2 创建订单更新后触发器
-- 当orders表执行UPDATE操作成功后，自动将变更信息写入维护日志表
CREATE TRIGGER tri_after_update_orders
AFTER UPDATE ON orders
FOR EACH ROW
BEGIN
    -- 完整记录更新前后所有字段的值
    INSERT INTO order_maint_log (
        old_o_id, new_o_id,
        old_o_time, new_o_time,
        old_o_sum, new_o_sum,
        old_c_id, new_c_id,
        old_s_id, new_s_id
    ) VALUES (
        OLD.o_id, NEW.o_id,
        OLD.o_time, NEW.o_time,
        OLD.o_sum, NEW.o_sum,
        OLD.c_id, NEW.c_id,
        OLD.s_id, NEW.s_id
    );
END

-- 测试
-- 查看维护日志表
SELECT * FROM order_maint_log;

-- 给最新的订单交易额加10000
UPDATE orders
SET
    o_sum = o_sum + 10000.00
WHERE
    o_id = (
        SELECT MAX(o_id)
        FROM (
                SELECT o_id
                FROM orders
            ) _
    );

-- 给最新的订单交易额减10000
UPDATE orders
SET
    o_sum = o_sum - 10000.00
WHERE
    o_id = (
        SELECT MAX(o_id)
        FROM (
                SELECT o_id
                FROM orders
            ) _
    );

-- 查看维护日志表
SELECT * FROM order_maint_log;