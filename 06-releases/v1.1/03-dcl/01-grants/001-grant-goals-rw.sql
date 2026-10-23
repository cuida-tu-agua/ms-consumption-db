--liquibase formatted sql

--changeset diego:v1.1-dcl-grant-001-goals-rw runInTransaction:false
--comment: Minimum permissions. A goal is created and edited (HU-023) but never deleted: a past month keeps its goal for the history
GRANT SELECT, INSERT, UPDATE ON SCHEMA::goals TO goals_rw;
DENY  DELETE                 ON OBJECT::goals.consumption_goals TO goals_rw;
--rollback REVOKE DELETE ON OBJECT::goals.consumption_goals FROM goals_rw;
--rollback REVOKE SELECT, INSERT, UPDATE ON SCHEMA::goals FROM goals_rw;
