
CREATE ROLE vault WITH LOGIN PASSWORD 'vaultpassword';
CREATE DATABASE vault OWNER vault;
GRANT ALL PRIVILEGES ON DATABASE vault TO vault;

\connect vault

-- https://developer.hashicorp.com/vault/docs/configuration/storage/postgresql

CREATE TABLE vault_kv_store (
    parent_path TEXT COLLATE "C" NOT NULL,
    path        TEXT COLLATE "C",
    key         TEXT COLLATE "C",
    value       BYTEA,
    CONSTRAINT pkey PRIMARY KEY (path, key)
);

CREATE INDEX parent_path_idx ON vault_kv_store (parent_path);


CREATE TABLE vault_ha_locks (
    ha_key                                      TEXT COLLATE "C" NOT NULL,
    ha_identity                                 TEXT COLLATE "C" NOT NULL,
    ha_value                                    TEXT COLLATE "C",
    valid_until                                 TIMESTAMP WITH TIME ZONE NOT NULL,
    CONSTRAINT ha_key PRIMARY KEY (ha_key)
);

GRANT USAGE ON SCHEMA public TO vault;

-- Concedere permessi sulle tabelle esistenti
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO vault;

-- Concedere permessi sulle sequenze
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO vault;

-- Impostare permessi predefiniti per le tabelle future
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO vault;
