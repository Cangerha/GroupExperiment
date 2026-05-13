-- Active: 1775733622997@@127.0.0.1@3306@experiment

-- 1. 客户表
CREATE TABLE customers (
    c_id INT PRIMARY KEY AUTO_INCREMENT COMMENT '客户ID',
    c_name VARCHAR(50) NOT NULL COMMENT '客户姓名',
    c_phone VARCHAR(20) NOT NULL COMMENT '客户电话',
    c_address VARCHAR(200) COMMENT '地址',
    c_total_spent DECIMAL(10, 2) DEFAULT 0.00 COMMENT '累积消费'
) COMMENT '客户表';

-- 2. 商家表
CREATE TABLE shops (
    s_id INT PRIMARY KEY AUTO_INCREMENT COMMENT '商家ID',
    s_name VARCHAR(100) NOT NULL COMMENT '商家名称',
    s_phone VARCHAR(20) COMMENT '联系电话',
    s_address VARCHAR(200) COMMENT '商家地址'
) COMMENT '商家表';

-- 3. 菜品表
CREATE TABLE foods (
    f_id INT PRIMARY KEY AUTO_INCREMENT COMMENT '菜品ID',
    f_name VARCHAR(100) NOT NULL COMMENT '菜品名称',
    f_price DECIMAL(10, 2) NOT NULL COMMENT '单价',
    s_id INT NOT NULL COMMENT '所属商家ID',
    CONSTRAINT foods_fk_s_id FOREIGN KEY (s_id) REFERENCES shops (s_id) ON DELETE RESTRICT
) COMMENT '菜品表';

-- 4. 订单表
CREATE TABLE orders (
    o_id INT PRIMARY KEY AUTO_INCREMENT COMMENT '订单ID',
    o_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '下单时间',
    o_sum DECIMAL(10, 2) NOT NULL DEFAULT 0.00 COMMENT '订单总金额',
    c_id INT NOT NULL COMMENT '客户ID',
    s_id INT NOT NULL COMMENT '商家ID',
    CONSTRAINT orders_fk_c_id FOREIGN KEY (c_id) REFERENCES customers (c_id) ON DELETE RESTRICT,
    CONSTRAINT orders_fk_s_id FOREIGN KEY (s_id) REFERENCES shops (s_id) ON DELETE RESTRICT
) COMMENT '订单表';

-- 5. 订单明细表
CREATE TABLE order_details (
    od_id INT PRIMARY KEY AUTO_INCREMENT COMMENT '明细ID',
    o_id INT NOT NULL COMMENT '订单ID',
    f_id INT NOT NULL COMMENT '菜品ID',
    f_quantity INT NOT NULL CHECK (f_quantity > 0) COMMENT '数量',
    od_subtotal DECIMAL(10, 2) NOT NULL COMMENT '小计金额',
    CONSTRAINT order_details_fk_o_id FOREIGN KEY (o_id) REFERENCES orders (o_id) ON DELETE CASCADE,
    CONSTRAINT order_details_fk_f_id FOREIGN KEY (f_id) REFERENCES foods (f_id) ON DELETE RESTRICT
) COMMENT '订单明细表';