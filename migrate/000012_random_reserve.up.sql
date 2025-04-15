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

-- Admin canceled a reservation (for user8@example.com), admin_id = NULL since it's BY-TIME
INSERT INTO "change_reservation" (
  reservation_id, admin_id, user_id, from_status, to_status
)
SELECT
  r.id,
  NULL,
  user8.id,
  'RESERVED',
  'CANCELED-BY-TIME'
FROM "reservation" r
JOIN "user" user8 ON r.user_id = user8.id AND user8.email = 'user8@example.com'
WHERE r.status = 'CANCELED-BY-TIME'
LIMIT 1;

-- Support admin helped change a reservation (for user1@example.com)
INSERT INTO "change_reservation" (
  reservation_id, admin_id, user_id, from_status, to_status
)
SELECT
  r.id,
  support.id,
  user1.id,
  'RESERVING',
  'RESERVED'
FROM "reservation" r
JOIN "user" user1 ON r.user_id = user1.id AND user1.email = 'user1@example.com'
JOIN "user" support ON support.email = 'support@transport.ir'
JOIN "ticket" t ON r.ticket_id = t.id AND t.vehicle_id = 1
LIMIT 1;

-- A user made a manual status change (user3@example.com updated their own reservation)
INSERT INTO "change_reservation" (
  reservation_id, admin_id, user_id, from_status, to_status
)
SELECT
  r.id,
  1,
  user3.id,
  'RESERVED',
  'CANCELED'
FROM "reservation" r
JOIN "user" user3 ON r.user_id = user3.id AND user3.email = 'user3@example.com'
WHERE r.status = 'RESERVED'
LIMIT 1;

-- Another admin-assisted status correction (for user2@example.com)
INSERT INTO "change_reservation" (
  reservation_id, admin_id, user_id, from_status, to_status
)
SELECT
  r.id,
  admin2.id,
  user2.id,
  'RESERVING',
  'RESERVED'
FROM "reservation" r
JOIN "user" user2 ON r.user_id = user2.id AND user2.email = 'user2@example.com'
JOIN "user" admin2 ON admin2.email = 'admin2@transport.ir'
JOIN "ticket" t ON r.ticket_id = t.id AND t.vehicle_id = 22
WHERE r.status = 'RESERVING'
LIMIT 1;

-- Admin changed from RESERVED to CANCELED (for user4@example.com)
INSERT INTO "change_reservation" (
  reservation_id, admin_id, user_id, from_status, to_status
)
SELECT
  r.id,
  admin3.id,
  user4.id,
  'RESERVED',
  'CANCELED'
FROM "reservation" r
JOIN "user" user4 ON r.user_id = user4.id AND user4.email = 'user4@example.com'
JOIN "user" admin3 ON admin3.email = 'admin3@transport.ir'
WHERE r.status = 'CANCELED'
LIMIT 1;

-- Admin restored from CANCELED to RESERVED (for user5@example.com)
INSERT INTO "change_reservation" (
  reservation_id, admin_id, user_id, from_status, to_status
)
SELECT
  r.id,
  admin4.id,
  user5.id,
  'CANCELED',
  'RESERVED'
FROM "reservation" r
JOIN "user" user5 ON r.user_id = user5.id AND user5.email = 'user5@example.com'
JOIN "user" admin4 ON admin4.email = 'admin4@transport.ir'
WHERE r.status = 'RESERVED'
LIMIT 1;


-- Update ticket status to match reservations
UPDATE "ticket"
SET "status" = 'RESERVED'
WHERE id IN (
  SELECT ticket_id FROM "reservation" WHERE status = 'RESERVED'
);

INSERT INTO report (
  reservation_id, user_id, admin_id, request_type, request_text, response_text
) VALUES (
  (SELECT id FROM reservation 
   WHERE user_id = (SELECT id FROM "user" WHERE email = 'user4@example.com') 
   ORDER BY created_at DESC LIMIT 1),
  (SELECT id FROM "user" WHERE email = 'user4@example.com'),
  (SELECT id FROM "user" WHERE email = 'support@transport.ir'),
  'ETC.',
  'Can I upgrade my seat to a window seat?',
  'Yes, please log in to your account and choose "Modify Reservation" to select a new seat.'
);

INSERT INTO report (
  reservation_id, user_id, admin_id, request_type, request_text, response_text
) VALUES (
  (SELECT id FROM reservation 
   WHERE user_id = (SELECT id FROM "user" WHERE email = 'user5@example.com') 
   ORDER BY created_at DESC LIMIT 1),
  (SELECT id FROM "user" WHERE email = 'user5@example.com'),
  (SELECT id FROM "user" WHERE email = 'manager@transport.ir'),
  'ETC.',
  'My payment failed during booking, but money was deducted. What should I do?',
  'We are checking with the payment gateway. If the payment is not confirmed within 24 hours, the amount will be refunded automatically.'
);

INSERT INTO report (
  reservation_id, user_id, admin_id, request_type, request_text, response_text
) VALUES (
  (SELECT id FROM reservation 
   WHERE user_id = (SELECT id FROM "user" WHERE email = 'user3@example.com') 
   ORDER BY created_at DESC LIMIT 1),
  (SELECT id FROM "user" WHERE email = 'user3@example.com'),
  (SELECT id FROM "user" WHERE email = 'admin@transport.ir'),
  'TRAVEL-DELAY',
  'I missed my bus. Can I use the same ticket for the next departure?',
  'Unfortunately, tickets are only valid for the reserved departure time. You will need to purchase a new ticket.'
);