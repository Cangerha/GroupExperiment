-- Active: 1775733622997@@127.0.0.1@3306@experiment

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