create type customer_status as enum ('active', 'blocked', 'frozen');

create type transaction_type as enum ('transfer', 'deposit', 'withdrawal');

create type transaction_status as enum ('pending', 'completed', 'failed', 'reversed');

create table customers
(
    customer_id     bigserial
        primary key,
    iin             char(12)                                                   not null
        unique,
    full_name       text                                                       not null,
    phone           text,
    email           text,
    status          customer_status          default 'active'::customer_status not null,
    created_at      timestamp with time zone default now()                     not null,
    daily_limit_kzt numeric(18, 2)           default 0                         not null
);

INSERT INTO public.customers (customer_id, iin, full_name, phone, email, status, created_at, daily_limit_kzt)
VALUES (3, '700209401314', 'Бектурганова Патима Маймаковна', '87775607049', 'bekturganova70@gmail.com', 'active',
        '2025-12-11 21:17:23.667000 +00:00', 0.00);
INSERT INTO public.customers (customer_id, iin, full_name, phone, email, status, created_at, daily_limit_kzt)
VALUES (4, '701114301374', 'Шалабаев Кайрат Калданович', '87772463506', 'kairat70@gmail.com', 'active',
        '2025-12-11 16:19:23.485671 +00:00', 0.00);
INSERT INTO public.customers (customer_id, iin, full_name, phone, email, status, created_at, daily_limit_kzt)
VALUES (5, '001120500951', 'Калданов Санжар Кайратулы', '87084802448', 'sanzhar.kaldanov@gmail.com', 'active',
        '2025-12-11 16:20:05.382493 +00:00', 0.00);
INSERT INTO public.customers (customer_id, iin, full_name, phone, email, status, created_at, daily_limit_kzt)
VALUES (8, '222222222222', 'Человеков Человек Человекович', '87083242342', 'chelovek@gmail.com', 'active',
        '2025-12-11 16:21:39.623749 +00:00', 0.00);
INSERT INTO public.customers (customer_id, iin, full_name, phone, email, status, created_at, daily_limit_kzt)
VALUES (9, '333333333333', 'Иванов Иван Иванович', '87072342342', 'ivan@gmail.com', 'active',
        '2025-12-11 16:22:13.606691 +00:00', 0.00);
INSERT INTO public.customers (customer_id, iin, full_name, phone, email, status, created_at, daily_limit_kzt)
VALUES (10, '444444444444', 'Калданов Нурдаулет Кайратулы', '87074763277', 'nurdaulet@gmail.com', 'active',
        '2025-12-11 16:23:00.050320 +00:00', 0.00);
INSERT INTO public.customers (customer_id, iin, full_name, phone, email, status, created_at, daily_limit_kzt)
VALUES (11, '555555555555', 'Нурлыбекова Гаухар', '87024323452', 'goha@gmail.com', 'active',
        '2025-12-11 16:23:42.896221 +00:00', 0.00);
INSERT INTO public.customers (customer_id, iin, full_name, phone, email, status, created_at, daily_limit_kzt)
VALUES (12, '666666666666', 'Калданова Меруерт', '87009924975', 'mika2gmail.com', 'active',
        '2025-12-11 16:24:15.137567 +00:00', 0.00);
INSERT INTO public.customers (customer_id, iin, full_name, phone, email, status, created_at, daily_limit_kzt)
VALUES (13, '070422603234', 'Калданова Лина Қайратқызы', '87472686922', 'lina.kaldanova@gmail.com', 'active',
        '2025-12-11 16:26:24.565694 +00:00', 0.00);
INSERT INTO public.customers (customer_id, iin, full_name, phone, email, status, created_at, daily_limit_kzt)
VALUES (6, '111111111111', 'Адамов Адам Адамович', '87772727272', 'adam@gmail.com', 'blocked',
        '2025-12-11 16:20:49.878877 +00:00', 0.00);


create table accounts
(
    account_id     bigserial
        primary key,
    customer_id    bigint                                 not null
        references customers,
    account_number text                                   not null
        unique,
    currency       text                                   not null
        constraint accounts_currency_check
            check (currency = ANY (ARRAY ['KZT'::text, 'USD'::text, 'EUR'::text, 'RUB'::text])),
    balance        numeric(18, 2)           default 0     not null,
    is_active      boolean                  default true  not null,
    opened_at      timestamp with time zone default now() not null,
    closed_at      timestamp with time zone
);

INSERT INTO public.accounts (account_id, customer_id, account_number, currency, balance, is_active, opened_at,
                             closed_at)
