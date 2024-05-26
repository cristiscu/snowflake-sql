-- test w/ MySQL at https://www.db-fiddle.com/
use test.employees;

CREATE TABLE products (id INT, name VARCHAR(100));
INSERT INTO products VALUES (1, 'soap'), (2, 'candles'), (3, 'niddles');

SELECT id * 10 as pid
FROM products
-- WHERE id * 10 >= 20
WHERE pid >= 20
GROUP BY pid
HAVING sum(pid) >= 20
ORDER BY pid;
