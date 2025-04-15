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