VALUES (7, 8, 'KZ5396502F0015686412', 'KZT', 843562234.00, true, '2025-12-11 16:31:33.519182 +00:00', null);
INSERT INTO public.accounts (account_id, customer_id, account_number, currency, balance, is_active, opened_at,
                             closed_at)
VALUES (3, 3, 'KZ09601A241001007211', 'KZT', 2345373.00, true, '2025-12-11 16:31:33.519182 +00:00', null);
INSERT INTO public.accounts (account_id, customer_id, account_number, currency, balance, is_active, opened_at,
                             closed_at)
VALUES (11, 12, 'KZ73601A121003352301', 'KZT', 456226.00, true, '2025-12-11 16:31:33.519182 +00:00', null);
INSERT INTO public.accounts (account_id, customer_id, account_number, currency, balance, is_active, opened_at,
                             closed_at)
VALUES (5, 5, 'KZ108562203116592437', 'KZT', 15115391.00, true, '2025-12-11 16:31:33.519182 +00:00', null);
INSERT INTO public.accounts (account_id, customer_id, account_number, currency, balance, is_active, opened_at,
                             closed_at)
VALUES (12, 13, 'KZ96601A121003914681', 'EUR', 9765432.00, true, '2025-12-11 16:31:33.519182 +00:00', null);
INSERT INTO public.accounts (account_id, customer_id, account_number, currency, balance, is_active, opened_at,
                             closed_at)
VALUES (10, 11, 'KZ05601A861019671701', 'RUB', 6672384.00, true, '2025-12-11 16:31:33.519182 +00:00', null);
INSERT INTO public.accounts (account_id, customer_id, account_number, currency, balance, is_active, opened_at,
                             closed_at)
VALUES (4, 4, 'KZ67601A121003886491 ', 'EUR', 625653.00, true, '2025-12-11 16:31:33.519182 +00:00', null);
INSERT INTO public.accounts (account_id, customer_id, account_number, currency, balance, is_active, opened_at,
                             closed_at)
VALUES (8, 9, 'KZ10601A121003352271', 'RUB', 2354252.00, true, '2025-12-11 16:31:33.519182 +00:00', null);
INSERT INTO public.accounts (account_id, customer_id, account_number, currency, balance, is_active, opened_at,
                             closed_at)
VALUES (6, 6, 'KZ766018861000253591', 'USD', 0.00, true, '2025-12-11 16:31:33.519182 +00:00', null);
INSERT INTO public.accounts (account_id, customer_id, account_number, currency, balance, is_active, opened_at,
                             closed_at)
VALUES (9, 10, 'KZ28601A121003538381', 'USD', 43155.00, true, '2025-12-11 16:31:33.519182 +00:00', null);


create table exchange_rates
(
    rate_id       bigserial
        primary key,
    from_currency text                     not null
        constraint exchange_rates_from_currency_check
            check (from_currency = ANY (ARRAY ['KZT'::text, 'USD'::text, 'EUR'::text, 'RUB'::text])),
    to_currency   text                     not null
        constraint exchange_rates_to_currency_check
            check (to_currency = ANY (ARRAY ['KZT'::text, 'USD'::text, 'EUR'::text, 'RUB'::text])),
    rate          numeric(18, 6)           not null,
    valid_from    timestamp with time zone not null,
    valid_to      timestamp with time zone not null
);

create table transactions
(
    transaction_id  bigserial
        primary key,
    from_account_id bigint
        references accounts,
    to_account_id   bigint
        references accounts,
    amount          numeric(18, 2)                                                 not null,
    currency        text                                                           not null
        constraint transactions_currency_check
            check (currency = ANY (ARRAY ['KZT'::text, 'USD'::text, 'EUR'::text, 'RUB'::text])),
    exchange_rate   numeric(18, 6),
    amount_kzt      numeric(18, 2),
    type            transaction_type                                               not null,
    status          transaction_status       default 'pending'::transaction_status not null,
    created_at      timestamp with time zone default now()                         not null,
    completed_at    timestamp with time zone,
    description     text
);

create table audit_log
(
    log_id     bigserial
        primary key,
    table_name text                                   not null,
    record_id  bigint                                 not null,
    action     text                                   not null
        constraint audit_log_action_check
            check (action = ANY (ARRAY ['INSERT'::text, 'UPDATE'::text, 'DELETE'::text])),
    old_values jsonb,
    new_values jsonb,
    changed_by text,
    changed_at timestamp with time zone default now() not null,
    ip_address inet
);

-- Task 1: Transaction Management

