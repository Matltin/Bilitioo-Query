# Bilitioo-Query

# Travel Booking System - Query Documentation

## Database Schema Overview

This travel booking system manages users, vehicles (buses, trains, airplanes), tickets, reservations, and payments. The system supports multiple vehicle types with specific attributes and handles the complete booking workflow from reservation to payment.

## Stored Procedures

### 1. `get_tickets(inp VARCHAR)`
**Purpose**: Retrieves all completed ticket purchases for a user (by email or phone)

**Returns**: User info, ticket details, and payment information for completed reservations

**Example Output**:
```
user id | ticket id | reservation id | payment id | origin city | destination city | time
--------|-----------|----------------|------------|-------------|------------------|--------------------
   123  |    456    |      789       |    321     |   Tehran    |     Isfahan      | 2024-01-15 14:30:00
   123  |    457    |      790       |    322     |   Isfahan   |     Shiraz       | 2024-01-16 09:15:00
```

### 2. `get_change_reservation(inp VARCHAR)`
**Purpose**: Gets reservation changes made by an admin (cancellations from non-canceled states)

**Returns**: Users whose reservations were canceled by the specified admin

**Example Output**:
```
user id | full name    | from status | to status
--------|--------------|-------------|----------
   101  | John Doe     | RESERVED    | CANCELED
   102  | Jane Smith   | RESERVING   | CANCELED
```

### 3. `get_tickets_city(inp_city VARCHAR)`
**Purpose**: Finds all completed tickets with destination matching the input city

**Returns**: Ticket information for trips to the specified city

**Example Output**:
```
ticket_id | origin_city          | destination_city | vehicle_type
----------|---------------------|------------------|-------------
    456   | Tehran  (Tehran)    | Isfahan          | BUS
    789   | Mashhad  (Mashhad)  | Isfahan          | TRAIN
```

### 4. `get_find_match(inp VARCHAR)`
**Purpose**: Universal search function for tickets by passenger name, cities, or vehicle features

**Returns**: Comprehensive ticket information with vehicle-specific details

**Example Output**:
```
user_id | ticket_id | full_name  | origin_city      | destination_city | extra_info
--------|-----------|------------|------------------|------------------|------------------
   123  |    456    | John Doe   | Tehran (Tehran)  | Isfahan (Isfahan)| VIP
   124  |    789    | Jane Smith | Isfahan (Isfahan)| Shiraz (Fars)    | Train Rank: 4
```

### 5. `get_townsman(inp VARCHAR)`
**Purpose**: Finds all users from the same city as the input user

**Returns**: Fellow citizens of the specified user

**Example Output**:
```
user_id | full_name    | email              | phone_number | city
--------|--------------|-------------------|--------------|------------------
   101  | Alice Brown  | alice@email.com   | 09123456789  | Tehran  (Tehran)
   102  | Bob Wilson   | bob@email.com     | 09987654321  | Tehran  (Tehran)
```

### 6. `get_person_by_time(n INT, start_time TIMESTAMPTZ)`
**Purpose**: Top N users with most completed reservations since a specific date

**Returns**: Most active users in the given time period

**Example Output**:
```
user_id | full_name    | reservation_count
--------|--------------|------------------
   123  | John Doe     |        5
   124  | Jane Smith   |        3
```

### 7. `get_canceld_by_vehicle(inp_vehicle VARCHAR)`
**Purpose**: Lists canceled tickets for a specific vehicle type

**Returns**: Canceled reservations by vehicle type

**Example Output**:
```
ticket_id | vehicle_type | origin_city      | destination_city
----------|--------------|------------------|------------------
    456   | BUS          | Tehran (Tehran)  | Isfahan (Isfahan)
    789   | BUS          | Isfahan (Isfahan)| Shiraz (Fars)
```

### 8. `get_request_type(inp VARCHAR)`
**Purpose**: Finds users with the most reports of a specific type

**Returns**: Users who submitted the maximum number of reports for the given type

