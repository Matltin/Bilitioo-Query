
ALTER TABLE "reservation" DROP CONSTRAINT IF EXISTS "reservation_user_id_fkey";
ALTER TABLE "reservation" DROP CONSTRAINT IF EXISTS "reservation_ticket_id_fkey";
ALTER TABLE "reservation" DROP CONSTRAINT IF EXISTS "reservation_payment_id_fkey";
ALTER TABLE "admin_change_reservation" DROP CONSTRAINT IF EXISTS "admin_change_reservation_reservation_id_fkey";
ALTER TABLE "admin_change_reservation" DROP CONSTRAINT IF EXISTS "admin_change_reservation_admin_id_fkey";
ALTER TABLE "admin_change_reservation" DROP CONSTRAINT IF EXISTS "admin_change_reservation_user_id_fkey";

DROP INDEX IF EXISTS "reservation_user_id_idx";
DROP INDEX IF EXISTS "reservation_ticket_id_idx";
DROP INDEX IF EXISTS "reservation_user_id_ticket_id_idx";

ALTER TABLE "payment" DROP CONSTRAINT IF EXISTS amount_payment_validation;

ALTER TABLE "reservation" DROP CONSTRAINT IF EXISTS duration_time_reservation_validation;

DROP TABLE IF EXISTS "admin_change_reservation";
DROP TABLE IF EXISTS "reservation";
DROP TABLE IF EXISTS "payment";

DROP TYPE IF EXISTS "ticket_status";
DROP TYPE IF EXISTS "payment_type";
DROP TYPE IF EXISTS "payment_status";
