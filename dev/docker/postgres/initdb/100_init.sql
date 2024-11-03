-- Crea il ruolo 'keystone' con password
CREATE ROLE keystone WITH LOGIN PASSWORD 'password123';

-- Crea il database 'keystone' e assegna la proprietà al ruolo 'keystone'
CREATE DATABASE keystone OWNER keystone;

-- Concede tutti i privilegi sul database 'keystone' al ruolo 'keystone'
GRANT ALL PRIVILEGES ON DATABASE keystone TO keystone;
