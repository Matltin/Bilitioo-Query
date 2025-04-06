  -- First, let's insert transportation companies for each vehicle type
INSERT INTO "company" ("name", "address", "type") VALUES
-- Bus companies
('Iran Peyma', 'Tehran, Azadi Ave', 'BUS'),
('Hamrah Safar', 'Tehran, Enqelab St', 'BUS'),
('Royal Safar', 'Isfahan, Chaharbagh Ave', 'BUS'),
('Hamsafar', 'Mashhad, Imam Reza Blvd', 'BUS'),
-- Train companies
('Raja Rail Transportation', 'Tehran, Railway Sq', 'TRAIN'),
('Fadak Rail', 'Tehran, Jomhouri St', 'TRAIN'),
('Safir Rail', 'Mashhad, Railway Sq', 'TRAIN'),
('Persian Rail', 'Isfahan, Railway Sq', 'TRAIN'),
-- Airline companies
('Iran Air', 'Tehran, Mehrabad Airport', 'AIRPLANE'),
('Mahan Air', 'Tehran, Azadi St', 'AIRPLANE'),
('Aseman Airlines', 'Tehran, Vali Asr St', 'AIRPLANE'),
('Iran Air Tours', 'Mashhad, Airport Blvd', 'AIRPLANE'),
('Kish Air', 'Tehran, Vanak Sq', 'AIRPLANE');

-- Now, let's create vehicles for each company
-- First for bus companies
INSERT INTO "vehicle" ("company_id", "capacity", "feature")
VALUES
-- Iran Peyma buses
(1, 44, '{"air_conditioning": true, "wifi": true, "restroom": true}'),
(1, 44, '{"air_conditioning": true, "wifi": true, "restroom": true}'),
(1, 25, '{"air_conditioning": true, "wifi": true, "restroom": true, "premium_seats": true}'),
-- Hamrah Safar buses
(2, 44, '{"air_conditioning": true, "wifi": true, "restroom": true}'),
(2, 44, '{"air_conditioning": true, "wifi": true, "restroom": true}'),
(2, 25, '{"air_conditioning": true, "wifi": true, "restroom": true, "premium_seats": true}'),
-- Royal Safar buses
(3, 44, '{"air_conditioning": true, "wifi": true, "restroom": true}'),
(3, 25, '{"air_conditioning": true, "wifi": true, "restroom": true, "premium_seats": true}'),
-- Hamsafar buses
(4, 44, '{"air_conditioning": true, "wifi": true, "restroom": true}'),
(4, 25, '{"air_conditioning": true, "wifi": true, "restroom": true, "premium_seats": true}');

-- Now for train companies
INSERT INTO "vehicle" ("company_id", "capacity", "feature")
VALUES
-- Raja Rail trains
(5, 400, '{"dining_car": true, "sleeper_cabins": true, "wifi": true}'),
(5, 400, '{"dining_car": true, "sleeper_cabins": true, "wifi": true}'),
(5, 350, '{"dining_car": true, "sleeper_cabins": false, "wifi": true}'),
-- Fadak Rail trains
(6, 350, '{"dining_car": true, "sleeper_cabins": false, "wifi": true}'),
(6, 450, '{"dining_car": true, "sleeper_cabins": true, "wifi": true, "premium_service": true}'),
-- Safir Rail trains
(7, 300, '{"dining_car": true, "sleeper_cabins": false, "wifi": true}'),
-- Persian Rail trains
(8, 400, '{"dining_car": true, "sleeper_cabins": true, "wifi": true}');

-- Airplanes
INSERT INTO "vehicle" ("company_id", "capacity", "feature")
VALUES
-- Iran Air planes
(9, 150, '{"meal_service": true, "entertainment": true}'),
(9, 180, '{"meal_service": true, "entertainment": true}'),
(9, 220, '{"meal_service": true, "entertainment": true, "premium_cabin": true}'),
-- Mahan Air planes
(10, 160, '{"meal_service": true, "entertainment": true}'),
(10, 200, '{"meal_service": true, "entertainment": true, "premium_cabin": true}'),
-- Aseman Airlines planes
(11, 120, '{"meal_service": true, "entertainment": false}'),
(11, 140, '{"meal_service": true, "entertainment": true}'),
-- Iran Air Tours planes
(12, 130, '{"meal_service": true, "entertainment": false}'),
-- Kish Air planes
(13, 150, '{"meal_service": true, "entertainment": true}');

-- Now, let's add specific details for each vehicle type
-- Buses
INSERT INTO "bus" ("vehicle_id", "VIP", "bed_chair")
VALUES
(1, false, false),
(2, false, false),
(3, true, true),
(4, false, false),
(5, false, false),
(6, true, true),
(7, false, false),
(8, true, true),
(9, false, false),
(10, true, true);

-- Trains
INSERT INTO "train" ("vehicle_id", "rank", "have_compartment")
VALUES
(11, 4, true),
(12, 4, true),
(13, 3, false),
(14, 3, false),
(15, 5, true),
(16, 3, false),
(17, 4, true);

-- Airplanes
INSERT INTO "airplane" ("vehicle_id", "flight_class", "name")
VALUES
(18, 'ECONOMY', 'Airbus A320'),
(19, 'ECONOMY', 'Boeing 737'),
(20, 'BUSINESS', 'Airbus A330'),
(21, 'ECONOMY', 'Boeing 737'),
(22, 'BUSINESS', 'Airbus A320'),
(23, 'ECONOMY', 'Fokker 100'),
(24, 'PREMIUM-ECONOMY', 'Boeing 737'),
(25, 'ECONOMY', 'MD-80'),
(26, 'PREMIUM-ECONOMY', 'Boeing 737');

DO $$
DECLARE
  rec RECORD;
  i INT;
BEGIN
  FOR rec IN (
    SELECT v.id, v.capacity, c.type AS vehicle_type
    FROM vehicle v
    JOIN company c ON c.id = v.company_id
  ) LOOP
    FOR i IN 1..rec.capacity LOOP
      INSERT INTO seat (vehicle_id, vehicle_type, seat_number)
      VALUES (rec.id, rec.vehicle_type, i);
    END LOOP;
  END LOOP;
END;
$$;