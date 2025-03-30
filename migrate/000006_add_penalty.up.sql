CREATE TABLE "penalty" (
  "id" bigserial PRIMARY KEY,
  "vehicle_id" bigint NOT NULL,
  "penalty_text" text NOT NULL
);

ALTER TABLE "penalty" 
ADD FOREIGN KEY ("vehicle_id") 
REFERENCES "vehicle" ("id");
