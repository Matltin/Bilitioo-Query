ALTER TABLE "ticket" DROP CONSTRAINT IF EXISTS "ticket_vehicle_id_fkey";
ALTER TABLE "vehicle" DROP CONSTRAINT IF EXISTS "vehicle_company_id_fkey";
ALTER TABLE "bus" DROP CONSTRAINT IF EXISTS "bus_vehicle_id_fkey";
ALTER TABLE "train" DROP CONSTRAINT IF EXISTS "train_vehicle_id_fkey";
ALTER TABLE "airplane" DROP CONSTRAINT IF EXISTS "airplane_vehicle_id_fkey";

DROP INDEX IF EXISTS "ticket_route_id_idx";
DROP INDEX IF EXISTS "ticket_departure_time_idx";
DROP INDEX IF EXISTS "ticket_route_id_departure_time_vehicle_id_idx";
DROP INDEX IF EXISTS "vehicle_company_id_idx";

ALTER TABLE "ticket" DROP CONSTRAINT IF EXISTS amount_validation;
ALTER TABLE "ticket" DROP CONSTRAINT IF EXISTS time_validation;
ALTER TABLE "ticket" DROP CONSTRAINT IF EXISTS count_stand_validation;

ALTER TABLE "vehicle" DROP CONSTRAINT IF EXISTS capacity_validation;

ALTER TABLE "train" DROP CONSTRAINT IF EXISTS rank_validation;

DROP TABLE IF EXISTS "ticket";
DROP TABLE IF EXISTS "vehicle";
DROP TABLE IF EXISTS "company";
DROP TABLE IF EXISTS "bus";
DROP TABLE IF EXISTS "train";
DROP TABLE IF EXISTS "airplane";

DROP TYPE IF EXISTS "check_reservation_ticket_status";
DROP TYPE IF EXISTS "vehicle_type";
DROP TYPE IF EXISTS "flight_class";
