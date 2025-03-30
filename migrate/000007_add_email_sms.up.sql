CREATE TYPE "activity_status" AS ENUM (
  'PENDING',
  'REMINDER-SENT',
  'PURCHASED'
);

CREATE TYPE "notification_log_status" AS ENUM (
  'SENT',
  'FAILED'
);

CREATE TABLE "user_activity" (
  "id" bigserial PRIMARY KEY,
  "user_id" bigint NOT NULL,
  "route_id" bigint NOT NULL,
  "vehicle_type" vehicle_type NOT NULL,
  "status" activity_status NOT NULL DEFAULT 'PENDING',
  "duration_time" interval NOT NULL DEFAULT '10 minutes',
  "created_at" timestamptz NOT NULL DEFAULT (now())
);

CREATE TABLE "notification_log" (
  "id" bigserial PRIMARY KEY,
  "user_id" bigint NOT NULL,
  "send_email_sms_id" bigint NOT NULL,
  "message_text" text NOT NULL,
  "user_activity_id" bigint NOT NULL
);

CREATE TABLE "send_email_sms" (
  "id" bigserial PRIMARY KEY,
  "message_type" varchar NOT NULL,
  "sent_at" timestamptz NOT NULL DEFAULT (now()),
  "status" notification_log_status NOT NULL DEFAULT 'SENT'
);

CREATE TABLE "send_verification_code" (
  "id" bigserial PRIMARY KEY,
  "user_id" bigint NOT NULL,
  "send_email_sms_id" bigint NOT NULL,
  "token" varchar NOT NULL,
  "duration_time" interval NOT NULL DEFAULT '10 minutes',
  "created_at" timestamptz NOT NULL DEFAULT (now())
);

ALTER TABLE "user_activity" 
ADD FOREIGN KEY ("user_id") 
REFERENCES "user" ("id");

ALTER TABLE "user_activity" 
ADD FOREIGN KEY ("route_id") 
REFERENCES "route" ("id");

ALTER TABLE "notification_log" 
ADD FOREIGN KEY ("user_id") 
REFERENCES "user" ("id");

ALTER TABLE "notification_log" 
ADD FOREIGN KEY ("send_email_sms_id") 
REFERENCES "send_email_sms" ("id");

ALTER TABLE "notification_log" 
ADD FOREIGN KEY ("user_activity_id") 
REFERENCES "user_activity" ("id");

ALTER TABLE "send_verification_code" 
ADD FOREIGN KEY ("user_id") 
REFERENCES "user" ("id");

ALTER TABLE "send_verification_code" 
ADD FOREIGN KEY ("send_email_sms_id") 
REFERENCES "send_email_sms" ("id");

ALTER TABLE "user_activity"
ADD CONSTRAINT duration_time_user_activity_validation
CHECK (departure_time > 0);

ALTER TABLE "send_verification_code"
ADD CONSTRAINT duration_time_send_verification_code_validation
CHECK (departure_time > 0);