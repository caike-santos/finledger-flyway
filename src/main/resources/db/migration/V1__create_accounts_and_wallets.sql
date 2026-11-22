CREATE TABLE accounts(
    id UUID NOT NULL,
    full_name VARCHAR(200) NOT NULL,
    email VARCHAR(255) NOT NULL,
    document_number VARCHAR(32) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,

    CONSTRAINT pk_accounts PRIMARY KEY (id),
    CONSTRAINT uq_accounts_email UNIQUE (email),
    CONSTRAINT uq_accounts_document_number UNIQUE (document_number),
    CONSTRAINT chk_accounts_status CHECK(status IN ('ACTIVE', 'BLOCKED', 'CLOSED'))
    );

CREATE TABLE wallets(
    id UUID NOT NULL ,
    account_id UUID NOT NULL,
    currency CHAR(3) NOT NULL,
    balance_cents BIGINT NOT NULL DEFAULT 0,
    status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    version BIGINT NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT pk_wallets PRIMARY KEY (id),
    CONSTRAINT fk_wallets_account FOREIGN KEY (account_id) REFERENCES accounts (id),
    CONSTRAINT chk_wallets_balance_cents CHECK(balance_cents>=0),
    CONSTRAINT chk_wallets_status CHECK(status IN ('ACTIVE', 'FROZEN')),
    CONSTRAINT uq_wallets_account_currency UNIQUE (account_id, currency)
    );

