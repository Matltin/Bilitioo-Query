ALTER TABLE "report" DROP CONSTRAINT "report_admin_id_fkey";
ALTER TABLE "profile" DROP CONSTRAINT "profile_user_id_fkey";
ALTER TABLE "profile" DROP CONSTRAINT "profile_city_id_fkey";

DROP INDEX IF EXISTS "user_email_idx";
DROP INDEX IF EXISTS "user_phone_number_idx";
DROP INDEX IF EXISTS "profile_user_id_idx";
DROP INDEX IF EXISTS "city_province_idx";
DROP INDEX IF EXISTS "city_county_idx";
DROP INDEX IF EXISTS "city_province_county_idx";
DROP INDEX IF EXISTS "report_user_id_idx";
DROP INDEX IF EXISTS "report_admin_id_idx";
DROP INDEX IF EXISTS "report_user_id_admin_id_idx";

ALTER TABLE "user" DROP CONSTRAINT IF EXISTS phone_number_check;
ALTER TABLE "user" DROP CONSTRAINT IF EXISTS email_check;
ALTER TABLE "user" DROP CONSTRAINT IF EXISTS email_or_phone_required;

DROP TABLE IF EXISTS "report";
DROP TABLE IF EXISTS "profile";
DROP TABLE IF EXISTS "city";
DROP TABLE IF EXISTS "user";

DROP TYPE IF EXISTS "role";
DROP TYPE IF EXISTS "user_status";
