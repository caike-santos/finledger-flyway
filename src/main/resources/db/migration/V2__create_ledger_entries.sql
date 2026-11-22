CREATE TABLE ledger_entries(
    id UUID NOT NULL,
    wallet_id UUID NOT NULL,
    entry_type VARCHAR(16) NOT NULL,
    amount_cents BIGINT NOT NULL,
    idempotency_key VARCHAR(100) NOT NULL,
    description VARCHAR(255),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT pk_ledger_entries PRIMARY KEY (id),
    CONSTRAINT fk_ledger_entries_wallet FOREIGN KEY (wallet_id) REFERENCES wallets (id),
    CONSTRAINT chk_ledger_entries_entry_type CHECK (entry_type IN ('DEBIT', 'CREDIT')),
    CONSTRAINT chk_ledger_entries_amount_cents CHECK (amount_cents > 0),
    CONSTRAINT uq_ledger_entries_idempotency_key UNIQUE (idempotency_key)
);

CREATE INDEX idx_ledger_entries_wallet_id ON ledger_entries(wallet_id)

