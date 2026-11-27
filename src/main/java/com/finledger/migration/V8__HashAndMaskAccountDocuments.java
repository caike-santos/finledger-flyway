package com.finledger.migration;

import org.flywaydb.core.api.migration.BaseJavaMigration;
import org.flywaydb.core.api.migration.Context;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.HexFormat;
import java.util.UUID;

/**
 * Fase 3 (Bloco 3A) — Java-based Migration (LGPD: Hash + Máscara de Documentos).
 *
 * Por que o nome da classe segue `V8__HashAndMaskAccountDocuments`?
 *   `BaseJavaMigration` extrai automaticamente a versão ("8") e a descrição
 *   ("HashAndMaskAccountDocuments") do próprio nome da classe!
 *
 * Por que NÃO injetar JpaRepository aqui?
 *   O Flyway executa ANTES do Hibernate/EntityManagerFactory existir — além disso,
 *   entidades mudam com o tempo, enquanto migrations históricas precisam continuar
 *   funcionando anos depois. Use sempre JDBC via `context.getConnection()`!
 */
public class V8__HashAndMaskAccountDocuments extends BaseJavaMigration {

    private final String documentPepper;

    public V8__HashAndMaskAccountDocuments(String documentPepper) {
        this.documentPepper = documentPepper;
    }

    @Override
    public Integer getChecksum() {
        return 1001;
    }

    @Override
    public void migrate(Context context) throws Exception {
        Connection connection = context.getConnection();

        String selectSql = "SELECT id, document_number FROM accounts WHERE document_hash IS NULL";
        String updateSql = "UPDATE accounts SET document_hash = ?, document_masked = ? WHERE id = ?";
        try (PreparedStatement selectStmt = connection.prepareStatement(selectSql);
             ResultSet rs = selectStmt.executeQuery();
             PreparedStatement updateStmt = connection.prepareStatement(updateSql)) {
            while (rs.next()) {
                UUID id = rs.getObject("id", UUID.class);
                String documentNumber = rs.getString("document_number");
                String hash = sha256Hex(documentPepper + ":" + documentNumber);
                String masked = maskDocument(documentNumber);
                updateStmt.setString(1, hash);
                updateStmt.setString(2, masked);
                updateStmt.setObject(3, id);
                updateStmt.addBatch();
            }
            updateStmt.executeBatch();
        }
    }

    private String sha256Hex(String input) throws Exception {
        MessageDigest digest = MessageDigest.getInstance("SHA-256");
        byte[] hashBytes = digest.digest(input.getBytes(StandardCharsets.UTF_8));
        return HexFormat.of().formatHex(hashBytes);
    }

    private String maskDocument(String rawDocument) {
        if (rawDocument == null || rawDocument.isBlank()) {
            return "****";
        }
        if (rawDocument.length() <= 4) {
            return "*".repeat(rawDocument.length());
        }
        int maskLength = rawDocument.length() - 4;
        return "*".repeat(maskLength) + rawDocument.substring(maskLength);
    }
}
