--liquibase formatted sql

--changeset esteban:ddl-fk-002-fk-readings-place
--comment: readings -> places.places (D1: place_id is copied into each reading to avoid huge JOINs)
ALTER TABLE monitoring.readings
    ADD CONSTRAINT FK_reading_place
    FOREIGN KEY (place_id) REFERENCES places.places (id);
--rollback ALTER TABLE monitoring.readings DROP CONSTRAINT FK_reading_place;