**Example Output**:
```
id  | full_name  | report_count
----|------------|-------------
123 | John Doe   | 5
124 | Jane Smith | 5
```

## Regular Queries

### Query 1: Users Without Any Reservations
```sql
SELECT u.id, CONCAT(p.first_name, ' ', p.last_name) AS full_name
FROM "user" u
LEFT JOIN "reservation" r ON u.id = r.user_id
INNER JOIN "profile" p ON u.id = p.user_id
WHERE u.role != 'ADMIN' AND r.id IS NULL
```
**Purpose**: Lists non-admin users who have never made a reservation

**Example Output**:
```
id  | full_name
----|----------
105 | Mike Johnson
106 | Sarah Davis
```

### Query 2: Users With Completed Reservations
```sql
SELECT u.id, CONCAT(pro.first_name, ' ', pro.last_name) AS full_name, 
       u.role, COUNT(r.ticket_id) AS ticket_count
FROM "user" u
INNER JOIN "profile" pro ON u.id = pro.user_id
INNER JOIN "reservation" r ON u.id = r.user_id
INNER JOIN "payment" pa ON pa.id = r.payment_id
WHERE u.role != 'ADMIN' AND pa.status = 'COMPLETED'
GROUP BY u.id, pro.first_name, pro.last_name, u.role
```
**Purpose**: Shows users with at least one completed ticket purchase

**Example Output**:
```
id  | full_name  | role | ticket_count
----|------------|------|-------------
123 | John Doe   | USER | 3
124 | Jane Smith | USER | 2
```

### Query 3: Monthly Payment Summary by User
```sql
SELECT u.id, CONCAT(pro.first_name, ' ', pro.last_name) AS full_name,
       TO_CHAR(pa.created_at, 'YYYY-MM') AS payment_month,
       SUM(pa.amount) AS total_amount
FROM "user" u 
INNER JOIN "reservation" r ON u.id = r.user_id
LEFT JOIN "payment" pa ON r.payment_id = pa.id
JOIN "profile" pro ON u.id = pro.user_id
GROUP BY u.id, pro.first_name, pro.last_name, TO_CHAR(pa.created_at, 'YYYY-MM')
```
**Purpose**: Aggregates user spending by month

**Example Output**:
```
id  | full_name | payment_month | total_amount
----|-----------|---------------|-------------
123 | John Doe  | 2024-01       | 150000
123 | John Doe  | 2024-02       | 200000
```

### Query 4: One-Time Destination Visitors
```sql
SELECT pro.user_id, CONCAT(pro.first_name, ' ', pro.last_name) AS full_name,
       CONCAT(dc.province, '  (', dc.county, ')') AS destination,
       COUNT(dc.county) AS "tripNO."
FROM "profile" pro
INNER JOIN "reservation" re ON pro.user_id = re.user_id
-- ... additional joins
GROUP BY pro.user_id, pro.first_name, pro.last_name, dc.county, dc.province
HAVING COUNT(dc.county) = 1
```
**Purpose**: Users who visited each destination exactly once

**Example Output**:
```
user_id | full_name | destination         | tripNO.
--------|-----------|--------------------|---------
   123  | John Doe  | Isfahan (Isfahan)  |    1
   124  | Jane Smith| Shiraz (Fars)      |    1
```

### Query 5: Most Recent Completed Purchase
```sql
SELECT pro.user_id, CONCAT(pro.first_name, ' ', pro.last_name) AS full_name,
       TO_CHAR(pa.created_at, 'YYYY-MM-DD HH24:MI:SS') AS "created at"
FROM "profile" pro
INNER JOIN "reservation" re ON pro.user_id = re.user_id
-- ... additional joins
WHERE pa.status = 'COMPLETED'
ORDER BY pa.created_at DESC
LIMIT 1
```
**Purpose**: Latest completed ticket purchase in the system

