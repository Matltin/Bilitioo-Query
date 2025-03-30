ALTER TABLE "ticket" DROP CONSTRAINT IF EXISTS "ticket_route_id_fkey";
ALTER TABLE "route" DROP CONSTRAINT IF EXISTS "route_origin_city_id_fkey";
ALTER TABLE "route" DROP CONSTRAINT IF EXISTS "route_destination_city_id_fkey";
ALTER TABLE "route" DROP CONSTRAINT IF EXISTS "route_origin_terminal_id_fkey";
ALTER TABLE "route" DROP CONSTRAINT IF EXISTS "route_destination_terminal_id_fkey";

DROP INDEX IF EXISTS "route_origin_city_id_idx";
DROP INDEX IF EXISTS "route_destination_city_id_idx";
DROP INDEX IF EXISTS "route_origin_terminal_id_idx";
DROP INDEX IF EXISTS "route_origin_city_id_destination_city_id_idx";
DROP INDEX IF EXISTS "route_destination_terminal_id_idx";
DROP INDEX IF EXISTS "route_origin_terminal_id_destination_terminal_id_idx";

ALTER TABLE "route" DROP CONSTRAINT IF EXISTS distance_validation;

DROP TABLE IF EXISTS "route";
DROP TABLE IF EXISTS "terminal";