DROP PROCEDURE IF EXISTS process_transfer(
    text, text, numeric, text, text
);
CREATE OR REPLACE PROCEDURE process_transfer(
    IN p_from_account_number text,
    IN p_to_account_number text,
    IN p_amount numeric(18, 2),
    IN p_currency text,
    IN p_description text
)
    LANGUAGE plpgsql
AS
$$
DECLARE
    v_from_account     accounts%ROWTYPE;
    v_to_account       accounts%ROWTYPE;
    v_from_customer    customers%ROWTYPE;
    v_rate_acc_to_acc  numeric(18, 6);
    v_rate_to_kzt      numeric(18, 6);
    v_amount_to_credit numeric(18, 2);
    v_amount_kzt       numeric(18, 2);
    v_today_sum_kzt    numeric(18, 2);
    v_tx_id            bigint;
    v_error_code       text;
    v_error_message    text;
BEGIN
    IF p_amount IS NULL OR p_amount <= 0 THEN
        v_error_code := 'ERR_INVALID_AMOUNT';
        v_error_message := 'Сумма перевода должна быть больше нуля';
        INSERT INTO audit_log(table_name, record_id, action, old_values, new_values)
        VALUES ('process_transfer',
                0,
                'INSERT',
                NULL,
                jsonb_build_object(
                        'code', v_error_code,
                        'message', v_error_message,
                        'from_account_number', p_from_account_number,
                        'to_account_number', p_to_account_number,
                        'amount', p_amount,
                        'currency', p_currency
                ));
        RAISE EXCEPTION '%: %', v_error_code, v_error_message;
    END IF;
    SELECT *
    INTO v_from_account
    FROM accounts
    WHERE account_number = p_from_account_number
        FOR UPDATE;

    IF NOT FOUND THEN
        v_error_code := 'ERR_FROM_ACCOUNT_NOT_FOUND';
        v_error_message := 'Исходный счёт не найден';
        INSERT INTO audit_log(table_name, record_id, action, old_values, new_values)
        VALUES ('process_transfer',
                0,
                'INSERT',
                NULL,
                jsonb_build_object(
                        'code', v_error_code,
                        'message', v_error_message,
                        'from_account_number', p_from_account_number
                ));
        RAISE EXCEPTION '%: %', v_error_code, v_error_message;
    END IF;
    SELECT *
    INTO v_to_account
    FROM accounts
    WHERE account_number = p_to_account_number
        FOR UPDATE;
    IF NOT FOUND THEN
        v_error_code := 'ERR_TO_ACCOUNT_NOT_FOUND';
        v_error_message := 'Целевой счёт не найден';
        INSERT INTO audit_log(table_name, record_id, action, old_values, new_values)
        VALUES ('process_transfer',
                0,
                'INSERT',
                NULL,
                jsonb_build_object(
                        'code', v_error_code,
                        'message', v_error_message,
                        'to_account_number', p_to_account_number
                ));
        RAISE EXCEPTION '%: %', v_error_code, v_error_message;
    END IF;
    IF NOT v_from_account.is_active OR v_from_account.closed_at IS NOT NULL THEN
        v_error_code := 'ERR_FROM_ACCOUNT_INACTIVE';
        v_error_message := 'Исходный счёт не активен или закрыт';
        INSERT INTO audit_log(table_name, record_id, action, old_values, new_values)
        VALUES ('process_transfer',
                0,
                'INSERT',
                NULL,
                jsonb_build_object(
                        'code', v_error_code,
                        'message', v_error_message,
                        'from_account_id', v_from_account.account_id
                ));
        RAISE EXCEPTION '%: %', v_error_code, v_error_message;
    END IF;
    IF NOT v_to_account.is_active OR v_to_account.closed_at IS NOT NULL THEN
        v_error_code := 'ERR_TO_ACCOUNT_INACTIVE';
        v_error_message := 'Целевой счёт не активен или закрыт';
        INSERT INTO audit_log(table_name, record_id, action, old_values, new_values)
        VALUES ('process_transfer',
                0,
                'INSERT',
                NULL,
                jsonb_build_object(
                        'code', v_error_code,
                        'message', v_error_message,
                        'to_account_id', v_to_account.account_id
                ));
        RAISE EXCEPTION '%: %', v_error_code, v_error_message;
    END IF;
    SELECT *
    INTO v_from_customer
    FROM customers
    WHERE customer_id = v_from_account.customer_id;
    IF NOT FOUND THEN
        v_error_code := 'ERR_CUSTOMER_NOT_FOUND';
        v_error_message := 'Клиент-отправитель не найден';
        INSERT INTO audit_log(table_name, record_id, action, old_values, new_values)
        VALUES ('process_transfer',
                0,
                'INSERT',
                NULL,
                jsonb_build_object(
                        'code', v_error_code,
                        'message', v_error_message,
                        'customer_id', v_from_account.customer_id
                ));
        RAISE EXCEPTION '%: %', v_error_code, v_error_message;
    END IF;
    IF v_from_customer.status <> 'active'::customer_status THEN
        v_error_code := 'ERR_CUSTOMER_NOT_ACTIVE';
        v_error_message := 'Статус клиента не позволяет выполнять операции (не active)';
        INSERT INTO audit_log(table_name, record_id, action, old_values, new_values)
        VALUES ('process_transfer',
                0,
                'INSERT',
                NULL,
                jsonb_build_object(
                        'code', v_error_code,
                        'message', v_error_message,
                        'customer_id', v_from_customer.customer_id,
                        'status', v_from_customer.status
                ));
        RAISE EXCEPTION '%: %', v_error_code, v_error_message;
    END IF;
    IF p_currency <> v_from_account.currency THEN
        v_error_code := 'ERR_CURRENCY_MISMATCH';
        v_error_message := format(
                'Валюта операции (%s) не совпадает с валютой счёта (%s)',
                p_currency, v_from_account.currency
                           );
        INSERT INTO audit_log(table_name, record_id, action, old_values, new_values)
        VALUES ('process_transfer',
                0,
                'INSERT',
                NULL,
                jsonb_build_object(
                        'code', v_error_code,
                        'message', v_error_message,
                        'account_currency', v_from_account.currency,
                        'operation_currency', p_currency
                ));
        RAISE EXCEPTION '%: %', v_error_code, v_error_message;
    END IF;
    IF v_from_account.currency = v_to_account.currency THEN
        v_rate_acc_to_acc := 1;
        v_amount_to_credit := p_amount;
    ELSE
        SELECT rate
        INTO v_rate_acc_to_acc
        FROM exchange_rates
        WHERE from_currency = v_from_account.currency
          AND to_currency = v_to_account.currency
          AND now() BETWEEN valid_from AND valid_to
        ORDER BY valid_from DESC
        LIMIT 1;
        IF v_rate_acc_to_acc IS NULL THEN
            v_error_code := 'ERR_EXCHANGE_RATE_NOT_FOUND';
            v_error_message := 'Не найден курс между валютами счетов';
            INSERT INTO audit_log(table_name, record_id, action, old_values, new_values)
            VALUES ('process_transfer',
                    0,
                    'INSERT',
                    NULL,
                    jsonb_build_object(
                            'code', v_error_code,
                            'message', v_error_message,
                            'from_currency', v_from_account.currency,
                            'to_currency', v_to_account.currency
                    ));

            RAISE EXCEPTION '%: %', v_error_code, v_error_message;
        END IF;
        v_amount_to_credit := round(p_amount * v_rate_acc_to_acc, 2);
    END IF;
    IF v_from_account.currency = 'KZT' THEN
        v_amount_kzt := p_amount;
    ELSE
        SELECT rate
        INTO v_rate_to_kzt
        FROM exchange_rates
        WHERE from_currency = v_from_account.currency
          AND to_currency = 'KZT'
          AND now() BETWEEN valid_from AND valid_to
        ORDER BY valid_from DESC
        LIMIT 1;
        IF v_rate_to_kzt IS NULL THEN
            v_error_code := 'ERR_EXCHANGE_RATE_KZT_NOT_FOUND';
            v_error_message := 'Не найден курс для пересчёта в KZT';
            INSERT INTO audit_log(table_name, record_id, action, old_values, new_values)
            VALUES ('process_transfer',
                    0,
                    'INSERT',
                    NULL,
                    jsonb_build_object(
                            'code', v_error_code,
                            'message', v_error_message,
                            'from_currency', v_from_account.currency
                    ));
            RAISE EXCEPTION '%: %', v_error_code, v_error_message;
        END IF;
        v_amount_kzt := round(p_amount * v_rate_to_kzt, 2);
    END IF;
    IF v_from_account.balance < p_amount THEN
        v_error_code := 'ERR_INSUFFICIENT_FUNDS';
        v_error_message := 'Недостаточно средств на исходном счёте';
        INSERT INTO audit_log(table_name, record_id, action, old_values, new_values)
        VALUES ('process_transfer',
                0,
                'INSERT',
                NULL,
                jsonb_build_object(
                        'code', v_error_code,
                        'message', v_error_message,
                        'balance', v_from_account.balance,
                        'amount', p_amount
                ));
        RAISE EXCEPTION '%: %', v_error_code, v_error_message;
    END IF;
    IF v_from_customer.daily_limit_kzt > 0 THEN
        SELECT COALESCE(SUM(amount_kzt), 0)
        INTO v_today_sum_kzt
        FROM transactions t
                 JOIN accounts a ON a.account_id = t.from_account_id
        WHERE a.customer_id = v_from_customer.customer_id
          AND t.type = 'transfer'
          AND t.status IN ('pending', 'completed')
          AND t.created_at::date = now()::date;
        IF v_today_sum_kzt + v_amount_kzt > v_from_customer.daily_limit_kzt THEN
            v_error_code := 'ERR_DAILY_LIMIT_EXCEEDED';
            v_error_message := 'Превышен дневной лимит по клиенту';
            INSERT INTO audit_log(table_name, record_id, action, old_values, new_values)
            VALUES ('process_transfer',
                    0,
                    'INSERT',
                    NULL,
                    jsonb_build_object(
                            'code', v_error_code,
                            'message', v_error_message,
                            'daily_limit_kzt', v_from_customer.daily_limit_kzt,
                            'today_sum_kzt', v_today_sum_kzt,
                            'current_kzt', v_amount_kzt
                    ));
            RAISE EXCEPTION '%: %', v_error_code, v_error_message;
        END IF;
    END IF;
    -- Внутренний блок BEGIN ... EXCEPTION работает как под-транзакция (savepoint)
    -- только операции перевода откатываются при ошибке, а не вся процедура.
    BEGIN
        INSERT INTO transactions (from_account_id,
                                  to_account_id,
                                  amount,
                                  currency,
                                  exchange_rate,
                                  amount_kzt,
                                  type,
                                  status,
                                  created_at,
                                  description)
        VALUES (v_from_account.account_id,
                v_to_account.account_id,
                p_amount,
                p_currency,
                v_rate_acc_to_acc,
                v_amount_kzt,
                'transfer',
                'pending',
                now(),
                p_description)
        RETURNING transaction_id INTO v_tx_id;
        UPDATE accounts
        SET balance = balance - p_amount
        WHERE account_id = v_from_account.account_id;
        UPDATE accounts
        SET balance = balance + v_amount_to_credit
        WHERE account_id = v_to_account.account_id;
        UPDATE transactions
        SET status       = 'completed',
            completed_at = now()
        WHERE transaction_id = v_tx_id;
    EXCEPTION
        WHEN OTHERS THEN
            v_error_code := 'ERR_INTERNAL';
            v_error_message := 'Внутренняя ошибка при выполнении перевода: ' || SQLERRM;
            INSERT INTO audit_log(table_name, record_id, action, old_values, new_values)
            VALUES ('transactions',
                    COALESCE(v_tx_id, 0),
                    'INSERT',
                    NULL,
                    jsonb_build_object(
                            'code', v_error_code,
                            'message', v_error_message
                    ));
            RAISE EXCEPTION '%: %', v_error_code, v_error_message;
    END;
    INSERT INTO audit_log(table_name, record_id, action, old_values, new_values)
    VALUES ('transactions',
            v_tx_id,
            'INSERT',
            NULL,
            (SELECT to_jsonb(t) FROM transactions t WHERE t.transaction_id = v_tx_id));
