INSERT INTO plans (id, code, name, price_cents, currency, billing_interval, active)
VALUES
    ('11111111-1111-1111-1111-111111111101','FREE', 'FinLedger Free', 0, 'BRL', 'MONTHLY', TRUE),
    ('11111111-1111-1111-1111-111111111102','PRO', 'FinLedger Pro', 4990, 'BRL', 'MONTHLY', TRUE),
    ('11111111-1111-1111-1111-111111111103','ENTERPRISE', 'FinLedger Enterprise', 19990, 'BRL', 'YEARLY', TRUE)
ON CONFLICT (code) DO NOTHING;

