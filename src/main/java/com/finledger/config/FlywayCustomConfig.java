package com.finledger.config;

import com.finledger.migration.MigrationAuditCallback;
import com.finledger.migration.V8__HashAndMaskAccountDocuments;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.flyway.autoconfigure.FlywayConfigurationCustomizer;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * Fase 3 (Bloco 3A) — Customização programática do Flyway no Spring Boot 4.2.
 *
 * Por que registramos `V8__HashAndMaskAccountDocuments` aqui (no pacote
 * `com.finledger.migration`) em vez de deixá-la no pacote `db.migration`?
 *   A descoberta automática em `db.migration` exige construtor SEM argumentos.
 *   Registrando via `FlywayConfigurationCustomizer`, podemos injetar segredos/configs
 *   do Spring (`@Value`) com segurança na nossa Java Migration!
 */
@Configuration
public class FlywayCustomConfig {

    @Bean
    FlywayConfigurationCustomizer finledgerFlywayCustomizer(
            @Value("${finledger.security.document-pepper:dev-local-pepper}") String documentPepper
    ) {
        return configuration -> {
            configuration.javaMigrations(new V8__HashAndMaskAccountDocuments(documentPepper));
            configuration.callbacks(new MigrationAuditCallback());
        };
    }
}
