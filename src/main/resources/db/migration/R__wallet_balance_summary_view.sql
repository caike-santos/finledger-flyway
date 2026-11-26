CREATE OR REPLACE VIEW ${flyway:defaultSchema}.vw_wallet_balance_summary AS
SELECT w.id AS wallet_id,
       a.email AS account_email,
       w.currency AS currency,
       w.balance_cents AS balance_cents,
       COALESCE(
       SUM(le.amount_cents) FILTER (WHERE le.created_at >= NOW() - INTERVAL '30 days'),
       0
       ) AS volume_30d_cents,
       w.status AS wallet_status
FROM ${flyway:defaultSchema}.wallets w
JOIN ${flyway:defaultSchema}.accounts a ON w.account_id = a.id
LEFT JOIN ${flyway:defaultSchema}.ledger_entries le ON w.id = le.wallet_id
GROUP BY w.id, a.email, w.currency, w.balance_cents, w.status;

