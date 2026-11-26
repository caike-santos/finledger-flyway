CREATE TABLE audit.wallet_audit_log(
    id UUID NOT NULL,
    wallet_id UUID NOT NULL,
    event_type VARCHAR(50) NOT NULL,
    actor VARCHAR(100) NOT NULL,
    payload JSONB NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT pk_wallet_audit_log PRIMARY KEY (id)
);

CREATE INDEX idx_wallet_audit_log_wallet_id ON audit.wallet_audit_log (wallet_id);

