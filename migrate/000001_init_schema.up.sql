CREATE TYPE "role" AS ENUM (
  'ADMIN',
  'USER'
);

CREATE TYPE "user_status" AS ENUM (
  'ACTIVE',
  'NON-ACTIVE'
);

CREATE TABLE "user" (
  "id" bigserial PRIMARY KEY,
  "email" varchar NOT NULL,
  "phone_number" varchar(11),
  "hashed_password" varchar,
  "password_change_at" timestamptz NOT NULL DEFAULT (now()),
  "role" role NOT NULL DEFAULT 'USER',
  "status" user_status NOT NULL DEFAULT 'ACTIVE',
  "phone_verified" bool NOT NULL DEFAULT false,
  "email_verified" bool NOT NULL DEFAULT false,
  "created_at" timestamptz NOT NULL DEFAULT (now())
);

CREATE TABLE "profile" (
  "id" bigserial PRIMARY KEY,
  "user_id" bigint UNIQUE NOT NULL,
  "pic_dir" varchar,
  "first_name" varchar NOT NULL,
  "last_name" varchar NOT NULL,
  "city_id" bigint NOT NULL,
  "national_code" varchar NOT NULL
);

CREATE TABLE "report" (
  "id" bigserial PRIMARY KEY,
  "user_id" bigint NOT NULL,
  "admin_id" bigint NOT NULL,
  "request_text" text NOT NULL,
  "response_text" text NOT NULL
);


CREATE TABLE "city" (
  "id" bigserial PRIMARY KEY,
  "province" varchar NOT NULL,
  "county" varchar NOT NULL
);

ALTER TABLE "user"
ADD CONSTRAINT phone_number_check
CHECK (phone_number ~ '^09[0-9]{9}$');

ALTER TABLE "user"
ADD CONSTRAINT email_check
CHECK (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$');

ALTER TABLE "user"
ADD CONSTRAINT email_or_phone_required
CHECK (
    (email IS NOT NULL AND email <> '') OR 
    (phone_number IS NOT NULL AND phone_number <> '')
);

CREATE INDEX ON "user" ("email");
CREATE INDEX ON "user" ("phone_number");
CREATE INDEX ON "profile" ("user_id");
CREATE INDEX ON "city" ("province");
CREATE INDEX ON "city" ("county");
CREATE INDEX ON "city" ("province", "county");
CREATE INDEX ON "report" ("user_id");
CREATE INDEX ON "report" ("admin_id");
CREATE INDEX ON "report" ("user_id", "admin_id");

ALTER TABLE "report" ADD FOREIGN KEY ("admin_id") REFERENCES "user" ("id");
ALTER TABLE "profile" 
ADD FOREIGN KEY ("user_id") 
REFERENCES "user" ("id");

ALTER TABLE "profile" 
ADD FOREIGN KEY ("city_id") 
REFERENCES "city" ("id");