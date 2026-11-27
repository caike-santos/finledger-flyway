package com.finledger.migration;

import lombok.extern.slf4j.Slf4j;
import org.flywaydb.core.api.callback.Callback;
import org.flywaydb.core.api.callback.Context;
import org.flywaydb.core.api.callback.Event;

@Slf4j
public class MigrationAuditCallback implements Callback {

    @Override
    public boolean supports(Event event, Context context) {
        return event == Event.BEFORE_MIGRATE || event == Event.BEFORE_EACH_MIGRATE || event == Event.AFTER_EACH_MIGRATE || event == Event.AFTER_MIGRATE || event == Event.AFTER_MIGRATE_ERROR;
    }

    @Override
    public boolean canHandleInTransaction(Event event, Context context) {
        return true;
    }

    @Override
    public void handle(Event event, Context context) {
        var info = context.getMigrationInfo();
        String version = (info != null && info.getVersion() != null)
                ? info.getVersion().getVersion()
                : "REPEATABLE";
        String description = (info != null && info.getDescription() != null)
                ? info.getDescription()
                : "N/A";

        switch (event) {
            case BEFORE_MIGRATE -> log.info("[FLYWAY] Iniciando rodada de migrations...");
            case BEFORE_EACH_MIGRATE -> log.info("[FLYWAY] Aplicando: {} ({})", version, description);
            case AFTER_EACH_MIGRATE -> log.info("[FLYWAY] Concluída: {} ({})", version, description);
            case AFTER_MIGRATE -> log.info("[FLYWAY] Rodada de migrations finalizada com sucesso.");
            case
                    AFTER_MIGRATE_ERROR -> log.error("[FLYWAY] FALHA durante a migration!");
            default -> log.error("[FLYWAY] Evento não suportado");
        }
    }

    @Override
    public String getCallbackName() {
        return "MigrationAuditCallback";
    }
}