END;
$$;

-- Task 2: Views for Reporting
--- View 1: customer_balance_summary
CREATE OR REPLACE VIEW customer_balance_summary AS
WITH account_balances AS (SELECT c.customer_id,
                                 c.iin,
                                 c.full_name,
                                 c.daily_limit_kzt,
                                 a.account_id,
                                 a.account_number,
                                 a.currency,
                                 a.balance,
                                 CASE
                                     WHEN a.currency = 'KZT' THEN a.balance
                                     ELSE a.balance * er.rate
                                     END AS balance_kzt
                          FROM customers c
                                   JOIN accounts a
                                        ON a.customer_id = c.customer_id
                                   LEFT JOIN exchange_rates er
                                             ON er.from_currency = a.currency
                                                 AND er.to_currency = 'KZT'
                                                 AND now() BETWEEN er.valid_from AND er.valid_to),
     daily_used AS (SELECT c.customer_id,
                           COALESCE(SUM(t.amount_kzt), 0) AS used_kzt_today
                    FROM customers c
                             LEFT JOIN accounts a
                                       ON a.customer_id = c.customer_id
                             LEFT JOIN transactions t
                                       ON t.from_account_id = a.account_id
                                           AND t.created_at::date = current_date
                                           AND t.status IN ('pending', 'completed')
                    GROUP BY c.customer_id),
     base AS (SELECT ab.customer_id,
                     ab.iin,
                     ab.full_name,
                     ab.account_id,
                     ab.account_number,
                     ab.currency,
                     ab.balance,
                     ab.balance_kzt,
                     SUM(ab.balance_kzt) OVER (PARTITION BY ab.customer_id) AS customer_total_balance_kzt,
                     ab.daily_limit_kzt,
                     du.used_kzt_today,
                     CASE
                         WHEN ab.daily_limit_kzt > 0
                             THEN ROUND(du.used_kzt_today / ab.daily_limit_kzt * 100, 2)
                         END                                                AS daily_limit_utilization_pct
              FROM account_balances ab
                       LEFT JOIN daily_used du
                                 ON du.customer_id = ab.customer_id)
