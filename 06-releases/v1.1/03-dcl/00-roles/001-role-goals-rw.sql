--liquibase formatted sql

--changeset diego:v1.1-dcl-role-001-goals-rw runInTransaction:false
--comment: DB role for the goals schema + consumption_app membership
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name='goals_rw' AND type='R')
    CREATE ROLE goals_rw;
ALTER ROLE goals_rw ADD MEMBER consumption_app;
--rollback ALTER ROLE goals_rw DROP MEMBER consumption_app;
--rollback DROP ROLE goals_rw;
