-- Add default payments migration script
-- File: migrate/000012_default_reservations.up.sql

-- First, create some payments
INSERT INTO "payment" (
  "from_account",
  "to_account",
  "amount",
  "type",
  "status",
  "created_at"
) VALUES
-- Completed payments
('6037-9912-3456-7890', 'IR650170000000123456789', 650000, 'CREDIT_CARD', 'COMPLETED', NOW() - INTERVAL '5 day'),
('6219-8612-3456-7891', 'IR650170000000123456789', 1200000, 'CREDIT_CARD', 'COMPLETED', NOW() - INTERVAL '4 day'),
('6037-9912-3456-7892', 'IR650170000000123456789', 750000, 'CREDIT_CARD', 'COMPLETED', NOW() - INTERVAL '3 day'),
('user1@example.com', 'IR650170000000123456789', 2500000, 'WALLET', 'COMPLETED', NOW() - INTERVAL '2 day'),
('6219-8612-3456-7893', 'IR650170000000123456789', 1500000, 'CREDIT_CARD', 'COMPLETED', NOW() - INTERVAL '2 day'),
-- Pending payments
('6037-9912-3456-7894', 'IR650170000000123456789', 950000, 'CREDIT_CARD', 'PENDING', NOW() - INTERVAL '1 day'),
('user2@example.com', 'IR650170000000123456789', 3800000, 'WALLET', 'PENDING', NOW() - INTERVAL '12 hour'),
-- Failed payment
('6104-3378-3456-7895', 'IR650170000000123456789', 1800000, 'CREDIT_CARD', 'FAILED', NOW() - INTERVAL '3 day');

-- Now create reservations linked to those payments
INSERT INTO "reservation" (
  "user_id",
  "ticket_id",
  "payment_id",
  "status",
  "duration_time",
  "created_at"
) VALUES
-- Completed reservations for user1 (Hassan Karimi)
(
  (SELECT id FROM "user" WHERE email = 'user1@example.com'),
  (SELECT id FROM "ticket" WHERE vehicle_id = 1 AND seat_id = (SELECT MIN(id) FROM "seat" WHERE vehicle_id = 1) LIMIT 1),
  (SELECT id FROM "payment" WHERE from_account = '6037-9912-3456-7890' AND amount = 650000),
  'RESERVED',
  '10 minutes',
  NOW() - INTERVAL '5 day'
),
(
  (SELECT id FROM "user" WHERE email = 'user1@example.com'),
  (SELECT id FROM "ticket" WHERE vehicle_id = 18 AND seat_id = (SELECT MIN(id) FROM "seat" WHERE vehicle_id = 18) LIMIT 1),
  (SELECT id FROM "payment" WHERE from_account = 'user1@example.com' AND amount = 2500000),
  'RESERVED',
  '10 minutes',
  NOW() - INTERVAL '2 day'
),

-- Completed reservation for user2 (Zahra Rahimi)
(
  (SELECT id FROM "user" WHERE email = 'user2@example.com'),
  (SELECT id FROM "ticket" WHERE vehicle_id = 3 AND seat_id = (SELECT MIN(id) FROM "seat" WHERE vehicle_id = 3) LIMIT 1),
  (SELECT id FROM "payment" WHERE from_account = '6219-8612-3456-7891' AND amount = 1200000),
  'RESERVED',
  '10 minutes',
  NOW() - INTERVAL '4 day'
),

-- Pending reservation for user2
(
  (SELECT id FROM "user" WHERE email = 'user2@example.com'),
  (SELECT id FROM "ticket" WHERE vehicle_id = 22 AND seat_id = (SELECT MIN(id) FROM "seat" WHERE vehicle_id = 22) LIMIT 1),
  (SELECT id FROM "payment" WHERE from_account = 'user2@example.com' AND amount = 3800000),
  'RESERVING',
  '10 minutes',
  NOW() - INTERVAL '12 hour'
),

