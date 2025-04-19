CREATE TABLE "route" (
  "id" bigserial PRIMARY KEY,
  "origin_city_id" bigint NOT NULL,
  "destination_city_id" bigint NOT NULL,
  "origin_terminal_id" bigint,
  "destination_terminal_id" bigint,
  "distance" int NOT NULL
);

CREATE TABLE "terminal" (
  "id" bigserial PRIMARY KEY,
  "name" text NOT NULL,
  "address" text NOT NULL
);

CREATE INDEX ON "route" ("origin_city_id");
CREATE INDEX ON "route" ("destination_city_id");
CREATE INDEX ON "route" ("origin_terminal_id");
CREATE INDEX ON "route" ("origin_city_id", "destination_city_id");
CREATE INDEX ON "route" ("destination_terminal_id");
CREATE INDEX ON "route" ("origin_terminal_id", "destination_terminal_id");

ALTER TABLE "ticket"
ADD CONSTRAINT ticket_route_id_fkey
FOREIGN KEY ("route_id") REFERENCES "route"("id") ON DELETE CASCADE;

ALTER TABLE "route"
ADD CONSTRAINT route_origin_city_id_fkey
FOREIGN KEY ("origin_city_id") REFERENCES "city"("id") ON DELETE CASCADE;

ALTER TABLE "route"
ADD CONSTRAINT route_destination_city_id_fkey
FOREIGN KEY ("destination_city_id") REFERENCES "city"("id") ON DELETE CASCADE;

ALTER TABLE "route"
ADD CONSTRAINT route_origin_terminal_id_fkey
FOREIGN KEY ("origin_terminal_id") REFERENCES "terminal"("id") ON DELETE CASCADE;

ALTER TABLE "route"
ADD CONSTRAINT route_destination_terminal_id_fkey
FOREIGN KEY ("destination_terminal_id") REFERENCES "terminal"("id") ON DELETE CASCADE;

ALTER TABLE "route"
ADD CONSTRAINT distance_validation
CHECK (distance > 0)