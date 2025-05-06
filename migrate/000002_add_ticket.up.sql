CREATE TYPE "check_reservation_ticket_status" AS ENUM (
    'RESERVED',
    'NOT_RESERVED'
);

CREATE TYPE "vehicle_type" AS ENUM (
  'BUS',
  'TRAIN',
  'AIRPLANE'
);

CREATE TYPE "flight_class" AS ENUM (
  'ECONOMY',
  'PREMIUM-ECONOMY',
  'BUSINESS',
  'FIRST'
);


CREATE TABLE "ticket" (
  "id" bigserial PRIMARY KEY,
  "vehicle_id" bigint NOT NULL,
  "seat_id" bigint NOT NULL,
  "vehicle_type" vehicle_type NOT NULL,
  "route_id" bigint NOT NULL,
  "amount" bigint NOT NULL,
  "departure_time" timestamptz NOT NULL,
  "arrival_time" timestamptz NOT NULL,
  "count_stand" int NOT NULL DEFAULT 0,
  "status" check_reservation_ticket_status NOT NULL DEFAULT 'NOT_RESERVED',
  "created_at" timestamptz NOT NULL DEFAULT (now())
);

CREATE TABLE "vehicle" (
  "id" bigserial PRIMARY KEY,
  "company_id" bigint NOT NULL,
  "capacity" int NOT NULL,
  "vehicle_type" vehicle_type NOT NULL,
  "feature" json NOT NULL
);

CREATE TABLE "company" (
  "id" bigserial PRIMARY KEY,
  "name" text NOT NULL,
  "address" text NOT NULL
);

CREATE TABLE "bus" (
  "vehicle_id" bigint NOT NULL,
  "VIP" boolean NOT NULL DEFAULT false,
  "bed_chair" boolean NOT NULL DEFAULT false
);

CREATE TABLE "train" (
  "vehicle_id" bigint NOT NULL,
  "rank" int NOT NULL DEFAULT 3,
  "have_compartment" boolean NOT NULL DEFAULT false
);

CREATE TABLE "airplane" (
  "vehicle_id" bigint NOT NULL,
  "flight_class" flight_class NOT NULL,
  "name" varchar NOT NULL
);

CREATE INDEX ON "ticket" ("route_id");

CREATE INDEX ON "ticket" ("departure_time");

CREATE INDEX ON "ticket" ("route_id", "departure_time", "vehicle_id");

CREATE INDEX ON "vehicle" ("company_id");

ALTER TABLE "ticket" ADD FOREIGN KEY ("vehicle_id") REFERENCES "vehicle" ("id");

ALTER TABLE "vehicle" ADD FOREIGN KEY ("company_id") REFERENCES "company" ("id");

ALTER TABLE "bus" ADD FOREIGN KEY ("vehicle_id") REFERENCES "vehicle" ("id");

ALTER TABLE "train" ADD FOREIGN KEY ("vehicle_id") REFERENCES "vehicle" ("id");

ALTER TABLE "airplane" ADD FOREIGN KEY ("vehicle_id") REFERENCES "vehicle" ("id");

ALTER TABLE "ticket" ADD CONSTRAINT amount_validation CHECK (amount > 0);

ALTER TABLE "ticket" ADD CONSTRAINT time_validation CHECK (arrival_time > departure_time);

ALTER TABLE "ticket" ADD CONSTRAINT count_stand_validation CHECK (count_stand >= 0);

ALTER TABLE "vehicle" ADD CONSTRAINT capacity_validation CHECK (capacity > 0);

ALTER TABLE "train" ADD CONSTRAINT rank_validation CHECK (rank BETWEEN 3 AND 5);