SELECT b.*,
       RANK() OVER (ORDER BY b.customer_total_balance_kzt DESC) AS customer_rank_by_total_balance
FROM base b;

--- View 2: daily_transaction_report
CREATE OR REPLACE VIEW daily_transaction_report AS
WITH base AS (SELECT t.created_at::date             AS tx_date,
                     t.type                         AS transaction_type,
                     SUM(COALESCE(t.amount_kzt, 0)) AS total_volume_kzt,
                     COUNT(*)                       AS tx_count,
                     AVG(COALESCE(t.amount_kzt, 0)) AS avg_amount_kzt
              FROM transactions t
              GROUP BY t.created_at::date, t.type),
     with_window AS (SELECT b.*,
                            SUM(b.total_volume_kzt) OVER (
                                PARTITION BY b.transaction_type
                                ORDER BY b.tx_date
                                ) AS running_total_volume_kzt,
                            SUM(b.tx_count) OVER (
                                PARTITION BY b.transaction_type
                                ORDER BY b.tx_date
                                ) AS running_total_count,
                            LAG(b.total_volume_kzt) OVER (
                                PARTITION BY b.transaction_type
                                ORDER BY b.tx_date
                                ) AS prev_total_volume_kzt
                     FROM base b)
SELECT tx_date,
       transaction_type,
       total_volume_kzt,
       tx_count,
       avg_amount_kzt,
       running_total_volume_kzt,
       running_total_count,
       CASE
           WHEN prev_total_volume_kzt > 0
               THEN ROUND(
                   (total_volume_kzt - prev_total_volume_kzt)
                       / prev_total_volume_kzt * 100,
                   2
                    )
           END AS day_over_day_volume_growth_pct
