--liquibase formatted sql

--changeset diego:v1.1-ddl-fk-001-fk-goal-place
--comment: consumption_goals.place_id -> places.places (cross-schema, ADR-002). Places are soft-deleted, so the FK never blocks deleting a place
ALTER TABLE goals.consumption_goals
    ADD CONSTRAINT FK_goal_place
    FOREIGN KEY (place_id) REFERENCES places.places (id);
--rollback ALTER TABLE goals.consumption_goals DROP CONSTRAINT FK_goal_place;
