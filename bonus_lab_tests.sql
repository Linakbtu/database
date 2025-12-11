-- TESTS: process_transfer

-- 1. Успешный перевод KZT -> KZT (должен пройти без ошибок)
CALL process_transfer(
    'KZ09601A241001007211',   -- from: Патима (KZT)
    'KZ108562203116592437',   -- to: Санжар (KZT)
    1000.00,
    'KZT',
    'OK test transfer'
);

-- 2. Ошибка: ERR_INVALID_AMOUNT (сумма <= 0)
-- ожидаем исключение: ERR_INVALID_AMOUNT
CALL process_transfer(
    'KZ09601A241001007211',
    'KZ108562203116592437',
    0.00,
    'KZT',
    'Invalid amount test'
);

-- 3. Ошибка: ERR_FROM_ACCOUNT_NOT_FOUND (несуществующий счет отправителя)
-- ожидаем исключение: ERR_FROM_ACCOUNT_NOT_FOUND
CALL process_transfer(
    'KZ000000000000000000',   -- несуществующий account_number
    'KZ108562203116592437',
    1000.00,
    'KZT',
    'From account not found test'
);

-- 4. Ошибка: ERR_INSUFFICIENT_FUNDS (недостаточно средств)
-- используем USD-счет с нулевым балансом
-- ожидаем исключение: ERR_INSUFFICIENT_FUNDS
CALL process_transfer(
    'KZ766018861000253591',   -- from: USD с 0.00
    'KZ28601A121003538381',   -- to: другой USD
    100.00,
    'USD',
    'Insufficient funds test'
);

-- 5. Ошибка: ERR_DAILY_LIMIT_EXCEEDED (превышен дневной лимит)
-- сначала выставляем маленький дневной лимит клиенту Патимы
UPDATE customers
SET daily_limit_kzt = 5000
WHERE customer_id = 3;        -- Патима

-- ожидаем исключение: ERR_DAILY_LIMIT_EXCEEDED
CALL process_transfer(
    'KZ09601A241001007211',   -- from: Патима (KZT)
    'KZ108562203116592437',   -- to: Санжар (KZT)
    6000.00,                  -- сумма > daily_limit_kzt
    'KZT',
    'Daily limit exceeded test'
);

-- можно вернуть лимит обратно в 0 (безлимитный режим)
UPDATE customers
SET daily_limit_kzt = 0
WHERE customer_id = 3;


-- TESTS: process_salary_batch
-- 6. Успешный зарплатный батч (частичный успех: 2 ок, 1 ошибочный IIN)
CALL process_salary_batch(
    'KZ5396502F0015686412',   -- company account (KZT, большой баланс)
    '[
        {"iin": "070422603234", "amount": 100000, "description": "Lina salary"},
        {"iin": "001120500951", "amount": 120000, "description": "Sanzhar salary"},
        {"iin": "999999999999", "amount": 50000,  "description": "Wrong IIN test"}
     ]'::jsonb,
    NULL, NULL, NULL
);

-- проверяем результат батча
SELECT *
FROM salary_batch_log
ORDER BY batch_id DESC
LIMIT 3;

-- 7. Ошибка: ERR_INVALID_INPUT (p_payments не массив JSONB)
-- ожидаем исключение: ERR_INVALID_INPUT: payments must be JSONB array
CALL process_salary_batch(
    'KZ5396502F0015686412',
    '{"iin": "070422603234", "amount": 100000}'::jsonb,  -- не массив, а объект
    NULL, NULL, NULL
);

-- 8. Ошибка: ERR_INSUFFICIENT_FUNDS по батчу
-- делаем сумму батча существенно больше баланса (две выплаты по 1 млрд KZT)
-- ожидаем исключение: ERR_INSUFFICIENT_FUNDS: balance=..., batch=...
CALL process_salary_batch(
    'KZ5396502F0015686412',
    '[
        {"iin": "070422603234", "amount": 1000000000, "description": "Huge salary 1"},
        {"iin": "001120500951", "amount": 1000000000, "description": "Huge salary 2"}
     ]'::jsonb,
    NULL, NULL, NULL
);


-- EXPLAIN ANALYZE: проверки индексов

-- 9. EXPLAIN: поиск счета по account_number (использует idx_acc_num_btree)
EXPLAIN ANALYZE
SELECT *
FROM accounts
WHERE account_number = 'KZ09601A241001007211';

-- 10. EXPLAIN: поиск клиента по email с lower(email) (использует idx_customers_email_lower)
EXPLAIN ANALYZE
SELECT *
FROM customers
WHERE lower(email) = lower('lina.kaldanova@gmail.com');

-- 11. EXPLAIN: выборка транзакций по from_account_id + status + type + created_at
-- должен использовать составной индекс idx_transactions_from_status_type_created_inc
EXPLAIN ANALYZE
SELECT *
FROM transactions
WHERE from_account_id = 3
  AND status = 'completed'
  AND type = 'transfer'
ORDER BY created_at DESC;

-- 12. EXPLAIN: поиск по audit_log.table_name (hash-индекс) и JSONB (GIN-индекс)
EXPLAIN ANALYZE
SELECT *
FROM audit_log
WHERE table_name = 'process_transfer'
  AND (old_values || new_values) @> '{"code": "ERR_INVALID_AMOUNT"}'::jsonb;
