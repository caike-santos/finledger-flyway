ALTER TABLE ${flyway:defaultSchema}.accounts
    ADD COLUMN IF NOT EXISTS document_hash VARCHAR(64),
    ADD COLUMN IF NOT EXISTS document_masked VARCHAR(32);

CREATE INDEX idx_accounts_document_hash ON ${flyway:defaultSchema}.accounts (document_hash);

