--liquibase formatted sql

--changeset esteban:dcl-grant-001-monitoring-rw runInTransaction:false
--comment: Minimum permissions. A reading never changes once written (no UPDATE/DELETE); the hourly totals only grow (UPDATE, no DELETE)
GRANT SELECT, INSERT, UPDATE ON SCHEMA::monitoring TO monitoring_rw;
DENY  UPDATE, DELETE         ON OBJECT::monitoring.readings              TO monitoring_rw;
DENY  DELETE                 ON OBJECT::monitoring.consumption_hourly    TO monitoring_rw;
DENY  INSERT, UPDATE, DELETE ON OBJECT::monitoring.DATABASECHANGELOG     TO monitoring_rw;
DENY  INSERT, UPDATE, DELETE ON OBJECT::monitoring.DATABASECHANGELOGLOCK TO monitoring_rw;
--rollback REVOKE INSERT, UPDATE, DELETE ON OBJECT::monitoring.DATABASECHANGELOGLOCK FROM monitoring_rw;
--rollback REVOKE INSERT, UPDATE, DELETE ON OBJECT::monitoring.DATABASECHANGELOG     FROM monitoring_rw;
--rollback REVOKE DELETE                 ON OBJECT::monitoring.consumption_hourly    FROM monitoring_rw;
--rollback REVOKE UPDATE, DELETE         ON OBJECT::monitoring.readings              FROM monitoring_rw;
--rollback REVOKE SELECT, INSERT, UPDATE ON SCHEMA::monitoring FROM monitoring_rw;