**Example Output**:
```
user_id | full_name | created at
--------|-----------|--------------------
   125  | Bob Smith | 2024-02-15 16:45:30
```

### Query 6: High Spenders (Above Average)
```sql
SELECT u.id, COALESCE(u.email, 'No Email') AS email, 
       COALESCE(u.phone_number, 'No Phone') AS phone_number, 
       SUM(p.amount) AS "total amount"
FROM "user" u
INNER JOIN "reservation" r ON u.id = r.user_id
INNER JOIN "payment" p ON p.id = r.payment_id
GROUP BY u.id, u.email, u.phone_number
HAVING SUM(p.amount) > (SELECT AVG(p.amount) FROM "payment" p WHERE p.status = 'COMPLETED')
```
**Purpose**: Users who spent more than the average payment amount

**Example Output**:
```
id  | email           | phone_number | total amount
----|----------------|--------------|-------------
123 | john@email.com | 09123456789  | 450000
124 | jane@email.com | 09987654321  | 380000
```

### Query 7: Vehicle Type Popularity
```sql
SELECT t.vehicle_type, COUNT(t.id) AS "NO." 
FROM "ticket" t
INNER JOIN "reservation" r ON r.ticket_id = t.id
INNER JOIN "payment" p ON p.id = r.payment_id
WHERE p.status = 'COMPLETED'
GROUP BY t.vehicle_type
ORDER BY "NO." DESC
```
**Purpose**: Ranks vehicle types by number of completed bookings

**Example Output**:
```
vehicle_type | NO.
-------------|----
BUS          | 150
TRAIN        | 89
AIRPLANE     | 45
```

### Query 8: Most Active Users (Last 7 Days)
```sql
SELECT pro.user_id, CONCAT(pro.first_name, ' ', pro.last_name) AS full_name, 
       COUNT(re.id) AS "NO."
FROM "profile" pro
INNER JOIN "reservation" re ON pro.user_id = re.user_id
INNER JOIN "payment" pa ON pa.id = re.payment_id
WHERE pa.status = 'COMPLETED' AND pa.created_at > NOW() - INTERVAL '7 days'
GROUP BY pro.user_id, pro.first_name, pro.last_name
ORDER BY "NO." DESC
LIMIT 3
```
**Purpose**: Top 3 most active users in the past week

**Example Output**:
```
user_id | full_name  | NO.
--------|------------|----
   123  | John Doe   |  5
   124  | Jane Smith |  3
   125  | Bob Wilson |  2
```

### Query 9: Routes from Tehran
```sql
SELECT oc.county AS origin,
       CONCAT(dc.province, '  (', dc.county, ')') AS destination,
       COUNT(dc.county) AS "tripNO."
FROM "ticket" t
INNER JOIN "reservation" re ON t.id = re.ticket_id
INNER JOIN "route" ro ON t.route_id = ro.id
INNER JOIN "city" oc ON oc.id = ro.origin_city_id
INNER JOIN "city" dc ON dc.id = ro.destination_city_id
WHERE oc.county = 'Tehran'
GROUP BY oc.county, dc.province, dc.county
```
**Purpose**: All destinations and trip counts from Tehran

**Example Output**:
```
origin | destination           | tripNO.
-------|----------------------|--------
Tehran | Isfahan (Isfahan)    |   25
Tehran | Shiraz (Fars)        |   18
```

### Query 10: Newest User's Travel Origins
```sql
SELECT u.id, CONCAT(oc.province, '  (', oc.county, ')') AS origin
FROM "user" u
INNER JOIN "reservation" re ON u.id = re.user_id
-- ... additional joins
WHERE u.id = (SELECT u.id FROM "user" u WHERE u.role = 'USER'
              ORDER BY u.created_at DESC LIMIT 1)
  AND pa.status = 'COMPLETED'
GROUP BY u.id, oc.province, oc.county
```
**Purpose**: Shows travel origins for the most recently registered user

