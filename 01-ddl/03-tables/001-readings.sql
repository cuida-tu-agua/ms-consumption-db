--liquibase formatted sql

--changeset esteban:ddl-table-001-readings
--comment: HU-012/015..018 raw readings of the YF-S201 (one row every 10 s per device). Append-only: NEWSEQUENTIALID (ADR-003 rule 3). UQ (device_id, recorded_at) rejects duplicated readings (HU-012)
CREATE TABLE monitoring.readings (
    id                UNIQUEIDENTIFIER NOT NULL CONSTRAINT DF_readings_id          DEFAULT (NEWSEQUENTIALID()),
    device_id         UNIQUEIDENTIFIER NOT NULL,
    place_id          UNIQUEIDENTIFIER NOT NULL,
    flow_rate_lph     DECIMAL(18,3)    NOT NULL,
    volume_liters     DECIMAL(18,3)    NOT NULL,
    cumulative_liters DECIMAL(18,3)    NOT NULL,
    recorded_at       DATETIME2        NOT NULL,
    received_at       DATETIME2        NOT NULL CONSTRAINT DF_readings_received_at DEFAULT (SYSUTCDATETIME()),
    CONSTRAINT PK_readings          PRIMARY KEY (id),
    CONSTRAINT UQ_reading_dev_time  UNIQUE (device_id, recorded_at),
    CONSTRAINT CK_reading_flow      CHECK (flow_rate_lph >= 0),
    CONSTRAINT CK_reading_volume    CHECK (volume_liters >= 0),
    CONSTRAINT CK_reading_cumulative CHECK (cumulative_liters >= 0)
);
--rollback DROP TABLE monitoring.readings;