FROM with_window;

--- View 3: suspicious_activity_view (WITH SECURITY BARRIER)
CREATE OR REPLACE VIEW suspicious_activity_view
    WITH (security_barrier = true) AS
WITH tx_base AS (SELECT t.transaction_id,
                        t.from_account_id,
                        t.to_account_id,
                        t.amount,
                        t.currency,
                        t.amount_kzt,
                        t.type,
                        t.status,
                        t.created_at,
                        t.description,
                        a.customer_id                    AS from_customer_id,
                        c.iin                            AS from_customer_iin,
                        c.full_name                      AS from_customer_name,
                        date_trunc('hour', t.created_at) AS tx_hour,
                        CASE
                            WHEN t.amount_kzt IS NOT NULL THEN t.amount_kzt
                            WHEN t.currency = 'KZT' THEN t.amount
                            ELSE t.amount * er.rate
                            END                          AS amount_kzt_equiv
                 FROM transactions t
                          LEFT JOIN accounts a
                                    ON a.account_id = t.from_account_id
                          LEFT JOIN customers c
                                    ON c.customer_id = a.customer_id
                          LEFT JOIN exchange_rates er
                                    ON er.from_currency = t.currency
                                        AND er.to_currency = 'KZT'
                                        AND t.created_at BETWEEN er.valid_from AND er.valid_to),
     tx_flags AS (SELECT tx_base.*,
                         (amount_kzt_equiv > 5000000) AS big_amount_flag,
                         COUNT(*) OVER (
                             PARTITION BY from_customer_id, tx_hour
                             )                        AS tx_count_same_hour,
                         LAG(created_at) OVER (
                             PARTITION BY from_account_id
                             ORDER BY created_at
                             )                        AS prev_tx_time
                  FROM tx_base)