**Example Output**:
```
id  | origin
----|--------------------
126 | Tehran  (Tehran)
126 | Isfahan (Isfahan)
```

### Query 11: All Admin Users
```sql
SELECT u.id, CONCAT(pro.first_name, ' ', pro.last_name) AS full_name
FROM "user" u
INNER JOIN "profile" pro ON u.id = pro.user_id
WHERE u.role = 'ADMIN'
ORDER BY u.id
```
**Purpose**: Lists all administrators in the system

**Example Output**:
```
id | full_name
---|----------
 1 | Admin User
 2 | Super Admin
```

### Query 12: Users with Multiple Tickets
```sql
SELECT u.id, CONCAT(pro.first_name, ' ', pro.last_name) AS full_name, 
       u.role, COUNT(r.ticket_id) AS ticket_count
FROM "user" u
INNER JOIN "profile" pro ON u.id = pro.user_id
INNER JOIN "reservation" r ON u.id = r.user_id
INNER JOIN "payment" pa ON pa.id = r.payment_id
WHERE u.role != 'ADMIN' AND pa.status = 'COMPLETED'
GROUP BY u.id, pro.first_name, pro.last_name, u.role
HAVING COUNT(r.ticket_id) > 1
```
**Purpose**: Non-admin users who have purchased more than one ticket

**Example Output**:
```
id  | full_name  | role | ticket_count
----|------------|------|-------------
123 | John Doe   | USER |     5
124 | Jane Smith | USER |     3
```

### Query 13: Users with Few Tickets by Vehicle Type
```sql
SELECT pro.user_id, CONCAT(pro.first_name, ' ', pro.last_name) AS full_name, 
       t.vehicle_type, COUNT(r.ticket_id) AS ticket_count
FROM "profile" pro
INNER JOIN "reservation" r ON pro.user_id = r.user_id
INNER JOIN "payment" pa ON pa.id = r.payment_id
INNER JOIN "ticket" t ON t.id = r.ticket_id
WHERE pa.status = 'COMPLETED'
GROUP BY pro.user_id, pro.first_name, pro.last_name, t.vehicle_type
HAVING COUNT(r.ticket_id) < 3
```
**Purpose**: Users with fewer than 3 tickets per vehicle type

**Example Output**:
```
user_id | full_name  | vehicle_type | ticket_count
--------|------------|--------------|-------------
   123  | John Doe   | BUS          |     2
   123  | John Doe   | TRAIN        |     1
```

### Query 14: Users Who Used All Vehicle Types
```sql
SELECT u.id, COALESCE(u.email, 'No Email') AS email, 
       COALESCE(u.phone_number, 'No Phone') AS phone_number
FROM "user" u
WHERE NOT EXISTS (
    SELECT t.vehicle_type FROM "ticket" t
    WHERE t.vehicle_type IN ('BUS', 'AIRPLANE', 'TRAIN')
    EXCEPT
    SELECT t.vehicle_type FROM "reservation" r
    INNER JOIN "ticket" t ON r.ticket_id = t.id
    INNER JOIN "payment" p ON r.payment_id = p.id
    WHERE r.user_id = u.id AND p.status = 'COMPLETED'
)
```
**Purpose**: Users who have used all three vehicle types (bus, train, airplane)

**Example Output**:
```
id  | email           | phone_number
----|----------------|-------------
123 | john@email.com | 09123456789
125 | bob@email.com  | 09555666777
```

### Query 15: Today's Issued Tickets
```sql
SELECT pro.user_id, CONCAT(pro.first_name, ' ', pro.last_name) AS full_name, 
       t.id AS "ticket id", t.vehicle_type,
       TO_CHAR(pa.created_at, 'YYYY-MM-DD HH24:MI:SS') AS issued
FROM "profile" pro
INNER JOIN "reservation" r ON pro.user_id = r.user_id
INNER JOIN "ticket" t ON t.id = r.ticket_id
INNER JOIN "payment" pa ON pa.id = r.payment_id
WHERE pa.status = 'COMPLETED' AND pa.created_at >= date_trunc('day', now())
ORDER BY pa.created_at
```
**Purpose**: All tickets purchased today

