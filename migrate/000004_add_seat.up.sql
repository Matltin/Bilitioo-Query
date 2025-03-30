CREATE TABLE "seat" (
  "id" bigserial PRIMARY KEY,
  "vehicle_id" bigint NOT NULL,
  "vehicle_type" vehicle_type NOT NULL,
  "seat_number" varchar NOT NULL,
  "is_available" boolean NOT NULL DEFAULT true
);

CREATE TABLE "bus_seat" (
  "seat_id" bigint NOT NULL
);

CREATE TABLE "train_seat" (
  "seat_id" bigint NOT NULL,
  "salon" int NOT NULL,
  "have_compartment" boolean NOT NULL DEFAULT false,
  "cuope_number" int
);

CREATE TABLE "airplane_seat" (
  "seat_id" bigint NOT NULL
);

CREATE INDEX ON "seat" ("vehicle_id");

ALTER TABLE "ticket" ADD FOREIGN KEY ("seat_id") REFERENCES "seat" ("id");

ALTER TABLE "seat" ADD FOREIGN KEY ("vehicle_id") REFERENCES "vehicle" ("id");

ALTER TABLE "bus_seat" ADD FOREIGN KEY ("seat_id") REFERENCES "seat" ("id");

ALTER TABLE "train_seat" ADD FOREIGN KEY ("seat_id") REFERENCES "seat" ("id");

ALTER TABLE "airplane_seat" ADD FOREIGN KEY ("seat_id") REFERENCES "seat" ("id");

ALTER TABLE "seat" ADD CONSTRAINT seat_number_validation CHECK (seat_number > 0);

ALTER TABLE "train_seat" ADD CONSTRAINT salon_validation CHECK (salon > 0);

ALTER TABLE "train_seat" ADD CONSTRAINT coupe_number_validation CHECK (cuope_number > 0);

