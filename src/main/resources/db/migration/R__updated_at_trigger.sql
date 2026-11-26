CREATE OR REPLACE FUNCTION ${flyway:defaultSchema}.fn_set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at := NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_accounts_set_updated_at ON ${flyway:defaultSchema}.accounts;
CREATE TRIGGER trg_accounts_set_updated_at
    BEFORE UPDATE ON ${flyway:defaultSchema}.accounts
    FOR EACH ROW
    EXECUTE FUNCTION ${flyway:defaultSchema}.fn_set_updated_at();

DROP TRIGGER IF EXISTS trg_wallets_set_updated_at ON ${flyway:defaultSchema}.wallets;
CREATE TRIGGER trg_wallets_set_updated_at
    BEFORE UPDATE ON ${flyway:defaultSchema}.wallets
    FOR EACH ROW
    EXECUTE FUNCTION ${flyway:defaultSchema}.fn_set_updated_at();

DROP TRIGGER IF EXISTS trg_plans_set_updated_at ON ${flyway:defaultSchema}.plans;
CREATE TRIGGER trg_plans_set_updated_at
    BEFORE UPDATE ON ${flyway:defaultSchema}.plans
    FOR EACH ROW
    EXECUTE FUNCTION ${flyway:defaultSchema}.fn_set_updated_at();

DROP TRIGGER IF EXISTS trg_subscriptions_set_updated_at ON ${flyway:defaultSchema}.subscriptions;
CREATE TRIGGER trg_subscriptions_set_updated_at
    BEFORE UPDATE ON ${flyway:defaultSchema}.subscriptions
    FOR EACH ROW
    EXECUTE FUNCTION ${flyway:defaultSchema}.fn_set_updated_at();

