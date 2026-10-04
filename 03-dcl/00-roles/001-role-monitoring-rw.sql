--liquibase formatted sql

--changeset esteban:dcl-role-001-monitoring-rw runInTransaction:false
--comment: DB role for app read/write + consumption_app membership
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name='monitoring_rw' AND type='R')
    CREATE ROLE monitoring_rw;
ALTER ROLE monitoring_rw ADD MEMBER consumption_app;
--rollback ALTER ROLE monitoring_rw DROP MEMBER consumption_app;
--rollback DROP ROLE monitoring_rw;
