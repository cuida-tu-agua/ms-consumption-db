--liquibase formatted sql

--changeset esteban:ddl-fk-003-fk-hourly-place
--comment: consumption_hourly -> places.places
ALTER TABLE monitoring.consumption_hourly
    ADD CONSTRAINT FK_hourly_place
    FOREIGN KEY (place_id) REFERENCES places.places (id);
--rollback ALTER TABLE monitoring.consumption_hourly DROP CONSTRAINT FK_hourly_place;
