-- 1)
    SELECT 
        u.id, 
        CONCAT(p.first_name, ' ', p.last_name) AS full_name, 
        u.role,
        COUNT(r.ticket_id) AS ticket_count
    FROM "user" u
    LEFT JOIN "reservation" r ON u.id = r.user_id
    JOIN "profile" p ON u.id = p.user_id
    WHERE u.role != 'ADMIN'
    GROUP BY u.id, p.first_name, p.last_name, u.role, r.status
    HAVING COUNT(r.ticket_id) = 0
    ORDER BY u.id;

-- 2)
    SELECT 
        u.id, 
        CONCAT(pro.first_name, ' ', pro.last_name) AS full_name, 
        u.role,
        COUNT(r.ticket_id) AS ticket_count
    FROM "user" u
	INNER JOIN "profile" pro ON u.id = pro.user_id
    INNER JOIN "reservation" r ON u.id = r.user_id
	INNER JOIN "payment" pa ON pa.id = r.payment_id
    WHERE u.role != 'ADMIN' AND pa.status = 'COMPLETED'
    GROUP BY u.id, pro.first_name, pro.last_name, u.role
    HAVING COUNT(r.ticket_id) > 0
    ORDER BY u.id;

-- 3)
    SELECT 
        u.id, 
        CONCAT(pro.first_name, ' ', pro.last_name) AS full_name,
        TO_CHAR(pa.created_at, 'YYYY-MM') AS payment_month,
        SUM(pa.amount) AS total_amount
    FROM "user" u 
    INNER JOIN "reservation" r ON u.id = r.user_id
    LEFT JOIN "payment" pa ON r.payment_id = pa.id
    JOIN "profile" pro ON u.id = pro.user_id
    GROUP BY u.id, pro.first_name, pro.last_name, TO_CHAR(pa.created_at, 'YYYY-MM')
    HAVING SUM(pa.amount) IS NOT NULL
    ORDER BY u.id, payment_month;

-- 4)
    SELECT 
        u.id,
        CONCAT(pro.first_name, ' ', pro.last_name) AS full_name,
        CONCAT(dc.province, '(', dc.county, ')') AS destination,
        COUNT(dc.county) AS "tripNO."
    FROM "user" u
    INNER JOIN "profile" pro ON u.id = pro.user_id
    INNER JOIN "reservation" re ON u.id = re.user_id
    INNER JOIN "ticket" t ON re.ticket_id = t.id
    INNER JOIN "route" ro ON t.route_id = ro.id
    INNER JOIN "city" oc ON oc.id = ro.origin_city_id
    INNER JOIN "city" dc ON dc.id = ro.destination_city_id
    GROUP BY u.id, pro.first_name, pro.last_name, dc.county, dc.province
    HAVING COUNT(dc.county) = 1
    ORDER BY u.id;

