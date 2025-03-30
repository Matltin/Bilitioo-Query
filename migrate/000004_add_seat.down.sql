ALTER TABLE "ticket" DROP CONSTRAINT IF EXISTS "ticket_seat_id_fkey";
ALTER TABLE "seat" DROP CONSTRAINT IF EXISTS "seat_vehicle_id_fkey";
ALTER TABLE "bus_seat" DROP CONSTRAINT IF EXISTS "bus_seat_seat_id_fkey";
ALTER TABLE "train_seat" DROP CONSTRAINT IF EXISTS "train_seat_seat_id_fkey";
ALTER TABLE "airplane_seat" DROP CONSTRAINT IF EXISTS "airplane_seat_seat_id_fkey";

DROP INDEX IF EXISTS "seat_vehicle_id_idx";

ALTER TABLE "seat" DROP CONSTRAINT IF EXISTS seat_number_validation;

ALTER TABLE "train_seat" DROP CONSTRAINT IF EXISTS salon_validation;
ALTER TABLE "train_seat" DROP CONSTRAINT IF EXISTS coupe_number_validation;

DROP TABLE IF EXISTS "bus_seat";
DROP TABLE IF EXISTS "train_seat";
DROP TABLE IF EXISTS "airplane_seat";
DROP TABLE IF EXISTS "seat";