SELECT transaction_id,
       from_account_id,
       to_account_id,
       from_customer_id,
       from_customer_iin,
       from_customer_name,
       amount,
       currency,
       amount_kzt_equiv,
       type,
       status,
       created_at,
       description,
       big_amount_flag,
       (tx_count_same_hour > 10)                                AS many_tx_in_hour_flag,
       (prev_tx_time IS NOT NULL
           AND created_at - prev_tx_time < INTERVAL '1 minute') AS rapid_sequential_flag
FROM tx_flags
WHERE big_amount_flag
   OR tx_count_same_hour > 10
   OR (prev_tx_time IS NOT NULL
    AND created_at - prev_tx_time < INTERVAL '1 minute');

-- Task 3: Performance Optimization with Indexes
CREATE INDEX idx_acc_num_btree ON accounts (account_number);
create index idx_customers_email_lower
    on customers (lower(email));
create index idx_accounts_active_customer
    on accounts (customer_id, account_number)
    where ((is_active = true) AND (closed_at IS NULL));
create index idx_tx_from_time ON transactions (from_account_id, created_at DESC);
create index idx_transactions_from_status_type_created_inc
    on transactions (from_account_id, status, type, created_at) include (amount_kzt);
create index idx_audit_log_table_name_hash
    on audit_log using hash (table_name);
create index idx_audit_log_jsonb_gin
    on audit_log using gin ((old_values || new_values));

-- Task 4: Advanced Procedure - Batch Processing
CREATE TABLE IF NOT EXISTS salary_batch_log
(
    batch_id               bigserial PRIMARY KEY,
    company_account_number text           NOT NULL,
    processed_at           timestamptz    NOT NULL DEFAULT now(),
    total_request_amount   numeric(18, 2) NOT NULL,
    total_success_amount   numeric(18, 2) NOT NULL,
    successful_count       integer        NOT NULL,
    failed_count           integer        NOT NULL,
    failed_details         jsonb          NOT NULL
);

CREATE MATERIALIZED VIEW IF NOT EXISTS salary_batch_summary_mv AS
SELECT company_account_number,
       date_trunc('month', processed_at) AS month_start,
       COUNT(*)                          AS batch_count,
       SUM(total_success_amount)         AS total_paid_amount,
       SUM(successful_count)             AS total_success_payments,
       SUM(failed_count)                 AS total_failed_payments
FROM salary_batch_log
GROUP BY company_account_number, date_trunc('month', processed_at);

DROP PROCEDURE IF EXISTS process_salary_batch(
    text, jsonb, INOUT integer, INOUT integer, INOUT jsonb
);

CREATE OR REPLACE PROCEDURE process_salary_batch(
    IN p_company_account_number text,
    IN p_payments jsonb,
    INOUT p_successful_count integer DEFAULT 0,
    INOUT p_failed_count integer DEFAULT 0,
    INOUT p_failed_details jsonb DEFAULT '[]'::jsonb
)
    LANGUAGE plpgsql
AS
$$
DECLARE
    v_lock_key             bigint;
    v_company_account      accounts%ROWTYPE;
    v_total_request_amount numeric(18, 2) := 0;
    v_total_success_amount numeric(18, 2) := 0;
    v_payment              jsonb;
    v_iin                  text;
    v_amount               numeric(18, 2);
    v_descr                text;
    v_employee_account     accounts%ROWTYPE;
