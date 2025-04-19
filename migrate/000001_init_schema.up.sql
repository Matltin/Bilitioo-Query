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
  "email" varchar ,
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
  "first_name" varchar,
  "last_name" varchar,
  "city_id" bigint ,
  "national_code" varchar
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

ALTER TABLE "profile" 
ADD CONSTRAINT profile_user_id_fkey
FOREIGN KEY ("user_id") 
REFERENCES "user" ("id")
ON DELETE CASCADE;


ALTER TABLE "profile"
ADD CONSTRAINT profile_city_id_fkey
FOREIGN KEY ("city_id")
REFERENCES "city" ("id")
ON DELETE SET NULL;