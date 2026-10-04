-- sqlserver-init/00-init.sql
-- Runs once as sa. The database comes from ms-iam-db, places.places from ms-places-db
-- and devices.devices from ms-device-db: run those three first.
IF DB_ID('sy-water-db') IS NULL
    THROW 50001, 'Database sy-water-db does not exist. Run ms-iam-db first.', 1;
GO

USE [sy-water-db];
GO

IF OBJECT_ID(N'places.places', N'U') IS NULL
    THROW 50002, 'Table places.places does not exist. Run ms-places-db first.', 1;
IF OBJECT_ID(N'devices.devices', N'U') IS NULL
    THROW 50003, 'Table devices.devices does not exist. Run ms-device-db first.', 1;
GO

IF SCHEMA_ID('monitoring') IS NULL
    EXEC('CREATE SCHEMA monitoring');
GO

-- Runtime user for consumption-service
IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name='consumption_app')
    CREATE LOGIN consumption_app WITH PASSWORD='$(CONSUMPTION_APP_PASSWORD)';
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name='consumption_app')
BEGIN
    CREATE USER consumption_app FOR LOGIN consumption_app
        WITH DEFAULT_SCHEMA = monitoring;
END
GO

-- Migration user for Liquibase
IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name='consumption_migrator')
    CREATE LOGIN consumption_migrator WITH PASSWORD='$(CONSUMPTION_MIGRATOR_PASSWORD)';
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name='consumption_migrator')
BEGIN
    CREATE USER consumption_migrator FOR LOGIN consumption_migrator
        WITH DEFAULT_SCHEMA = monitoring;
END
GO

GRANT CONTROL ON SCHEMA::monitoring TO consumption_migrator;
GRANT CREATE TABLE TO consumption_migrator;
GRANT CREATE ROLE TO consumption_migrator;
GRANT ALTER ANY ROLE TO consumption_migrator;
GO

-- Needed to create the cross-schema FKs (places.places and devices.devices)
GRANT REFERENCES ON OBJECT::places.places   TO consumption_migrator;
GRANT REFERENCES ON OBJECT::devices.devices TO consumption_migrator;
GO
