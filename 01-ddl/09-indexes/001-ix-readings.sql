--liquibase formatted sql

--changeset esteban:ddl-index-001-ix-readings
--comment: HU-018 "the latest reading of this place" (current flow) without scanning the table
CREATE INDEX IX_reading_place_time ON monitoring.readings (place_id, recorded_at DESC) INCLUDE (flow_rate_lph);
--rollback DROP INDEX IX_reading_place_time ON monitoring.readings;
