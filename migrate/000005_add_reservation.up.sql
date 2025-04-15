CREATE TYPE "request_type" AS ENUM (
  'PAYMENT-ISSUE',
  'TRAVEL-DELAY',
  'UNEXPECTED-RESERVED',
  'ETC.'
);

CREATE TYPE "ticket_status" AS ENUM (
  'RESERVED',
  'RESERVING',
  'CANCELED',
  'CANCELED-BY-TIME'
);

CREATE TYPE "payment_type" AS ENUM (
  'CASH',
  'CREDIT_CARD',
  'WALLET',
  'BANK_TRANSFER',
  'CRYPTO'
);

CREATE TYPE "payment_status" AS ENUM (
  'PENDING',
  'COMPLETED',
  'FAILED',
  'REFUNDED'
);

CREATE TABLE "reservation" (
  "id" bigserial PRIMARY KEY,
  "user_id" bigint NOT NULL,
  "ticket_id" bigint NOT NULL,
  "payment_id" bigint,
  "status" ticket_status NOT NULL DEFAULT 'RESERVING',
  "duration_time" interval NOT NULL DEFAULT '10 minutes',
  "created_at" timestamptz NOT NULL DEFAULT (now())
);

CREATE TABLE "payment" (
  "id" bigserial PRIMARY KEY,
  "from_account" varchar NOT NULL,
  "to_account" varchar NOT NULL,
  "amount" bigint NOT NULL,
  "type" payment_type NOT NULL,
  "status" payment_status NOT NULL DEFAULT 'PENDING',
  "created_at" timestamptz NOT NULL DEFAULT (now())
);

CREATE TABLE "change_reservation" (
  "id" bigserial PRIMARY KEY,
  "reservation_id" bigint NOT NULL,
  "admin_id" bigint,
  "user_id" bigint NOT NULL,
  "from_status" ticket_status NOT NULL,
  "to_status" ticket_status NOT NULL
);

CREATE TABLE "report" (
  "id" bigserial PRIMARY KEY,
  "reservation_id" bigint NOT NULL,
  "user_id" bigint NOT NULL,
  "admin_id" bigint NOT NULL,
  "request_type" request_type NOT NULL DEFAULT 'ETC.',
  "request_text" text NOT NULL,
  "response_text" text NOT NULL
);

CREATE INDEX ON "reservation" ("user_id");

CREATE INDEX ON "reservation" ("ticket_id");

CREATE INDEX ON "reservation" ("user_id", "ticket_id");

CREATE INDEX ON "report" ("user_id");

CREATE INDEX ON "report" ("admin_id");

CREATE INDEX ON "report" ("user_id", "admin_id");

ALTER TABLE "reservation" ADD FOREIGN KEY ("user_id") REFERENCES "user" ("id");

ALTER TABLE "reservation" ADD FOREIGN KEY ("ticket_id") REFERENCES "ticket" ("id");

ALTER TABLE "reservation" ADD FOREIGN KEY ("payment_id") REFERENCES "payment" ("id");

ALTER TABLE "change_reservation" ADD FOREIGN KEY ("reservation_id") REFERENCES "reservation" ("id");

ALTER TABLE "change_reservation" ADD FOREIGN KEY ("admin_id") REFERENCES "user" ("id");

ALTER TABLE "change_reservation" ADD FOREIGN KEY ("user_id") REFERENCES "user" ("id");

ALTER TABLE "payment" ADD CONSTRAINT amount_payment_validation CHECK (amount > 0);

ALTER TABLE "report" ADD FOREIGN KEY ("reservation_id") REFERENCES "reservation" ("id");

ALTER TABLE "report" ADD FOREIGN KEY ("admin_id") REFERENCES "user" ("id");

ALTER TABLE "report" ADD FOREIGN KEY ("user_id") REFERENCES "user" ("id");
