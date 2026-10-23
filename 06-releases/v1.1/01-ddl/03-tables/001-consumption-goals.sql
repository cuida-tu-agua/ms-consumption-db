--liquibase formatted sql

--changeset diego:v1.1-ddl-table-001-consumption-goals
--comment: HU-023/024 monthly consumption goal per place (BC-05). One goal per place and month (month_start = day 1, in the place time zone the app sends). Always stored in liters: the app converts to the place unit (m3, gallons)
CREATE TABLE goals.consumption_goals (
    id            UNIQUEIDENTIFIER NOT NULL CONSTRAINT DF_goal_id         DEFAULT (NEWID()),
    place_id      UNIQUEIDENTIFIER NOT NULL,
    month_start   DATE             NOT NULL,
    target_liters DECIMAL(18,3)    NOT NULL,
    source        NVARCHAR(15)     NOT NULL CONSTRAINT DF_goal_source     DEFAULT (N'MANUAL'),
    created_at    DATETIME2        NOT NULL CONSTRAINT DF_goal_created_at DEFAULT (SYSUTCDATETIME()),
    updated_at    DATETIME2        NOT NULL CONSTRAINT DF_goal_updated_at DEFAULT (SYSUTCDATETIME()),
    CONSTRAINT PK_consumption_goals PRIMARY KEY (id),
    CONSTRAINT UQ_goal_place_month  UNIQUE (place_id, month_start),
    CONSTRAINT CK_goal_day          CHECK (DAY(month_start) = 1),
    CONSTRAINT CK_goal_target       CHECK (target_liters > 0),
    CONSTRAINT CK_goal_source       CHECK (source IN (N'MANUAL', N'SUGGESTED', N'CARRIED_OVER'))
);
--rollback DROP TABLE goals.consumption_goals;
