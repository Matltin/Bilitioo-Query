-- Create reservations with payments for various users
-- First, let's create some payments that will be shared between reservations
INSERT INTO "payment" (
  "from_account", 
  "to_account", 
  "amount", 
  "type", 
  "status", 
  "created_at"
) VALUES 
-- Shared payments (will be used by multiple reservations)
('IR12345678901234567890', 'IR98765432109876543210', 2500000, 'BANK_TRANSFER', 'COMPLETED', NOW() - INTERVAL '5 days'),
('IR12345678901234567890', 'IR98765432109876543210', 3800000, 'CREDIT_CARD', 'COMPLETED', NOW() - INTERVAL '4 days'),
('IR12345678901234567890', 'IR98765432109876543210', 1200000, 'WALLET', 'COMPLETED', NOW() - INTERVAL '3 days'),
('IR12345678901234567890', 'IR98765432109876543210', 650000, 'CASH', 'COMPLETED', NOW() - INTERVAL '2 days'),
('IR12345678901234567890', 'IR98765432109876543210', 1800000, 'BANK_TRANSFER', 'COMPLETED', NOW() - INTERVAL '1 day'),

-- Individual payments
('IR11112222333344445555', 'IR98765432109876543210', 950000, 'CREDIT_CARD', 'COMPLETED', NOW() - INTERVAL '6 hours'),
('IR11112222333344445555', 'IR98765432109876543210', 1650000, 'WALLET', 'COMPLETED', NOW() - INTERVAL '5 hours'),
('IR11112222333344445555', 'IR98765432109876543210', 750000, 'BANK_TRANSFER', 'COMPLETED', NOW() - INTERVAL '4 hours'),
('IR11112222333344445555', 'IR98765432109876543210', 3200000, 'CREDIT_CARD', 'COMPLETED', NOW() - INTERVAL '3 hours'),
('IR11112222333344445555', 'IR98765432109876543210', 450000, 'CASH', 'COMPLETED', NOW() - INTERVAL '2 hours'),

-- Failed/Refunded payments
('IR11112222333344445555', 'IR98765432109876543210', 1500000, 'CREDIT_CARD', 'FAILED', NOW() - INTERVAL '1 day'),
('IR11112222333344445555', 'IR98765432109876543210', 2000000, 'BANK_TRANSFER', 'REFUNDED', NOW() - INTERVAL '2 days'),

-- Pending payments
('IR11112222333344445555', 'IR98765432109876543210', 900000, 'CREDIT_CARD', 'PENDING', NOW() - INTERVAL '1 hour'),
('IR11112222333344445555', 'IR98765432109876543210', 1100000, 'WALLET', 'PENDING', NOW() - INTERVAL '30 minutes');

-- Create reservations for users (at least 15 records)
-- First get some user IDs and ticket IDs to work with
DO $$
DECLARE
  user1_id bigint;
  user2_id bigint;
  user3_id bigint;
  admin_id bigint;
  
  ticket1_id bigint;
  ticket2_id bigint;
  ticket3_id bigint;
  ticket4_id bigint;
  ticket5_id bigint;
  ticket6_id bigint;
  ticket7_id bigint;
  ticket8_id bigint;
  ticket9_id bigint;
  ticket10_id bigint;
  
  payment1_id bigint;
  payment2_id bigint;
  payment3_id bigint;
  payment4_id bigint;
  payment5_id bigint;
  payment6_id bigint;
  payment7_id bigint;
  payment8_id bigint;
  payment9_id bigint;
  payment10_id bigint;
