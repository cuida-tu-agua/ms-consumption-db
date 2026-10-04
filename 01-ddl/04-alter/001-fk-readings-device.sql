--liquibase formatted sql

--changeset esteban:ddl-fk-001-fk-readings-device
--comment: readings -> devices.devices (cross-schema, ADR-002)
ALTER TABLE monitoring.readings
    ADD CONSTRAINT FK_reading_device
    FOREIGN KEY (device_id) REFERENCES devices.devices (id);
--rollback ALTER TABLE monitoring.readings DROP CONSTRAINT FK_reading_device;
