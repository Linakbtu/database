-- LAB 10 — Transactions & Isolation

DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS accounts;

CREATE TABLE accounts (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    balance DECIMAL(10,2) DEFAULT 0.00
);

CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    shop VARCHAR(100) NOT NULL,
    product VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL
);


INSERT INTO accounts (name, balance) VALUES
 ('Alice', 1000.00),
 ('Bob', 500.00),
 ('Wally', 750.00);

INSERT INTO products (shop, product, price) VALUES
 ('Joe''s Shop', 'Coke', 2.50),
 ('Joe''s Shop', 'Pepsi', 3.00);

-- TASK 1 — Basic transaction
-- Transfer 100 from Alice to Bob
BEGIN;
UPDATE accounts SET balance = balance - 100 WHERE name='Alice';
UPDATE accounts SET balance = balance + 100 WHERE name='Bob';
COMMIT;

-- a) Alice = 900, Bob = 600
-- b) Both updates must succeed together (atomic transfer)
-- c) Crash between updates = money lost (inconsistent)

-- Reset balances for next tasks
UPDATE accounts SET balance=1000 WHERE name='Alice';
UPDATE accounts SET balance=500 WHERE name='Bob';
UPDATE accounts SET balance=750 WHERE name='Wally';

-- TASK 2 — Using ROLLBACK
BEGIN;
UPDATE accounts SET balance = balance - 500 WHERE name='Alice';
-- a) Inside transaction → Alice = 500
ROLLBACK;
-- b) After rollback → Alice = 1000
-- c) Use rollback when update was wrong or business rule fails

-- TASK 3 — SAVEPOINT
BEGIN;
UPDATE accounts SET balance=balance-100 WHERE name='Alice'; -- 1000→900
SAVEPOINT sp;
UPDATE accounts SET balance=balance+100 WHERE name='Bob';   -- Bob 500→600
ROLLBACK TO sp; -- undo Bob credit
UPDATE accounts SET balance=balance+100 WHERE name='Wally'; -- Wally 750→850
COMMIT;
-- a) Alice=900, Bob=500, Wally=850
-- b) Bob was credited temporarily but rolled back
-- c) Savepoint undoes part of the work, not whole transaction

-- TASK 4 — READ COMMITTED vs SERIALIZABLE
TRUNCATE TABLE products;
INSERT INTO products(shop,product,price) VALUES
 ('Joe''s Shop','Coke',2.50),
 ('Joe''s Shop','Pepsi',3.00);

-- READ COMMITTED
-- T1: BEGIN ISOLATION LEVEL READ COMMITTED;
-- T1: SELECT → Coke, Pepsi
-- T2: DELETE Coke/Pepsi; INSERT Fanta; COMMIT
-- T1: SELECT → Fanta (new committed data)

-- SERIALIZABLE
-- T1: BEGIN ISOLATION LEVEL SERIALIZABLE; SELECT → Coke, Pepsi
-- T2 modifies and commits
-- T1 second SELECT → either same snapshot or serialization error

-- TASK 5 — Phantom read (REPEATABLE READ)
TRUNCATE TABLE products;
INSERT INTO products(shop,product,price) VALUES
 ('Joe''s Shop','Coke',2.50),
 ('Joe''s Shop','Pepsi',3.00);

-- T1: BEGIN REPEATABLE READ
-- T1: SELECT MAX/MIN = 3.00 / 2.50
-- T2: INSERT Sprite 4.00; COMMIT
-- T1: second SELECT may show MAX=4.00 (phantom row)
-- a) Yes, new row may appear
-- b) Phantom = new rows matching same WHERE appear between reads
-- c) Prevented by SERIALIZABLE

-- TASK 6 — Dirty read (READ UNCOMMITTED)
-- Theory level (Postgres treats as READ COMMITTED)
-- T1: BEGIN READ UNCOMMITTED
-- T2: UPDATE price=99.99 (no commit)
-- T1: SELECT → may see 99.99 (dirty)
-- T2: ROLLBACK
-- T1: SELECT → original value
-- a) Yes, T1 sees uncommitted → dangerous
-- b) Dirty read = read uncommitted data
-- c) Avoid in real apps

-- EXERCISE 1 — Safe transfer Bob→Wally 200
UPDATE accounts SET balance=500 WHERE name='Bob';
UPDATE accounts SET balance=750 WHERE name='Wally';

DO $$
DECLARE bal DECIMAL;
BEGIN
    SELECT balance INTO bal FROM accounts WHERE name='Bob' FOR UPDATE;
    IF bal < 200 THEN
        RAISE EXCEPTION 'Insufficient funds';
    END IF;
    UPDATE accounts SET balance=balance-200 WHERE name='Bob';
    UPDATE accounts SET balance=balance+200 WHERE name='Wally';
END $$;

-- EXERCISE 2 — Savepoints example
TRUNCATE TABLE products;
INSERT INTO products(shop,product,price) VALUES
 ('Joe''s Shop','Coke',2.50),
 ('Joe''s Shop','Pepsi',3.00);

BEGIN;
INSERT INTO products VALUES (DEFAULT,'Joe''s Shop','Fanta',3.50);
SAVEPOINT s1;
UPDATE products SET price=4.00 WHERE product='Fanta';
SAVEPOINT s2;
DELETE FROM products WHERE product='Fanta';
ROLLBACK TO s1;
COMMIT;
-- Final: Coke(2.5), Pepsi(3.0), Fanta(3.5)

-- EXERCISE 3 — Two withdrawals
-- READ COMMITTED with SELECT ... FOR UPDATE locks row
-- prevents double-withdraw
-- SERIALIZABLE may throw conflict error → must retry

-- EXERCISE 4 — MAX < MIN issue
TRUNCATE TABLE products;
INSERT INTO products(shop,product,price) VALUES
 ('ShopA','Item1',10),
 ('ShopA','Item2',20),
 ('ShopA','Item3',30);

-- No transactions:
-- User1: SELECT MAX=30
-- User2: DELETE rows; INSERT Item4=5
-- User1: SELECT MIN=5
-- Inconsistent: MAX from old, MIN from new

-- With transaction:
-- BEGIN SERIALIZABLE; SELECT MAX/MIN → consistent snapshot
-- prevents mixed results

-- SELF-ASSESSMENT 
-- 1 Atomic: all or none. Consistent: rules preserved. Isolated: no interference. Durable: survives crash.
-- 2 COMMIT saves changes, ROLLBACK cancels changes.
-- 3 Use SAVEPOINT to undo a part, not whole transaction.
-- 4 RU: dirty. RC: non-repeat. RR: phantom. SR: none.
-- 5 Dirty read = uncommitted data, allowed in RU.
-- 6 Non-repeatable = same SELECT gives different row values after commit.
-- 7 Phantom = new rows appear between reads, blocked by SR.
-- 8 RC = better performance, fewer conflicts than SR.
-- 9 Transactions keep data valid under concurrency.
--10 Uncommitted changes are discarded on crash.
