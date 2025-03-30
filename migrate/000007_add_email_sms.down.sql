ALTER TABLE "user_activity" DROP CONSTRAINT IF EXISTS "user_activity_user_id_fkey";
ALTER TABLE "user_activity" DROP CONSTRAINT IF EXISTS "user_activity_route_id_fkey";
ALTER TABLE "notification_log" DROP CONSTRAINT IF EXISTS "notification_log_user_id_fkey";
ALTER TABLE "notification_log" DROP CONSTRAINT IF EXISTS "notification_log_send_email_sms_id_fkey";
ALTER TABLE "notification_log" DROP CONSTRAINT IF EXISTS "notification_log_user_activity_id_fkey";
ALTER TABLE "send_verification_code" DROP CONSTRAINT IF EXISTS "send_verification_code_user_id_fkey";
ALTER TABLE "send_verification_code" DROP CONSTRAINT IF EXISTS "send_verification_code_send_email_sms_id_fkey";

ALTER TABLE "user_activity" DROP CONSTRAINT IF EXISTS duration_time_user_activity_validation;
ALTER TABLE "send_verification_code" DROP CONSTRAINT IF EXISTS duration_time_send_verification_code_validation;

DROP TABLE IF EXISTS "notification_log";
DROP TABLE IF EXISTS "send_verification_code";
DROP TABLE IF EXISTS "send_email_sms";
DROP TABLE IF EXISTS "user_activity";

DROP TYPE IF EXISTS "activity_status";
DROP TYPE IF EXISTS "notification_log_status";
