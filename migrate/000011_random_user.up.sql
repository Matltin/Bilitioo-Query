-- Create random admin users
INSERT INTO "user" (
  "email", 
  "phone_number", 
  "hashed_password", 
  "role", 
  "status", 
  "phone_verified", 
  "email_verified"
) VALUES 
-- Admin users
('admin@transport.ir', '09123456789', 'test_password', 'ADMIN', 'ACTIVE', true, true),
('manager@transport.ir', '09123456788', 'test_password', 'ADMIN', 'ACTIVE', true, true),
('support@transport.ir', '09123456787', 'test_password', 'ADMIN', 'ACTIVE', true, true);

-- Create admin profiles
INSERT INTO "profile" (
  "user_id", 
  "pic_dir", 
  "first_name", 
  "last_name", 
  "city_id", 
  "national_code"
) VALUES 
-- Admin profiles (matching the admin users above)
((SELECT id FROM "user" WHERE email = 'admin@transport.ir'), 
 NULL, 'Ali', 'Ahmadi', 
 (SELECT id FROM "city" WHERE county = 'Tehran'), '0082345678'),
 
((SELECT id FROM "user" WHERE email = 'manager@transport.ir'), 
 NULL, 'Maryam', 'Hosseini', 
 (SELECT id FROM "city" WHERE county = 'Tehran'), '0072345679'),
 
((SELECT id FROM "user" WHERE email = 'support@transport.ir'), 
 NULL, 'Reza', 'Mohammadi', 
 (SELECT id FROM "city" WHERE county = 'Mashhad'), '0062345677');

-- Create regular users
INSERT INTO "user" (
  "email", 
  "phone_number", 
  "hashed_password", 
  "role", 
  "status", 
  "phone_verified", 
  "email_verified"
) VALUES 
-- Regular users (10 users with both email and phone)
('user1@example.com', '09123456700', 'test_password', 'USER', 'ACTIVE', true, true),
('user2@example.com', '09123456701', 'test_password', 'USER', 'ACTIVE', true, true),
('user3@example.com', '09123456702', 'test_password', 'USER', 'ACTIVE', true, true),
('user4@example.com', '09123456703', 'test_password', 'USER', 'ACTIVE', true, false),
('user5@example.com', '09123456704', 'test_password', 'USER', 'ACTIVE', true, false),

-- Users with only phone numbers
(NULL, '09123456705', 'test_password', 'USER', 'ACTIVE', true, false),
(NULL, '09123456706', 'test_password', 'USER', 'ACTIVE', true, false),

-- Users with only emails
('user8@example.com', NULL, 'test_password', 'USER', 'ACTIVE', false, true),
('user9@example.com', NULL, 'test_password', 'USER', 'ACTIVE', false, true),

-- One inactive user
('inactive@example.com', '09123456710', 'test_password', 'USER', 'NON-ACTIVE', true, true);

-- Create regular user profiles
INSERT INTO "profile" (
  "user_id", 
  "pic_dir", 
  "first_name", 
  "last_name", 
  "city_id", 
  "national_code"
) VALUES 
-- Complete profiles for users 1-3 (but no pictures)
((SELECT id FROM "user" WHERE email = 'user1@example.com'), 
 NULL, 'Hassan', 'Karimi', 
 (SELECT id FROM "city" WHERE county = 'Tehran'), '0052345671'),
 
((SELECT id FROM "user" WHERE email = 'user2@example.com'), 
 NULL, 'Zahra', 'Rahimi', 
 (SELECT id FROM "city" WHERE county = 'Isfahan'), '0042345672'),
 
((SELECT id FROM "user" WHERE email = 'user3@example.com'), 
 NULL, 'Mohammad', 'Ghasemi', 
 (SELECT id FROM "city" WHERE county = 'Shiraz'), '0032345673'),

-- Partial profiles for users 4-5
((SELECT id FROM "user" WHERE email = 'user4@example.com'), 
 NULL, 'Sara', 'Jafari', 
 (SELECT id FROM "city" WHERE county = 'Mashhad'), '0022345674'),
 
((SELECT id FROM "user" WHERE email = 'user5@example.com'), 
 NULL, 'Amir', 'Moradi', 
 (SELECT id FROM "city" WHERE county = 'Tabriz'), '0012345675'),

-- Minimal profiles for phone-only users
((SELECT id FROM "user" WHERE phone_number = '09123456705'), 
 NULL, 'Fatima', 'Sadeghi', 
 NULL, NULL),
 
((SELECT id FROM "user" WHERE phone_number = '09123456706'), 
 NULL, 'Hamid', 'Rezaei', 
 NULL, NULL),

-- Minimal profiles for email-only users
((SELECT id FROM "user" WHERE email = 'user8@example.com'), 
 NULL, 'Leila', 'Amini', 
 NULL, NULL),
 
((SELECT id FROM "user" WHERE email = 'user9@example.com'), 
 NULL, 'Javad', 'Kazemi', 
 NULL, NULL),

-- Profile for inactive user
((SELECT id FROM "user" WHERE email = 'inactive@example.com'), 
 NULL, 'Ehsan', 'Bagheri', 
 (SELECT id FROM "city" WHERE county = 'Urmia'), '0002345670');

-- Create some reports (communication between users and admins)
INSERT INTO "report" (
  "user_id",
  "admin_id",
  "request_text",
  "response_text"
) VALUES
-- User 1 reports
((SELECT id FROM "user" WHERE email = 'user1@example.com'),
 (SELECT id FROM "user" WHERE email = 'admin@transport.ir'),
 'I need to cancel my bus ticket for tomorrow. Is it possible to get a refund?',
 'Yes, you can cancel the ticket up to 4 hours before departure time with a 90% refund. Please use the cancellation option in your account.'),

((SELECT id FROM "user" WHERE email = 'user1@example.com'),
 (SELECT id FROM "user" WHERE email = 'support@transport.ir'),
 'The air conditioning was not working properly on my last trip. Can I file a complaint?',
 'We apologize for the inconvenience. I have forwarded your complaint to the bus company and they will contact you within 48 hours.'),

-- User 2 reports
((SELECT id FROM "user" WHERE email = 'user2@example.com'),
 (SELECT id FROM "user" WHERE email = 'manager@transport.ir'),
 'I lost my luggage on the Tehran-Isfahan train yesterday. How can I track it?',
 'Please provide your ticket details and luggage description. I will coordinate with the lost and found department to help locate your items.'),

-- User 3 reports
((SELECT id FROM "user" WHERE email = 'user3@example.com'),
 (SELECT id FROM "user" WHERE email = 'admin@transport.ir'),
 'Can I change my travel date from next Monday to Wednesday without additional charges?',
 'Yes, you can modify your travel date once without any fee if done at least 48 hours before departure. Please use the modify option in your booking.'),

-- User with phone only report
((SELECT id FROM "user" WHERE phone_number = '09123456705'),
 (SELECT id FROM "user" WHERE email = 'support@transport.ir'),
 'I need to book a VIP bus from Tehran to Mashhad for a family of 5. Do you have group discounts?',
 'For groups of 5 or more, we offer a 10% discount. Please book through our call center at 021-12345678 and mention your group size.'),

-- Inactive user report (from when they were active)
((SELECT id FROM "user" WHERE email = 'inactive@example.com'),
 (SELECT id FROM "user" WHERE email = 'admin@transport.ir'),
 'My account shows wrong booking history. Can you fix this issue?',
 'We will investigate this issue. Please allow 24-48 hours for our technical team to resolve it.');