INSERT INTO accounts (id, full_name, email, document_number, status)
VALUES
    ('22222222-2222-2222-2222-222222222201', 'Alice Ferreira', 'alice@finledger.dev', '12345678901', 'ACTIVE'),
    ('22222222-2222-2222-2222-222222222202', 'Bruno Oliveira', 'bruno@finledger.dev', '98765432100', 'ACTIVE')
ON CONFLICT (email) DO NOTHING;

INSERT INTO wallets (id, account_id, currency, balance_cents)
VALUES
    ('22222222-2222-2222-2222-222222220101', '22222222-2222-2222-2222-222222222201', 'BRL', 150000),
    ('22222222-2222-2222-2222-222222220202','22222222-2222-2222-2222-222222222202', 'BRL', 50000)
ON CONFLICT (account_id, currency) DO NOTHING;

INSERT INTO ledger_entries (id, wallet_id, entry_type, amount_cents, idempotency_key, description)
VALUES
    ('01222222-2222-2222-2222-222222220101', '22222222-2222-2222-2222-222222220101', 'CREDIT', 150000, 'chave-000111', 'Depósito inicial dev'),
    ('02222222-2222-2222-2222-222222220101', '22222222-2222-2222-2222-222222220202', 'CREDIT', 50000, 'chave-000222', 'Depósito inicial dev')
ON CONFLICT (idempotency_key) DO NOTHING;