BEGIN
    p_successful_count := 0;
    p_failed_count := 0;
    p_failed_details := '[]'::jsonb;
    v_lock_key := hashtext(p_company_account_number);

    -- Advisory lock: предотвращает одновременную обработку двух батчей по одному счёту.
    IF NOT pg_try_advisory_lock(v_lock_key) THEN
        RAISE EXCEPTION 'ERR_BATCH_LOCKED: another salary batch in progress for account %',
            p_company_account_number;
    END IF;
    BEGIN
        IF p_payments IS NULL OR jsonb_typeof(p_payments) <> 'array' THEN
            RAISE EXCEPTION 'ERR_INVALID_INPUT: payments must be JSONB array';
        END IF;
        SELECT *
        INTO v_company_account
        FROM accounts
        WHERE account_number = p_company_account_number
            FOR UPDATE;
        IF NOT FOUND THEN
            RAISE EXCEPTION 'ERR_COMPANY_ACCOUNT_NOT_FOUND: %', p_company_account_number;
        END IF;
        IF NOT v_company_account.is_active OR v_company_account.closed_at IS NOT NULL THEN
            RAISE EXCEPTION 'ERR_COMPANY_ACCOUNT_INACTIVE: %', p_company_account_number;
        END IF;
        SELECT COALESCE(SUM((elem ->> 'amount')::numeric(18, 2)), 0)
        INTO v_total_request_amount
        FROM jsonb_array_elements(p_payments) AS elem;
        IF v_total_request_amount <= 0 THEN
            RAISE EXCEPTION 'ERR_INVALID_BATCH_AMOUNT: total amount must be > 0';
        END IF;
        IF v_company_account.balance < v_total_request_amount THEN
            RAISE EXCEPTION
                'ERR_INSUFFICIENT_FUNDS: balance=%, batch=%',
                v_company_account.balance, v_total_request_amount;
        END IF;
        CREATE TEMP TABLE IF NOT EXISTS tmp_salary_delta
        (
            account_id bigint PRIMARY KEY,
            delta      numeric(18, 2) NOT NULL
        ) ON COMMIT DROP;
        TRUNCATE tmp_salary_delta;

        -- Зарплатные платежи выполняются без проверки daily_limit_kzt (требование задания).
        FOR v_payment IN
            SELECT elem
            FROM jsonb_array_elements(p_payments) AS elem
            LOOP
                -- Под-транзакция: ошибка по одному сотруднику не прерывает весь батч (savepoint).
                BEGIN
                    v_iin := v_payment ->> 'iin';
                    v_amount := (v_payment ->> 'amount')::numeric(18, 2);
                    v_descr := COALESCE(v_payment ->> 'description', 'Salary');
                    IF v_iin IS NULL OR v_iin = '' THEN
                        RAISE EXCEPTION 'ERR_INVALID_IIN';
                    END IF;
                    IF v_amount IS NULL OR v_amount <= 0 THEN
                        RAISE EXCEPTION 'ERR_INVALID_AMOUNT';
                    END IF;
                    SELECT a.*
                    INTO v_employee_account
                    FROM customers c
                             JOIN accounts a ON a.customer_id = c.customer_id
                    WHERE c.iin = v_iin
                      AND a.currency = v_company_account.currency
                      AND a.is_active = true
                      AND a.closed_at IS NULL
                    ORDER BY a.opened_at
                    LIMIT 1 FOR UPDATE;
                    IF NOT FOUND THEN
                        RAISE EXCEPTION 'ERR_EMPLOYEE_ACCOUNT_NOT_FOUND';
                    END IF;
                    INSERT INTO tmp_salary_delta(account_id, delta)
                    VALUES (v_company_account.account_id, -v_amount)
                    ON CONFLICT (account_id) DO UPDATE
                        SET delta = tmp_salary_delta.delta + EXCLUDED.delta;
                    INSERT INTO tmp_salary_delta(account_id, delta)
                    VALUES (v_employee_account.account_id, v_amount)
                    ON CONFLICT (account_id) DO UPDATE
                        SET delta = tmp_salary_delta.delta + EXCLUDED.delta;
                    INSERT INTO transactions (from_account_id,
                                              to_account_id,
                                              amount,
                                              currency,
                                              exchange_rate,
                                              amount_kzt,
                                              type,
                                              status,
                                              created_at,
                                              completed_at,
                                              description)
                    VALUES (v_company_account.account_id,
                            v_employee_account.account_id,
                            v_amount,
                            v_company_account.currency,
                            NULL,
                            CASE
                                WHEN v_company_account.currency = 'KZT' THEN v_amount
                                ELSE NULL
                                END,
                            'transfer',
                            'completed',
                            now(),
                            now(),
                            v_descr);
                    p_successful_count := p_successful_count + 1;
                    v_total_success_amount := v_total_success_amount + v_amount;
                EXCEPTION
                    WHEN OTHERS THEN
                        p_failed_count := p_failed_count + 1;
                        p_failed_details := p_failed_details || jsonb_build_array(
                                jsonb_build_object(
                                        'iin', v_iin,
                                        'amount', v_amount,
                                        'description', v_descr,
                                        'error', SQLERRM
                                )
                                                                );
                END;
            END LOOP;
        UPDATE accounts a
        SET balance = a.balance + d.delta
        FROM tmp_salary_delta d
        WHERE a.account_id = d.account_id;
        INSERT INTO salary_batch_log (company_account_number,
                                      total_request_amount,
                                      total_success_amount,
                                      successful_count,
                                      failed_count,
                                      failed_details)
        VALUES (p_company_account_number,
                v_total_request_amount,
                v_total_success_amount,
                p_successful_count,
                p_failed_count,
                p_failed_details);
        PERFORM pg_advisory_unlock(v_lock_key);
    EXCEPTION
        WHEN OTHERS THEN
            PERFORM pg_advisory_unlock(v_lock_key);
            RAISE;
    END;
END;
$$;