-- Completed reservation for user3 (Mohammad Ghasemi)
(
  (SELECT id FROM "user" WHERE email = 'user3@example.com'),
  (SELECT id FROM "ticket" WHERE vehicle_id = 5 AND seat_id = (SELECT MIN(id) FROM "seat" WHERE vehicle_id = 5) LIMIT 1),
  (SELECT id FROM "payment" WHERE from_account = '6037-9912-3456-7892' AND amount = 750000),
  'RESERVED',
  '10 minutes',
  NOW() - INTERVAL '3 day'
),

-- Completed reservation for user4 (Sara Jafari)
(
  (SELECT id FROM "user" WHERE email = 'user4@example.com'),
  (SELECT id FROM "ticket" WHERE vehicle_id = 11 AND seat_id = (SELECT MIN(id) FROM "seat" WHERE vehicle_id = 11) LIMIT 1),
  (SELECT id FROM "payment" WHERE from_account = '6219-8612-3456-7893' AND amount = 1500000),
  'RESERVED',
  '10 minutes',
  NOW() - INTERVAL '2 day'
),

-- Pending reservation for user5 (Amir Moradi)
(
  (SELECT id FROM "user" WHERE email = 'user5@example.com'),
  (SELECT id FROM "ticket" WHERE vehicle_id = 8 AND seat_id = (SELECT MIN(id) FROM "seat" WHERE vehicle_id = 8) LIMIT 1),
  (SELECT id FROM "payment" WHERE from_account = '6037-9912-3456-7894' AND amount = 950000),
  'RESERVING',
  '15 minutes', -- Extended duration time
  NOW() - INTERVAL '1 day'
),

-- Failed reservation for phone-only user
(
  (SELECT id FROM "user" WHERE phone_number = '09123456705'),
  (SELECT id FROM "ticket" WHERE vehicle_id = 15 AND seat_id = (SELECT MIN(id) FROM "seat" WHERE vehicle_id = 15) LIMIT 1),
  (SELECT id FROM "payment" WHERE from_account = '6104-3378-3456-7895' AND amount = 1800000),
  'CANCELED',
  '10 minutes',
  NOW() - INTERVAL '3 day'
),

-- Canceled reservation for email-only user
(
  (SELECT id FROM "user" WHERE email = 'user8@example.com'),
  (SELECT id FROM "ticket" WHERE vehicle_id = 26 AND seat_id = (SELECT MIN(id) FROM "seat" WHERE vehicle_id = 26) LIMIT 1),
  (SELECT id FROM "payment" WHERE from_account = '6037-9912-3456-7896' AND amount = 3200000),
  'CANCELED-BY-TIME',
  '10 minutes',
  NOW() - INTERVAL '5 day'
);

-- Create a few admin changes to reservations
INSERT INTO "admin_change_reservation" (
  "reservation_id",
  "admin_id",
  "user_id",
  "from_status",
  "to_status"
) VALUES
-- Admin canceled a reservation
(
  (SELECT id FROM "reservation" WHERE
    user_id = (SELECT id FROM "user" WHERE email = 'user8@example.com') AND
    status = 'CANCELED-BY-TIME' LIMIT 1),
  (SELECT id FROM "user" WHERE email = 'admin@transport.ir'),
  (SELECT id FROM "user" WHERE email = 'user8@example.com'),
  'RESERVED',
  'CANCELED-BY-TIME'
),
-- Support admin helped with a reservation
(
  (SELECT id FROM "reservation" WHERE
    user_id = (SELECT id FROM "user" WHERE email = 'user1@example.com') AND
    ticket_id = (SELECT id FROM "ticket" WHERE vehicle_id = 1 LIMIT 1)),
  (SELECT id FROM "user" WHERE email = 'support@transport.ir'),
  (SELECT id FROM "user" WHERE email = 'user1@example.com'),
  'RESERVING',
  'RESERVED'
);

-- Update ticket status to match reservations
UPDATE "ticket"
SET "status" = 'RESERVED'
WHERE id IN (
  SELECT ticket_id FROM "reservation" WHERE status = 'RESERVED'
);