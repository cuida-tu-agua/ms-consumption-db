--liquibase formatted sql

--changeset esteban:ddl-table-002-consumption-hourly
--comment: HU-015..017 liters per place per UTC hour, updated with every reading. Day / week / month are sums of these rows (in the user's time zone)
CREATE TABLE monitoring.consumption_hourly (
    id            UNIQUEIDENTIFIER NOT NULL CONSTRAINT DF_hourly_id         DEFAULT (NEWID()),
    place_id      UNIQUEIDENTIFIER NOT NULL,
    hour_start    DATETIME2        NOT NULL,
    total_liters  DECIMAL(18,3)    NOT NULL CONSTRAINT DF_hourly_total      DEFAULT (0),
    reading_count INT              NOT NULL CONSTRAINT DF_hourly_count      DEFAULT (0),
    created_at    DATETIME2        NOT NULL CONSTRAINT DF_hourly_created_at DEFAULT (SYSUTCDATETIME()),
    updated_at    DATETIME2        NOT NULL CONSTRAINT DF_hourly_updated_at DEFAULT (SYSUTCDATETIME()),
    CONSTRAINT PK_consumption_hourly  PRIMARY KEY (id),
    CONSTRAINT UQ_hourly_place_hour   UNIQUE (place_id, hour_start),
    CONSTRAINT CK_hourly_total        CHECK (total_liters >= 0),
    CONSTRAINT CK_hourly_count        CHECK (reading_count >= 0),
    CONSTRAINT CK_hourly_whole_hour   CHECK (DATEPART(MINUTE, hour_start) = 0 AND DATEPART(SECOND, hour_start) = 0
                                             AND DATEPART(NANOSECOND, hour_start) = 0)
);
--rollback DROP TABLE monitoring.consumption_hourly;