**Example Output**:
```
user_id | full_name | ticket id | vehicle_type | issued
--------|-----------|-----------|--------------|--------------------
   123  | John Doe  |    456    | BUS          | 2024-02-15 09:30:15
   124  | Jane Smith|    457    | TRAIN        | 2024-02-15 14:22:33
```

### Query 16: Second Most Popular Restored Ticket
```sql
SELECT t.id, t.vehicle_type, 
       CONCAT(oc.province, '  (', oc.county, ')') AS origin,
       CONCAT(dc.province, '  (', dc.county, ')') AS destination,
       COUNT(r.id) AS "NO." 
FROM "change_reservation" cr
INNER JOIN "reservation" r ON cr.reservation_id = r.id
INNER JOIN "ticket" t ON t.id = r.ticket_id
-- ... additional joins
WHERE cr.to_status = 'RESERVED'
GROUP BY t.id, t.vehicle_type, oc.province, oc.county, dc.province, dc.county
ORDER BY "NO." DESC
LIMIT 1 OFFSET 1
```
**Purpose**: Second most frequently restored (unreserved to reserved) ticket

**Example Output**:
```
id  | vehicle_type | origin              | destination         | NO.
----|--------------|--------------------|--------------------|----
456 | BUS          | Tehran  (Tehran)   | Isfahan (Isfahan)  |  3
```

### Query 17: Admin with Most Cancellations
```sql
WITH canceled_changes AS (
    SELECT cr.admin_id, CONCAT(pro.first_name, ' ', pro.last_name) AS full_name,
           COUNT(cr.id) AS cancel_count
    FROM change_reservation cr
    INNER JOIN "profile" pro ON pro.user_id = cr.admin_id
    WHERE cr.from_status NOT IN ('CANCELED', 'CANCELED-BY-TIME')
      AND cr.to_status = 'CANCELED'
    GROUP BY cr.admin_id, pro.first_name, pro.last_name
)
SELECT cc.admin_id, cc.full_name, cc.cancel_count AS "NO. of Cancellations",
       ROUND((cc.cancel_count::decimal / tc.total) * 100, 2) AS "Cancellation Percentage"
FROM canceled_changes cc, total_canceled tc
ORDER BY cc.cancel_count DESC
LIMIT 1
```
**Purpose**: Admin who performed the most cancellations with percentage

**Example Output**:
```
admin_id | full_name   | NO. of Cancellations | Cancellation Percentage
---------|-------------|---------------------|----------------------
    2    | Admin Smith |         15          |        45.45
```

### Queries 18-22: Data Modification Operations

**Query 18**: Updates the last name to 'Redington' for the user with most cancellations
**Query 19**: Deletes canceled reservations for users with last name 'Redington'  
**Query 20**: Deletes all canceled reservations from the system
**Query 21**: Applies 10% discount to Iran Peyma company tickets purchased yesterday
**Query 22**: Shows detailed report information for the ticket with most reports

**Example Output for Query 22**:
```
ticket_id | reservation_id | request_type    | request_text        | response_text      | rep_count
----------|----------------|-----------------|--------------------|--------------------|----------
    456   |      789       | PAYMENT-ISSUE   | Payment not working| Issue resolved     |    5
    456   |      790       | TRAVEL-DELAY    | Bus was 2h late    | Compensation given |    5
```

## Key Features

- **Multi-Vehicle Support**: Handles buses, trains, and airplanes with specific attributes
- **Complete Booking Workflow**: From reservation to payment completion
- **Admin Management**: Reservation changes and user management
- **Reporting System**: User complaints and admin responses
- **Time-based Analysis**: Recent activity tracking and historical data
- **Geographic Analysis**: City and route-based queries
- **Financial Tracking**: Payment amounts and user spending patterns
