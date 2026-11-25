CREATE TABLE ${flyway:defaultSchema}.platform_settings(
    setting_key VARCHAR(100) NOT NULL,
    setting_value VARCHAR(255) NOT NULL,
    description VARCHAR(255),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT pk_platform_settings PRIMARY KEY (setting_key)
);

INSERT INTO ${flyway:defaultSchema}.platform_settings (setting_key, setting_value, description)
VALUES
    ('default_fee_bps', '${platform_default_fee_bps}', 'Taxa padrão da plataforma em basis points (ex: 150 = 1.50%)')
ON CONFLICT (setting_key) DO NOTHING;