BEGIN
  -- Get user IDs
  SELECT id INTO user1_id FROM "user" WHERE email = 'user1@example.com';
  SELECT id INTO user2_id FROM "user" WHERE email = 'user2@example.com';
  SELECT id INTO user3_id FROM "user" WHERE email = 'user3@example.com';
  SELECT id INTO admin_id FROM "user" WHERE email = 'admin@transport.ir';
  
  -- Get ticket IDs (assuming these exist from previous migrations)
  SELECT id INTO ticket1_id FROM "ticket" WHERE vehicle_id = 1 AND route_id = 4 LIMIT 1;
  SELECT id INTO ticket2_id FROM "ticket" WHERE vehicle_id = 3 AND route_id = 7 LIMIT 1;
  SELECT id INTO ticket3_id FROM "ticket" WHERE vehicle_id = 5 AND route_id = 31 LIMIT 1;
  SELECT id INTO ticket4_id FROM "ticket" WHERE vehicle_id = 8 AND route_id = 26 LIMIT 1;
  SELECT id INTO ticket5_id FROM "ticket" WHERE vehicle_id = 11 AND route_id = 3 LIMIT 1;
  SELECT id INTO ticket6_id FROM "ticket" WHERE vehicle_id = 15 AND route_id = 6 LIMIT 1;
  SELECT id INTO ticket7_id FROM "ticket" WHERE vehicle_id = 17 AND route_id = 32 LIMIT 1;
  SELECT id INTO ticket8_id FROM "ticket" WHERE vehicle_id = 18 AND route_id = 2 LIMIT 1;
  SELECT id INTO ticket9_id FROM "ticket" WHERE vehicle_id = 22 AND route_id = 8 LIMIT 1;
  SELECT id INTO ticket10_id FROM "ticket" WHERE vehicle_id = 26 AND route_id = 32 LIMIT 1;
  
  -- Get payment IDs
  SELECT id INTO payment1_id FROM "payment" WHERE amount = 2500000 LIMIT 1;
  SELECT id INTO payment2_id FROM "payment" WHERE amount = 3800000 LIMIT 1;
  SELECT id INTO payment3_id FROM "payment" WHERE amount = 1200000 LIMIT 1;
  SELECT id INTO payment4_id FROM "payment" WHERE amount = 650000 LIMIT 1;
  SELECT id INTO payment5_id FROM "payment" WHERE amount = 1800000 LIMIT 1;
  SELECT id INTO payment6_id FROM "payment" WHERE amount = 950000 LIMIT 1;
  SELECT id INTO payment7_id FROM "payment" WHERE amount = 1650000 LIMIT 1;
  SELECT id INTO payment8_id FROM "payment" WHERE amount = 750000 LIMIT 1;
  SELECT id INTO payment9_id FROM "payment" WHERE amount = 3200000 LIMIT 1;
  SELECT id INTO payment10_id FROM "payment" WHERE amount = 450000 LIMIT 1;
  
  -- Insert reservations (at least 15)
  -- User1 reservations (5 reservations, some sharing payments)
  INSERT INTO "reservation" ("user_id", "ticket_id", "payment_id", "status", "duration_time", "created_at") VALUES
    (user1_id, ticket1_id, payment1_id, 'RESERVED', '10 minutes', NOW() - INTERVAL '5 days'),
    (user1_id, ticket2_id, payment1_id, 'RESERVED', '10 minutes', NOW() - INTERVAL '4 days'),
    (user1_id, ticket3_id, payment2_id, 'RESERVED', '10 minutes', NOW() - INTERVAL '3 days'),
    (user1_id, ticket4_id, payment3_id, 'RESERVED', '10 minutes', NOW() - INTERVAL '2 days'),
    (user1_id, ticket5_id, payment4_id, 'RESERVED', '10 minutes', NOW() - INTERVAL '1 day');
  
  -- User2 reservations (5 reservations)
  INSERT INTO "reservation" ("user_id", "ticket_id", "payment_id", "status", "duration_time", "created_at") VALUES
    (user2_id, ticket6_id, payment5_id, 'RESERVED', '10 minutes', NOW() - INTERVAL '4 days 2 hours'),
    (user2_id, ticket7_id, payment6_id, 'RESERVED', '10 minutes', NOW() - INTERVAL '3 days 5 hours'),
    (user2_id, ticket8_id, payment7_id, 'RESERVED', '10 minutes', NOW() - INTERVAL '2 days 7 hours'),
    (user2_id, ticket9_id, payment8_id, 'RESERVED', '10 minutes', NOW() - INTERVAL '1 day 9 hours'),
    (user2_id, ticket10_id, payment9_id, 'RESERVED', '10 minutes', NOW() - INTERVAL '12 hours');
  
  -- User3 reservations (5 reservations)
  INSERT INTO "reservation" ("user_id", "ticket_id", "payment_id", "status", "duration_time", "created_at") VALUES
    (user3_id, ticket1_id, payment10_id, 'RESERVED', '10 minutes', NOW() - INTERVAL '3 days 4 hours'),
    (user3_id, ticket2_id, NULL, 'RESERVING', '10 minutes', NOW() - INTERVAL '2 days 6 hours'),
    (user3_id, ticket3_id, NULL, 'CANCELED', '10 minutes', NOW() - INTERVAL '1 day 8 hours'),
    (user3_id, ticket4_id, NULL, 'CANCELED-BY-TIME', '10 minutes', NOW() - INTERVAL '10 hours'),
    (user3_id, ticket5_id, NULL, 'RESERVING', '10 minutes', NOW() - INTERVAL '5 hours');
  
