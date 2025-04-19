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
  
  -- Now create change_reservation records for these reservations
  -- Get reservation IDs
  DECLARE
    res1_id bigint;
    res2_id bigint;
    res3_id bigint;
    res4_id bigint;
    res5_id bigint;
    res6_id bigint;
    res7_id bigint;
    res8_id bigint;
    res9_id bigint;
    res10_id bigint;
    res11_id bigint;
    res12_id bigint;
    res13_id bigint;
    res14_id bigint;
    res15_id bigint;
  BEGIN
    -- Get reservation IDs (assuming they're created in order)
    SELECT id INTO res1_id FROM "reservation" WHERE user_id = user1_id AND ticket_id = ticket1_id;
    SELECT id INTO res2_id FROM "reservation" WHERE user_id = user1_id AND ticket_id = ticket2_id;
    SELECT id INTO res3_id FROM "reservation" WHERE user_id = user1_id AND ticket_id = ticket3_id;
    SELECT id INTO res4_id FROM "reservation" WHERE user_id = user1_id AND ticket_id = ticket4_id;
    SELECT id INTO res5_id FROM "reservation" WHERE user_id = user1_id AND ticket_id = ticket5_id;
    SELECT id INTO res6_id FROM "reservation" WHERE user_id = user2_id AND ticket_id = ticket6_id;
    SELECT id INTO res7_id FROM "reservation" WHERE user_id = user2_id AND ticket_id = ticket7_id;
    SELECT id INTO res8_id FROM "reservation" WHERE user_id = user2_id AND ticket_id = ticket8_id;
    SELECT id INTO res9_id FROM "reservation" WHERE user_id = user2_id AND ticket_id = ticket9_id;
    SELECT id INTO res10_id FROM "reservation" WHERE user_id = user2_id AND ticket_id = ticket10_id;
    SELECT id INTO res11_id FROM "reservation" WHERE user_id = user3_id AND ticket_id = ticket1_id;
    SELECT id INTO res12_id FROM "reservation" WHERE user_id = user3_id AND ticket_id = ticket2_id;
    SELECT id INTO res13_id FROM "reservation" WHERE user_id = user3_id AND ticket_id = ticket3_id;
    SELECT id INTO res14_id FROM "reservation" WHERE user_id = user3_id AND ticket_id = ticket4_id;
    SELECT id INTO res15_id FROM "reservation" WHERE user_id = user3_id AND ticket_id = ticket5_id;
    
    -- Create change_reservation records (at least 15)
    INSERT INTO "change_reservation" ("reservation_id", "admin_id", "user_id", "from_status", "to_status") VALUES
      -- Changes for user1's reservations
      (res1_id, admin_id, user1_id, 'RESERVING', 'RESERVED'),
      (res2_id, admin_id, user1_id, 'RESERVING', 'RESERVED'),
      (res3_id, admin_id, user1_id, 'RESERVING', 'RESERVED'),
      (res4_id, admin_id, user1_id, 'RESERVING', 'RESERVED'),
      (res5_id, admin_id, user1_id, 'RESERVING', 'RESERVED'),
      
      -- Changes for user2's reservations
      (res6_id, admin_id, user2_id, 'RESERVING', 'RESERVED'),
      (res7_id, admin_id, user2_id, 'RESERVING', 'RESERVED'),
      (res8_id, admin_id, user2_id, 'RESERVING', 'RESERVED'),
      (res9_id, admin_id, user2_id, 'RESERVING', 'RESERVED'),
      (res10_id, admin_id, user2_id, 'RESERVING', 'RESERVED'),
      
      -- Changes for user3's reservations (including cancellations)
      (res11_id, admin_id, user3_id, 'RESERVING', 'RESERVED'),
      (res12_id, NULL, user3_id, 'RESERVING', 'RESERVING'), -- No admin, status didn't change
      (res13_id, admin_id, user3_id, 'RESERVING', 'CANCELED'),
      (res14_id, NULL, user3_id, 'RESERVING', 'CANCELED-BY-TIME'), -- Automatic cancellation
      (res15_id, NULL, user3_id, 'RESERVING', 'RESERVING'); -- Still in progress
    
    -- Create reports for some of these reservations (at least 15)
    INSERT INTO "report" ("reservation_id", "user_id", "admin_id", "request_type", "request_text", "response_text") VALUES
      -- Reports for user1
      (res1_id, user1_id, admin_id, 'PAYMENT-ISSUE', 'Payment was deducted but reservation not confirmed', 'Issue resolved, reservation confirmed'),
      (res2_id, user1_id, admin_id, 'TRAVEL-DELAY', 'Bus was 2 hours late', 'Apologies, we have issued a 10% discount coupon'),
      (res3_id, user1_id, admin_id, 'ETC.', 'Seat was not as described', 'We have noted your feedback for improvement'),
      
      -- Reports for user2
      (res6_id, user2_id, admin_id, 'PAYMENT-ISSUE', 'Double charged for reservation', 'Refund processed for the extra charge'),
      (res7_id, user2_id, admin_id, 'UNEXPECTED-RESERVED', 'Got a different seat than selected', 'We have upgraded your seat as compensation'),
      (res8_id, user2_id, admin_id, 'TRAVEL-DELAY', 'Flight delayed by 3 hours', 'We provided meal vouchers during the wait'),
      (res9_id, user2_id, admin_id, 'ETC.', 'Lost luggage during travel', 'Luggage located and will be delivered to you'),
      
      -- Reports for user3
      (res11_id, user3_id, admin_id, 'PAYMENT-ISSUE', 'Payment failed but money deducted', 'Payment was actually successful, ticket confirmed'),
      (res12_id, user3_id, admin_id, 'TRAVEL-DELAY', 'Train delayed by 1 hour', 'We apologize for the inconvenience'),
      (res13_id, user3_id, admin_id, 'UNEXPECTED-RESERVED', 'Cancellation fee too high', 'Fee adjusted as per our policy'),
      (res14_id, user3_id, admin_id, 'ETC.', 'Website was slow during booking', 'We are working on performance improvements'),
      
      -- More reports for various issues
      (res1_id, user1_id, admin_id, 'ETC.', 'Driver was rude', 'Driver will receive additional training'),
      (res5_id, user1_id, admin_id, 'TRAVEL-DELAY', 'No AC on the bus', 'Mechanical issue, we have compensated with discount'),
      (res7_id, user2_id, admin_id, 'PAYMENT-ISSUE', 'Receipt not received', 'Receipt resent to your email'),
      (res10_id, user2_id, admin_id, 'UNEXPECTED-RESERVED', 'Wrong departure time shown', 'We have corrected the information');
  END;
END $$;