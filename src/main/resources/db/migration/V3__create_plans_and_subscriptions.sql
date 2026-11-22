CREATE TABLE plans (
   id UUID NOT NULL,
   code VARCHAR(50) NOT NULL,
   name VARCHAR(100) NOT NULL,
   price_cents BIGINT NOT NULL,
   currency CHAR(3) NOT NULL,
   billing_interval VARCHAR(20) NOT NULL,
   active BOOLEAN NOT NULL DEFAULT TRUE,
   created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
   updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

   CONSTRAINT pk_plans PRIMARY KEY (id),
   CONSTRAINT uq_plans_code UNIQUE (code),
   CONSTRAINT chk_plans_price_non_negative CHECK (price_cents >= 0),
   CONSTRAINT chk_plans_billing_interval CHECK (billing_interval IN ('MONTHLY', 'YEARLY'))
);
CREATE TABLE subscriptions(
    id UUID NOT NULL,
    account_id UUID NOT NULL,
    plan_id UUID NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    current_period_start TIMESTAMPTZ NOT NULL,
    current_period_end TIMESTAMPTZ NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT pk_subscriptions PRIMARY KEY (id),
    CONSTRAINT fk_subscriptions_account_id FOREIGN KEY (account_id) REFERENCES accounts (id),
    CONSTRAINT fk_subscriptions_plan_id FOREIGN KEY (plan_id) REFERENCES plans (id),
    CONSTRAINT chk_subscriptions_status CHECK (status IN ('TRIALING', 'ACTIVE', 'PAST_DUE', 'CANCELED')),
    CONSTRAINT chk_subscriptions_period_valid CHECK (current_period_end > current_period_start)
);

CREATE INDEX idx_subscriptions_account ON subscriptions (account_id);
CREATE INDEX idx_subscriptions_plan ON subscriptions (plan_id);